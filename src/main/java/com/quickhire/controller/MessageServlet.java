package com.quickhire.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.quickhire.dao.MessageDAO;
import com.quickhire.dao.UserDAO;
import com.quickhire.dao.JobDAO;
import com.quickhire.model.Message;
import com.quickhire.model.User;
import com.quickhire.model.Job;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling messaging operations
 */
@WebServlet(urlPatterns = {
        "/messages", 
        "/messages/conversation/*", 
        "/messages/send",
        "/messages/job-conversation/*"
})
public class MessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private MessageDAO messageDAO;
    private UserDAO userDAO;
    private JobDAO jobDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        messageDAO = new MessageDAO();
        userDAO = new UserDAO();
        jobDAO = new JobDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Require login for all message operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            switch (path) {
                case "/messages":
                    // Show messages inbox
                    showInbox(request, response);
                    break;
                    
                case "/messages/conversation":
                    // Show conversation with a specific user
                    String conversationPathInfo = request.getPathInfo();
                    if (conversationPathInfo == null || conversationPathInfo.equals("/")) {
                        response.sendRedirect(request.getContextPath() + "/messages");
                        return;
                    }
                    
                    try {
                        UUID userId = UUID.fromString(conversationPathInfo.substring(1));
                        showConversation(request, response, userId, null); // null means no job context
                    } catch (IllegalArgumentException e) {
                        response.sendRedirect(request.getContextPath() + "/messages");
                    }
                    break;
                    
                case "/messages/job-conversation":
                    // Show conversation in context of a specific job
                    String jobConversationPathInfo = request.getPathInfo();
                    if (jobConversationPathInfo == null || jobConversationPathInfo.equals("/")) {
                        response.sendRedirect(request.getContextPath() + "/messages");
                        return;
                    }
                    
                    // Path format: /user_id-job_id
                    String[] parts = jobConversationPathInfo.substring(1).split("-");
                    if (parts.length != 2) {
                        response.sendRedirect(request.getContextPath() + "/messages");
                        return;
                    }
                    
                    try {
                        UUID userId = UUID.fromString(parts[0]);
                        UUID jobId = UUID.fromString(parts[1]);
                        showConversation(request, response, userId, jobId);
                    } catch (IllegalArgumentException e) {
                        response.sendRedirect(request.getContextPath() + "/messages");
                    }
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/messages");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Require login for all message operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/messages/send".equals(path)) {
                // Send a new message
                sendMessage(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/messages");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    /**
     * Show messages inbox
     */
    private void showInbox(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User currentUser = AuthUtil.getUserFromSession(request);
        
        // Get received messages
        List<Message> receivedMessages = messageDAO.findByReceiver(currentUser.getId());
        
        // Group messages by sender
        // We'll do this in the JSP, but prepare user data here
        
        // Get total unread message count
        int unreadCount = messageDAO.getUnreadCount(currentUser.getId());
        
        request.setAttribute("messages", receivedMessages);
        request.setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("/messages.jsp").forward(request, response);
    }
    
    /**
     * Show conversation with a specific user
     */
    private void showConversation(HttpServletRequest request, HttpServletResponse response, 
            UUID otherUserId, UUID jobId) throws ServletException, IOException, SQLException {
        User currentUser = AuthUtil.getUserFromSession(request);
        User otherUser = userDAO.findById(otherUserId).orElse(null);
        
        if (otherUser == null) {
            response.sendRedirect(request.getContextPath() + "/messages");
            return;
        }
        
        List<Message> conversation;
        Job job = null;
        
        if (jobId != null) {
            // Get job-specific conversation
            conversation = messageDAO.getJobConversation(currentUser.getId(), otherUserId, jobId);
            job = jobDAO.findById(jobId);
            
            if (job == null) {
                response.sendRedirect(request.getContextPath() + "/messages");
                return;
            }
        } else {
            // Get general conversation
            conversation = messageDAO.getConversation(currentUser.getId(), otherUserId);
        }
        
        // Mark messages from other user as read
        messageDAO.markAllAsRead(otherUserId, currentUser.getId());
        
        request.setAttribute("conversation", conversation);
        request.setAttribute("otherUser", otherUser);
        request.setAttribute("job", job);
        request.getRequestDispatcher("/conversation.jsp").forward(request, response);
    }
    
    /**
     * Send a new message
     */
    private void sendMessage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User sender = AuthUtil.getUserFromSession(request);
        
        // Get form parameters
        String receiverIdStr = request.getParameter("receiverId");
        String content = request.getParameter("content");
        String jobIdStr = request.getParameter("jobId");
        String redirect = request.getParameter("redirect");
        
        // Validate input
        if (receiverIdStr == null || content == null || content.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Message content is required");
            
            if (redirect != null && !redirect.isEmpty()) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/messages");
            }
            return;
        }
        
        try {
            UUID receiverId = UUID.fromString(receiverIdStr);
            
            // Check if receiver exists
            User receiver = userDAO.findById(receiverId).orElse(null);
            if (receiver == null) {
                throw new IllegalArgumentException("Invalid receiver");
            }
            
            // Create message object
            Message message = new Message();
            message.setSenderId(sender.getId());
            message.setReceiverId(receiverId);
            message.setContent(content);
            message.setRead(false);
            
            // Add job context if provided
            if (jobIdStr != null && !jobIdStr.trim().isEmpty()) {
                try {
                    UUID jobId = UUID.fromString(jobIdStr);
                    Job job = jobDAO.findById(jobId);
                    
                    if (job != null) {
                        message.setJobId(jobId);
                    }
                } catch (IllegalArgumentException e) {
                    // Invalid job ID, ignore
                }
            }
            
            // Save message to database
            message = messageDAO.create(message);
            
            // Redirect with success message
            request.getSession().setAttribute("successMessage", "Message sent successfully");
            
            if (redirect != null && !redirect.isEmpty()) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/messages/conversation/" + receiverId);
            }
            
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Invalid recipient");
            
            if (redirect != null && !redirect.isEmpty()) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/messages");
            }
        }
    }
}
