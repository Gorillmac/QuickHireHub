package com.quickhire.servlet;

import java.io.IOException;
import java.util.Optional;

import com.quickhire.dao.UserDAO;
import com.quickhire.model.User;
import com.quickhire.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle user login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Retrieve form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("remember"));
        
        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Authentication logic
        Optional<User> userOpt = userDAO.findByEmail(email);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String hashedPassword = PasswordUtil.hashPassword(password);
            
            if (hashedPassword != null && hashedPassword.equals(user.getPasswordHash())) {
                // Authentication successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId().toString());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userType", user.getUserType());
                
                // Set session timeout (30 minutes by default, 7 days if remember me is checked)
                if (rememberMe) {
                    session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 days in seconds
                }
                
                // Redirect to appropriate dashboard based on user type
                if ("freelancer".equalsIgnoreCase(user.getUserType())) {
                    response.sendRedirect("freelancer-dashboard.jsp");
                } else if ("client".equalsIgnoreCase(user.getUserType())) {
                    response.sendRedirect("client-dashboard.jsp");
                } else if ("admin".equalsIgnoreCase(user.getUserType())) {
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    response.sendRedirect("index.jsp");
                }
                
                return;
            }
        }
        
        // Authentication failed
        request.setAttribute("error", "Invalid email or password");
        request.setAttribute("email", email); // Preserve email input
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            // User is already logged in, redirect based on user type
            String userType = (String) session.getAttribute("userType");
            if ("freelancer".equalsIgnoreCase(userType)) {
                response.sendRedirect("freelancer-dashboard.jsp");
            } else if ("client".equalsIgnoreCase(userType)) {
                response.sendRedirect("client-dashboard.jsp");
            } else if ("admin".equalsIgnoreCase(userType)) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // User is not logged in, show login page
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}