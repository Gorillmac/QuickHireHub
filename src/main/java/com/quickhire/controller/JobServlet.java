package com.quickhire.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quickhire.dao.JobDAO;
import com.quickhire.dao.ApplicationDAO;
import com.quickhire.dao.UserDAO;
import com.quickhire.model.Job;
import com.quickhire.model.User;
import com.quickhire.model.Application;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling job-related operations
 */
@WebServlet(urlPatterns = {
        "/jobs", 
        "/jobs/search", 
        "/jobs/create", 
        "/jobs/edit/*", 
        "/jobs/view/*", 
        "/jobs/close/*",
        "/dashboard-company",
        "/dashboard-freelancer"
})
public class JobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private JobDAO jobDAO;
    private UserDAO userDAO;
    private ApplicationDAO applicationDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        jobDAO = new JobDAO();
        userDAO = new UserDAO();
        applicationDAO = new ApplicationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            switch (path) {
                case "/jobs":
                    // List all jobs
                    listJobs(request, response);
                    break;
                    
                case "/jobs/search":
                    // Search jobs
                    searchJobs(request, response);
                    break;
                    
                case "/jobs/create":
                    // Show job creation form
                    if (!AuthUtil.isLoggedIn(request) || !AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                        response.sendRedirect(request.getContextPath() + "/login");
                        return;
                    }
                    
                    request.getRequestDispatcher("/job-post.jsp").forward(request, response);
                    break;
                    
                case "/jobs/edit":
                    // Show job edit form
                    if (!AuthUtil.isLoggedIn(request) || !AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                        response.sendRedirect(request.getContextPath() + "/login");
                        return;
                    }
                    
                    // Extract job ID from path
                    String editPathInfo = request.getPathInfo();
                    if (editPathInfo == null || editPathInfo.equals("/")) {
                        response.sendRedirect(request.getContextPath() + "/jobs");
                        return;
                    }
                    
                    try {
                        int editJobId = Integer.parseInt(editPathInfo.substring(1));
                        showEditJobForm(request, response, editJobId);
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/jobs");
                    }
                    break;
                    
                case "/jobs/view":
                    // View job details
                    String viewPathInfo = request.getPathInfo();
                    if (viewPathInfo == null || viewPathInfo.equals("/")) {
                        response.sendRedirect(request.getContextPath() + "/jobs");
                        return;
                    }
                    
                    try {
                        int viewJobId = Integer.parseInt(viewPathInfo.substring(1));
                        viewJobDetails(request, response, viewJobId);
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/jobs");
                    }
                    break;
                    
                case "/jobs/close":
                    // Close a job
                    if (!AuthUtil.isLoggedIn(request) || !AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                        response.sendRedirect(request.getContextPath() + "/login");
                        return;
                    }
                    
                    String closePathInfo = request.getPathInfo();
                    if (closePathInfo == null || closePathInfo.equals("/")) {
                        response.sendRedirect(request.getContextPath() + "/jobs");
                        return;
                    }
                    
                    try {
                        int closeJobId = Integer.parseInt(closePathInfo.substring(1));
                        closeJob(request, response, closeJobId);
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/jobs");
                    }
                    break;
                    
                case "/dashboard-company":
                    // Company dashboard
                    if (!AuthUtil.isLoggedIn(request) || !AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                        response.sendRedirect(request.getContextPath() + "/login");
                        return;
                    }
                    
                    showCompanyDashboard(request, response);
                    break;
                    
                case "/dashboard-freelancer":
                    // Freelancer dashboard
                    if (!AuthUtil.isLoggedIn(request) || !AuthUtil.hasRole(request, User.ROLE_FREELANCER)) {
                        response.sendRedirect(request.getContextPath() + "/login");
                        return;
                    }
                    
                    showFreelancerDashboard(request, response);
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/");
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
        
        // Check authentication for post operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/jobs/create".equals(path)) {
                // Create a new job
                if (!AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                
                createJob(request, response);
            } else if ("/jobs/edit".equals(path)) {
                // Update an existing job
                if (!AuthUtil.hasRole(request, User.ROLE_COMPANY)) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                
                // Extract job ID from path
                String editPathInfo = request.getPathInfo();
                if (editPathInfo == null || editPathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                    return;
                }
                
                try {
                    int editJobId = Integer.parseInt(editPathInfo.substring(1));
                    updateJob(request, response, editJobId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/jobs");
                }
            } else if ("/jobs/search".equals(path)) {
                // Search jobs
                searchJobs(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    /**
     * List all open jobs
     */
    private void listJobs(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Job> jobs = jobDAO.findAllOpen();
        request.setAttribute("jobs", jobs);
        request.getRequestDispatcher("/job-search.jsp").forward(request, response);
    }
    
    /**
     * Search jobs by title, description, or skills
     */
    private void searchJobs(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String query = request.getParameter("query");
        
        List<Job> jobs;
        if (query != null && !query.trim().isEmpty()) {
            jobs = jobDAO.search(query);
            request.setAttribute("searchQuery", query);
        } else {
            jobs = jobDAO.findAllOpen();
        }
        
        request.setAttribute("jobs", jobs);
        request.getRequestDispatcher("/job-search.jsp").forward(request, response);
    }
    
    /**
     * Show job details
     */
    private void viewJobDetails(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        Job job = jobDAO.findById(jobId);
        
        if (job == null) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }
        
        // Get company details
        User company = userDAO.findById(job.getCompanyId());
        
        // Check if the current user has applied for this job
        boolean hasApplied = false;
        if (AuthUtil.isLoggedIn(request) && AuthUtil.hasRole(request, User.ROLE_FREELANCER)) {
            User freelancer = AuthUtil.getUserFromSession(request);
            hasApplied = applicationDAO.hasApplied(jobId, freelancer.getId());
        }
        
        request.setAttribute("job", job);
        request.setAttribute("company", company);
        request.setAttribute("hasApplied", hasApplied);
        request.getRequestDispatcher("/job-details.jsp").forward(request, response);
    }
    
    /**
     * Show job edit form
     */
    private void showEditJobForm(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        User company = AuthUtil.getUserFromSession(request);
        Job job = jobDAO.findById(jobId);
        
        if (job == null || job.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        request.setAttribute("job", job);
        request.setAttribute("editing", true);
        request.getRequestDispatcher("/job-post.jsp").forward(request, response);
    }
    
    /**
     * Create a new job
     */
    private void createJob(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User company = AuthUtil.getUserFromSession(request);
        
        // Get parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String requirements = request.getParameter("requirements");
        String location = request.getParameter("location");
        String budgetStr = request.getParameter("budget");
        String paymentType = request.getParameter("paymentType");
        String duration = request.getParameter("duration");
        String category = request.getParameter("category");
        String skills = request.getParameter("skills");
        
        // Validate input
        if (title == null || title.trim().isEmpty() || 
            description == null || description.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Title and description are required");
            request.getRequestDispatcher("/job-post.jsp").forward(request, response);
            return;
        }
        
        // Parse budget
        BigDecimal budget = null;
        try {
            if (budgetStr != null && !budgetStr.trim().isEmpty()) {
                budget = new BigDecimal(budgetStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid budget amount");
            request.getRequestDispatcher("/job-post.jsp").forward(request, response);
            return;
        }
        
        // Create job object
        Job job = new Job();
        job.setCompanyId(company.getId());
        job.setTitle(title);
        job.setDescription(description);
        job.setRequirements(requirements);
        job.setLocation(location);
        job.setBudget(budget);
        job.setPaymentType(paymentType);
        job.setDuration(duration);
        job.setCategory(category);
        job.setSkills(skills);
        job.setStatus(Job.STATUS_OPEN);
        
        // Set expiration date (30 days from now)
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, 30);
        job.setExpiresAt(new Timestamp(calendar.getTimeInMillis()));
        
        // Set approval status (initially false, admin must approve)
        job.setApproved(false);
        
        // Save job to database
        job = jobDAO.create(job);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Job posted successfully. It will be reviewed by an admin before publishing.");
        response.sendRedirect(request.getContextPath() + "/dashboard-company");
    }
    
    /**
     * Update an existing job
     */
    private void updateJob(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        User company = AuthUtil.getUserFromSession(request);
        Job job = jobDAO.findById(jobId);
        
        if (job == null || job.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Get parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String requirements = request.getParameter("requirements");
        String location = request.getParameter("location");
        String budgetStr = request.getParameter("budget");
        String paymentType = request.getParameter("paymentType");
        String duration = request.getParameter("duration");
        String category = request.getParameter("category");
        String skills = request.getParameter("skills");
        
        // Validate input
        if (title == null || title.trim().isEmpty() || 
            description == null || description.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Title and description are required");
            request.setAttribute("job", job);
            request.setAttribute("editing", true);
            request.getRequestDispatcher("/job-post.jsp").forward(request, response);
            return;
        }
        
        // Parse budget
        BigDecimal budget = null;
        try {
            if (budgetStr != null && !budgetStr.trim().isEmpty()) {
                budget = new BigDecimal(budgetStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid budget amount");
            request.setAttribute("job", job);
            request.setAttribute("editing", true);
            request.getRequestDispatcher("/job-post.jsp").forward(request, response);
            return;
        }
        
        // Update job object
        job.setTitle(title);
        job.setDescription(description);
        job.setRequirements(requirements);
        job.setLocation(location);
        job.setBudget(budget);
        job.setPaymentType(paymentType);
        job.setDuration(duration);
        job.setCategory(category);
        job.setSkills(skills);
        
        // Set approval status to false again (needs re-approval)
        job.setApproved(false);
        
        // Save updated job to database
        job = jobDAO.update(job);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Job updated successfully. It will be reviewed by an admin before publishing.");
        response.sendRedirect(request.getContextPath() + "/dashboard-company");
    }
    
    /**
     * Close a job
     */
    private void closeJob(HttpServletRequest request, HttpServletResponse response, int jobId) 
            throws ServletException, IOException, SQLException {
        User company = AuthUtil.getUserFromSession(request);
        Job job = jobDAO.findById(jobId);
        
        if (job == null || job.getCompanyId() != company.getId()) {
            response.sendRedirect(request.getContextPath() + "/dashboard-company");
            return;
        }
        
        // Close the job
        jobDAO.closeJob(jobId);
        
        // Redirect with success message
        request.getSession().setAttribute("successMessage", "Job closed successfully");
        response.sendRedirect(request.getContextPath() + "/dashboard-company");
    }
    
    /**
     * Show company dashboard
     */
    private void showCompanyDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User company = AuthUtil.getUserFromSession(request);
        
        // Get all jobs posted by the company
        List<Job> jobs = jobDAO.findByCompanyId(company.getId());
        
        request.setAttribute("jobs", jobs);
        request.getRequestDispatcher("/dashboard-company.jsp").forward(request, response);
    }
    
    /**
     * Show freelancer dashboard
     */
    private void showFreelancerDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User freelancer = AuthUtil.getUserFromSession(request);
        
        // Get all applications by the freelancer
        List<Application> applications = applicationDAO.findByFreelancerId(freelancer.getId());
        
        // For each application, get the job details
        for (Application application : applications) {
            Job job = jobDAO.findById(application.getJobId());
            application.setAttribute("job", job);
            
            if (job != null) {
                User company = userDAO.findById(job.getCompanyId());
                application.setAttribute("company", company);
            }
        }
        
        // Get recommended jobs based on freelancer skills
        List<Job> recommendedJobs = null;
        if (freelancer.getSkills() != null && !freelancer.getSkills().isEmpty()) {
            // Split skills by comma and search for first skill
            String[] skillsArray = freelancer.getSkills().split(",");
            if (skillsArray.length > 0) {
                recommendedJobs = jobDAO.search(skillsArray[0].trim());
            }
        }
        
        // If no recommended jobs based on skills, get all open jobs
        if (recommendedJobs == null || recommendedJobs.isEmpty()) {
            recommendedJobs = jobDAO.findAllOpen();
        }
        
        request.setAttribute("applications", applications);
        request.setAttribute("recommendedJobs", recommendedJobs);
        request.getRequestDispatcher("/dashboard-freelancer.jsp").forward(request, response);
    }
}
