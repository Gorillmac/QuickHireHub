package com.quickhire.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quickhire.dao.ApplicationDAO;
import com.quickhire.dao.JobDAO;
import com.quickhire.dao.UserDAO;
import com.quickhire.model.Application;
import com.quickhire.model.Job;
import com.quickhire.model.User;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling job application operations
 */
@WebServlet(urlPatterns = {
        "/applications/create/*", 
        "/applications/view/*", 
        "/applications/withdraw/*",
        "/applications/accept/*",
        "/applications/reject/*"
})
public class ApplicationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ApplicationDAO applicationDAO;
    private JobDAO jobDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        applicationDAO = new ApplicationDAO();
        jobDAO = new JobDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Require login for all application operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/applications/create".equals(path)) {
                // Show application form
                if (!AuthUtil.hasRole(request, User.ROLE_FREELANCER)) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                    return;
                }
                
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                    return;
                }
                
                try {
                    int jobId = Integer.parseInt(pathInfo.substring(1));
                    showApplicationForm(request, response, jobId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                }
            } else if ("/applications/view".equals(path)) {
                // View application details
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
                    return;
                }
                
                try {
                    int applicationId = Integer.parseInt(pathInfo.substring(1));
                    viewApplicationDetails(request, response, applicationId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
                }
            } else if ("/applications/withdraw".equals(path)) {
                // Withdraw an application
                if (!AuthUtil.hasRole(request, User.ROLE_FREELANCER)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
                    return;
                }
                
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
                    return;
                }
                
                try {
                    int applicationId = Integer.parseInt(pathInfo.substring(1));
                    withdrawApplication(request, response, applicationId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
                }
            } else if ("/applications/accept".equals(path)) {
                // Accept an application
                if (!AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-company");
                    return;
                }
                
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-company");
                    return;
                }
                
                try {
                    int applicationId = Integer.parseInt(pathInfo.substring(1));
                    acceptApplication(request, response, applicationId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-company");
                }
            } else if ("/applications/reject".equals(path)) {
                // Reject an application
                if (!AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-company");
                    return;
                }
                
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-company");
                    return;
                }
                
                try {
                    int applicationId = Integer.parseInt(pathInfo.substring(1));
                    rejectApplication(request, response, applicationId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/dashboard-company");
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
        
        // Require login for all application operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/applications/create".equals(path)) {
                // Create a new application
                if (!AuthUtil.hasRole(request, User.ROLE_FREELANCER)) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                    return;
                }
                
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                    return;
                }
                
                try {
                    int jobId = Integer.parseInt(pathInfo.substring(1));
                    createApplication(request, response, jobId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    /**
     * Show application form for a job
     */
    private void showApplicationForm(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        User freelancer = AuthUtil.getUserFromSession(request);
        
        // Check if the freelancer has already applied for this job
        if (applicationDAO.hasApplied(jobId, freelancer.getId())) {
            request.getSession().setAttribute("errorMessage", "You have already applied for this job");
            response.sendRedirect(request.getContextPath() + "/jobs/view/" + jobId);
            return;
        }
        
        // Get job details
        Job job = jobDAO.findById(jobId);
        
        if (job == null || !job.isOpen() || !job.isApproved()) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }
        
        // Get company details
        User company = userDAO.findById(job.getCompanyId());
        
        request.setAttribute("job", job);
        request.setAttribute("company", company);
        request.getRequestDispatcher("/application-form.jsp").forward(request, response);
    }
    
    /**
     * Create a new application
     */
    private void createApplication(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        User freelancer = AuthUtil.getUserFromSession(request);
        
        // Check if the freelancer has already applied for this job
        if (applicationDAO.hasApplied(jobId, freelancer.getId())) {
            request.getSession().setAttribute("errorMessage", "You have already applied for this job");
            response.sendRedirect(request.getContextPath() + "/jobs/view/" + jobId);
            return;
        }
        
        // Get job details
        Job job = jobDAO.findById(jobId);
        
        if (job == null || !job.isOpen() || !job.isApproved()) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }
        
        // Get form parameters
        String coverLetter = request.getParameter("coverLetter");
        String proposedRateStr = request.getParameter("proposedRate");
        String estimatedDurationStr = request.getParameter("estimatedDuration");
        
        // Validate input
        if (coverLetter == null || coverLetter.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Cover letter is required");
            showApplicationForm(request, response, jobId);
            return;
        }
        
        // Parse proposed rate
        BigDecimal proposedRate = null;
        try {
            if (proposedRateStr != null && !proposedRateStr.trim().isEmpty()) {
                proposedRate = new BigDecimal(proposedRateStr);
                
                if (proposedRate.compareTo(BigDecimal.ZERO) <= 0) {
                    request.setAttribute("errorMessage", "Proposed rate must be greater than zero");
                    showApplicationForm(request, response, jobId);
                    return;
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid proposed rate");
            showApplicationForm(request, response, jobId);
            return;
        }
        
        // Parse estimated duration
        int estimatedDuration = 0;
        try {
            if (estimatedDurationStr != null && !estimatedDurationStr.trim().isEmpty()) {
                estimatedDuration = Integer.parseInt(estimatedDurationStr);
                
                if (estimatedDuration <= 0) {
                    request.setAttribute("errorMessage", "Estimated duration must be greater than zero");
                    showApplicationForm(request, response, jobId);
                    return;
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid estimated duration");
            showApplicationForm(request, response, jobId);
            return;
        }
        
        // Create application object
        Application application = new Application();
        application.setJobId(jobId);
        application.setFreelancerId(freelancer.getId());
        application.setCoverLetter(coverLetter);
        application.setProposedRate(proposedRate);
        application.setEstimatedDuration(estimatedDuration);
        application.setStatus(Application.STATUS_PENDING);
        
        // Save application to database
        application = applicationDAO.create(application);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Application submitted successfully");
        response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
    }
    
    /**
     * View application details
     */
    private void viewApplicationDetails(HttpServletRequest request, HttpServletResponse response, int applicationId) 
            throws ServletException, IOException, SQLException {
        User user = AuthUtil.getUserFromSession(request);
        Application application = applicationDAO.findById(applicationId);
        
        if (application == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Get job and company details
        Job job = jobDAO.findById(application.getJobId());
        User company = userDAO.findById(job.getCompanyId());
        User freelancer = userDAO.findById(application.getFreelancerId());
        
        // Check if user has permission to view this application
        boolean hasPermission = user.isAdmin() || 
                               (user.isFreelancer() && user.getId() == application.getFreelancerId()) || 
                               (user.isCompany() && user.getId() == job.getCompanyId());
        
        if (!hasPermission) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.setAttribute("application", application);
        request.setAttribute("job", job);
        request.setAttribute("company", company);
        request.setAttribute("freelancer", freelancer);
        request.getRequestDispatcher("/application-details.jsp").forward(request, response);
    }
    
    /**
     * Withdraw an application
     */
    private void withdrawApplication(HttpServletRequest request, HttpServletResponse response, int applicationId) 
            throws ServletException, IOException, SQLException {
        User freelancer = AuthUtil.getUserFromSession(request);
        Application application = applicationDAO.findById(applicationId);
        
        if (application == null || application.getFreelancerId() != freelancer.getId()) {
            response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
            return;
        }
        
        // Only pending applications can be withdrawn
        if (!application.isPending()) {
            request.getSession().setAttribute("errorMessage", "Only pending applications can be withdrawn");
            response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
            return;
        }
        
        // Update application status
        applicationDAO.updateStatus(applicationId, Application.STATUS_WITHDRAWN);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Application withdrawn successfully");
        response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
    }
    
    /**
     * Accept an application
     */
    private void acceptApplication(HttpServletRequest request, HttpServletResponse response, int applicationId) 
            throws ServletException, IOException, SQLException {
        User company = AuthUtil.getUserFromSession(request);
        Application application = applicationDAO.findById(applicationId);
        
        if (application == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Get job details
        Job job = jobDAO.findById(application.getJobId());
        
        if (job == null || job.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Only pending applications can be accepted
        if (!application.isPending()) {
            request.getSession().setAttribute("errorMessage", "Only pending applications can be accepted");
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Update application status
        applicationDAO.updateStatus(applicationId, Application.STATUS_ACCEPTED);
        
        // Get other applications for this job and reject them
        List<Application> otherApplications = applicationDAO.findByJobId(job.getId());
        for (Application other : otherApplications) {
            if (other.getId() != applicationId && other.isPending()) {
                applicationDAO.updateStatus(other.getId(), Application.STATUS_REJECTED);
            }
        }
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Application accepted successfully");
        response.sendRedirect(request.getContextPath() + "/dashboard-company");
    }
    
    /**
     * Reject an application
     */
    private void rejectApplication(HttpServletRequest request, HttpServletResponse response, int applicationId) 
            throws ServletException, IOException, SQLException {
        User company = AuthUtil.getUserFromSession(request);
        Application application = applicationDAO.findById(applicationId);
        
        if (application == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Get job details
        Job job = jobDAO.findById(application.getJobId());
        
        if (job == null || job.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Only pending applications can be rejected
        if (!application.isPending()) {
            request.getSession().setAttribute("errorMessage", "Only pending applications can be rejected");
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Update application status
        applicationDAO.updateStatus(applicationId, Application.STATUS_REJECTED);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Application rejected successfully");
        response.sendRedirect(request.getContextPath() + "/dashboard-company");
    }
}
