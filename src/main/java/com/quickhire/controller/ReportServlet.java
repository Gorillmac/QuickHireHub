package com.quickhire.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.quickhire.dao.ReportDAO;
import com.quickhire.dao.UserDAO;
import com.quickhire.model.Report;
import com.quickhire.model.User;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling report operations
 */
@WebServlet(urlPatterns = {
        "/reports/create/*", 
        "/reports/update/*"
})
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ReportDAO reportDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        reportDAO = new ReportDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Require login for all report operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/reports/create".equals(path)) {
                // Show report creation form
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                
                try {
                    UUID reportedUserId = UUID.fromString(pathInfo.substring(1));
                    showReportForm(request, response, reportedUserId);
                } catch (IllegalArgumentException e) {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Require login for all report operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/reports/create".equals(path)) {
                // Create a new report
                createReport(request, response);
            } else if ("/reports/update".equals(path)) {
                // Update report status (admin only)
                if (!AuthUtil.hasRole(request, User.ROLE_ADMIN)) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/admin/reports");
                    return;
                }
                
                try {
                    int reportId = Integer.parseInt(pathInfo.substring(1));
                    updateReport(request, response, reportId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/reports");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    /**
     * Show report creation form
     */
    private void showReportForm(HttpServletRequest request, HttpServletResponse response, UUID reportedUserId) 
            throws ServletException, IOException, SQLException {
        User reporter = AuthUtil.getUserFromSession(request);
        Optional<User> reportedUserOptional = userDAO.findById(reportedUserId);
        User reportedUser = reportedUserOptional.orElse(null);
        
        if (reportedUser == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Cannot report yourself
        if (reporter.getId().equals(reportedUserId)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.setAttribute("reportedUser", reportedUser);
        request.getRequestDispatcher("/report-form.jsp").forward(request, response);
    }
    
    /**
     * Create a new report
     */
    private void createReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User reporter = AuthUtil.getUserFromSession(request);
        
        // Get form parameters
        String reportedUserIdStr = request.getParameter("reportedUserId");
        String reason = request.getParameter("reason");
        String description = request.getParameter("description");
        
        // Validate input
        if (reportedUserIdStr == null || reason == null || reason.trim().isEmpty() || 
            description == null || description.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            
            if (reportedUserIdStr != null) {
                try {
                    UUID reportedUserId = UUID.fromString(reportedUserIdStr);
                    showReportForm(request, response, reportedUserId);
                    return;
                } catch (IllegalArgumentException e) {
                    // Invalid user ID, redirect to home
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        try {
            UUID reportedUserId = UUID.fromString(reportedUserIdStr);
            
            // Check if reported user exists
            Optional<User> reportedUserOptional = userDAO.findById(reportedUserId);
            User reportedUser = reportedUserOptional.orElse(null);
            if (reportedUser == null) {
                throw new IllegalArgumentException("Invalid user");
            }
            
            // Cannot report yourself
            if (reporter.getId().equals(reportedUserId)) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
            
            // Create report object
            Report report = new Report();
            report.setReporterId(reporter.getId());
            report.setReportedUserId(reportedUserId);
            report.setReason(reason);
            report.setDescription(description);
            report.setStatus(Report.STATUS_PENDING);
            
            // Save report to database
            report = reportDAO.create(report);
            
            // Redirect with success message
            request.getSession().setAttribute("successMessage", "Report submitted successfully");
            response.sendRedirect(request.getContextPath() + "/");
            
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
    
    /**
     * Update report status (admin only)
     */
    private void updateReport(HttpServletRequest request, HttpServletResponse response, UUID reportId) 
            throws ServletException, IOException, SQLException {
        User admin = AuthUtil.getUserFromSession(request);
        
        // Get form parameters
        String status = request.getParameter("status");
        String adminNotes = request.getParameter("adminNotes");
        
        // Validate input
        if (status == null || status.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Status is required");
            response.sendRedirect(request.getContextPath() + "/admin/reports");
            return;
        }
        
        // Validate status
        boolean validStatus = status.equals(Report.STATUS_INVESTIGATING) || 
                             status.equals(Report.STATUS_RESOLVED) || 
                             status.equals(Report.STATUS_DISMISSED);
        
        if (!validStatus) {
            request.getSession().setAttribute("errorMessage", "Invalid status");
            response.sendRedirect(request.getContextPath() + "/admin/reports");
            return;
        }
        
        // Get report
        Report report = reportDAO.findById(reportId);
        
        if (report == null) {
            response.sendRedirect(request.getContextPath() + "/admin/reports");
            return;
        }
        
        // Update report
        reportDAO.updateStatus(reportId, status, admin.getId(), adminNotes);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Report updated successfully");
        response.sendRedirect(request.getContextPath() + "/admin/reports");
    }
}
