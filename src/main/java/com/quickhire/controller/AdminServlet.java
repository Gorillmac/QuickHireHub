package com.quickhire.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.quickhire.dao.JobDAO;
import com.quickhire.dao.UserDAO;
import com.quickhire.dao.ReportDAO;
import com.quickhire.model.Job;
import com.quickhire.model.User;
import com.quickhire.model.Report;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling admin operations
 */
@WebServlet(urlPatterns = {
        "/dashboard-admin", 
        "/admin/jobs/approve/*", 
        "/admin/jobs/reject/*",
        "/admin/users", 
        "/admin/users/toggle-status/*",
        "/admin/reports"
})
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private JobDAO jobDAO;
    private UserDAO userDAO;
    private ReportDAO reportDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        jobDAO = new JobDAO();
        userDAO = new UserDAO();
        reportDAO = new ReportDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Check if user is admin
        if (!AuthUtil.isLoggedIn(request) || !AuthUtil.hasRole(request, User.ROLE_ADMIN)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            switch (path) {
                case "/dashboard-admin":
                    // Admin dashboard
                    showAdminDashboard(request, response);
                    break;
                    
                case "/admin/jobs/approve":
                    // Approve a job
                    String approvePathInfo = request.getPathInfo();
                    if (approvePathInfo != null && !approvePathInfo.equals("/")) {
                        try {
                            int jobId = Integer.parseInt(approvePathInfo.substring(1));
                            approveJob(request, response, jobId);
                            return;
                        } catch (NumberFormatException e) {
                            // Invalid job ID, continue to dashboard
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/dashboard-admin");
                    break;
                    
                case "/admin/jobs/reject":
                    // Reject a job
                    String rejectPathInfo = request.getPathInfo();
                    if (rejectPathInfo != null && !rejectPathInfo.equals("/")) {
                        try {
                            int jobId = Integer.parseInt(rejectPathInfo.substring(1));
                            rejectJob(request, response, jobId);
                            return;
                        } catch (NumberFormatException e) {
                            // Invalid job ID, continue to dashboard
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/dashboard-admin");
                    break;
                    
                case "/admin/users":
                    // List all users
                    listUsers(request, response);
                    break;
                    
                case "/admin/users/toggle-status":
                    // Suspend/activate a user
                    String userPathInfo = request.getPathInfo();
                    if (userPathInfo != null && !userPathInfo.equals("/")) {
                        try {
                            int userId = Integer.parseInt(userPathInfo.substring(1));
                            toggleUserStatus(request, response, userId);
                            return;
                        } catch (NumberFormatException e) {
                            // Invalid user ID, continue to users list
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
                    
                case "/admin/reports":
                    // List all reports
                    listReports(request, response);
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard-admin");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // For admin actions, we're using GET for simplicity
        // If needed, POST implementations can be added here
        doGet(request, response);
    }
    
    /**
     * Show admin dashboard
     */
    private void showAdminDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // Get unapproved jobs
        List<Job> unapprovedJobs = jobDAO.findUnapproved();
        
        // Get pending reports count
        List<Report> pendingReports = reportDAO.findPending();
        
        // Get total counts for users and jobs
        List<User> allUsers = userDAO.findAll();
        List<Job> allJobs = jobDAO.findAll();
        
        int freelancerCount = 0;
        int companyCount = 0;
        
        for (User user : allUsers) {
            if (user.isFreelancer()) {
                freelancerCount++;
            } else if (user.isCompany()) {
                companyCount++;
            }
        }
        
        // Set attributes for dashboard
        request.setAttribute("unapprovedJobs", unapprovedJobs);
        request.setAttribute("pendingReports", pendingReports);
        request.setAttribute("userCount", allUsers.size());
        request.setAttribute("jobCount", allJobs.size());
        request.setAttribute("freelancerCount", freelancerCount);
        request.setAttribute("companyCount", companyCount);
        
        request.getRequestDispatcher("/dashboard-admin.jsp").forward(request, response);
    }
    
    /**
     * Approve a job
     */
    private void approveJob(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        jobDAO.approveJob(jobId);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Job approved successfully");
        response.sendRedirect(request.getContextPath() + "/dashboard-admin");
    }
    
    /**
     * Reject a job (delete it)
     */
    private void rejectJob(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        jobDAO.delete(jobId);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Job rejected and deleted successfully");
        response.sendRedirect(request.getContextPath() + "/dashboard-admin");
    }
    
    /**
     * List all users
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
    }
    
    /**
     * Toggle user active status (suspend/activate)
     */
    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException, SQLException {
        User user = userDAO.findById(userId);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        // Cannot deactivate admin users
        if (user.isAdmin()) {
            request.getSession().setAttribute("errorMessage", "Cannot change status of admin users");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        // Toggle active status
        boolean newStatus = !user.isActive();
        userDAO.setActiveStatus(userId, newStatus);
        
        // Redirect with success message
        String statusMessage = newStatus ? "activated" : "suspended";
        request.getSession().setAttribute("successMessage", "User " + statusMessage + " successfully");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
    
    /**
     * List all reports
     */
    private void listReports(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Report> reports = reportDAO.findAll();
        
        // Get user details for each report
        for (Report report : reports) {
            User reporter = userDAO.findById(report.getReporterId());
            User reportedUser = userDAO.findById(report.getReportedUserId());
            
            report.setAttribute("reporter", reporter);
            report.setAttribute("reportedUser", reportedUser);
        }
        
        request.setAttribute("reports", reports);
        request.getRequestDispatcher("/admin-reports.jsp").forward(request, response);
    }
}
