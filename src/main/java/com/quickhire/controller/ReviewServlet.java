package com.quickhire.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.quickhire.dao.ReviewDAO;
import com.quickhire.dao.JobDAO;
import com.quickhire.dao.UserDAO;
import com.quickhire.dao.ApplicationDAO;
import com.quickhire.model.Review;
import com.quickhire.model.Job;
import com.quickhire.model.User;
import com.quickhire.model.Application;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling review operations
 */
@WebServlet(urlPatterns = {
        "/reviews/create/*", 
        "/reviews/user/*"
})
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ReviewDAO reviewDAO;
    private JobDAO jobDAO;
    private UserDAO userDAO;
    private ApplicationDAO applicationDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        reviewDAO = new ReviewDAO();
        jobDAO = new JobDAO();
        userDAO = new UserDAO();
        applicationDAO = new ApplicationDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            if ("/reviews/create".equals(path)) {
                // Show review creation form
                if (!AuthUtil.isLoggedIn(request)) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                
                // Path format: /user_id-job_id
                String[] parts = pathInfo.substring(1).split("-");
                if (parts.length != 2) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                
                try {
                    int userId = Integer.parseInt(parts[0]);
                    int jobId = Integer.parseInt(parts[1]);
                    showReviewForm(request, response, userId, jobId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            } else if ("/reviews/user".equals(path)) {
                // Show reviews for a user
                String pathInfo = request.getPathInfo();
                if (pathInfo == null || pathInfo.equals("/")) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
                
                try {
                    int userId = Integer.parseInt(pathInfo.substring(1));
                    showUserReviews(request, response, userId);
                } catch (NumberFormatException e) {
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
        
        // Require login for all review operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/reviews/create".equals(path)) {
                // Create a new review
                createReview(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    /**
     * Show review creation form
     */
    private void showReviewForm(HttpServletRequest request, HttpServletResponse response, 
            int reviewedUserId, int jobId) throws ServletException, IOException, SQLException {
        User reviewer = AuthUtil.getUserFromSession(request);
        User reviewedUser = userDAO.findById(reviewedUserId);
        Job job = jobDAO.findById(jobId);
        
        if (reviewedUser == null || job == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Cannot review yourself
        if (reviewer.getId() == reviewedUserId) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Check if there's a relationship for this job
        boolean canReview = false;
        
        if (reviewer.isCompany() && reviewedUser.isFreelancer()) {
            // Company can review freelancer if the freelancer has an accepted application for this job
            List<Application> applications = applicationDAO.findByJobId(jobId);
            for (Application app : applications) {
                if (app.getFreelancerId() == reviewedUserId && app.isAccepted()) {
                    canReview = true;
                    break;
                }
            }
        } else if (reviewer.isFreelancer() && reviewedUser.isCompany()) {
            // Freelancer can review company if they have an accepted application for this job
            List<Application> applications = applicationDAO.findByFreelancerId(reviewer.getId());
            for (Application app : applications) {
                if (app.getJobId() == jobId && app.isAccepted()) {
                    canReview = true;
                    break;
                }
            }
        }
        
        if (!canReview) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Check if already reviewed
        if (reviewDAO.hasReviewed(reviewer.getId(), jobId)) {
            request.getSession().setAttribute("errorMessage", "You have already reviewed this job");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.setAttribute("reviewedUser", reviewedUser);
        request.setAttribute("job", job);
        request.getRequestDispatcher("/review-form.jsp").forward(request, response);
    }
    
    /**
     * Create a new review
     */
    private void createReview(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User reviewer = AuthUtil.getUserFromSession(request);
        
        // Get form parameters
        String reviewedUserIdStr = request.getParameter("reviewedUserId");
        String jobIdStr = request.getParameter("jobId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        
        // Validate input
        if (reviewedUserIdStr == null || jobIdStr == null || ratingStr == null || 
            comment == null || comment.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            
            if (reviewedUserIdStr != null && jobIdStr != null) {
                try {
                    int reviewedUserId = Integer.parseInt(reviewedUserIdStr);
                    int jobId = Integer.parseInt(jobIdStr);
                    showReviewForm(request, response, reviewedUserId, jobId);
                    return;
                } catch (NumberFormatException e) {
                    // Invalid IDs, redirect to home
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        try {
            int reviewedUserId = Integer.parseInt(reviewedUserIdStr);
            int jobId = Integer.parseInt(jobIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                request.setAttribute("errorMessage", "Rating must be between 1 and 5");
                showReviewForm(request, response, reviewedUserId, jobId);
                return;
            }
            
            // Check if already reviewed
            if (reviewDAO.hasReviewed(reviewer.getId(), jobId)) {
                request.getSession().setAttribute("errorMessage", "You have already reviewed this job");
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
            
            // Create review object
            Review review = new Review();
            review.setReviewerId(reviewer.getId());
            review.setReviewedUserId(reviewedUserId);
            review.setJobId(jobId);
            review.setRating(rating);
            review.setComment(comment);
            
            // Save review to database
            review = reviewDAO.create(review);
            
            // Redirect with success message
            request.getSession().setAttribute("successMessage", "Review submitted successfully");
            response.sendRedirect(request.getContextPath() + "/reviews/user/" + reviewedUserId);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
    
    /**
     * Show reviews for a user
     */
    private void showUserReviews(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException, SQLException {
        User user = userDAO.findById(userId);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Get reviews for the user
        List<Review> reviews = reviewDAO.findByReviewedUser(userId);
        
        // Get reviewer details for each review
        for (Review review : reviews) {
            User reviewer = userDAO.findById(review.getReviewerId());
            Job job = jobDAO.findById(review.getJobId());
            
            review.setAttribute("reviewer", reviewer);
            review.setAttribute("job", job);
        }
        
        // Get average rating
        double averageRating = reviewDAO.getAverageRating(userId);
        
        request.setAttribute("user", user);
        request.setAttribute("reviews", reviews);
        request.setAttribute("averageRating", averageRating);
        request.getRequestDispatcher("/user-reviews.jsp").forward(request, response);
    }
}
