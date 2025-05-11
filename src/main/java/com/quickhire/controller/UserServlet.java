package com.quickhire.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.quickhire.dao.UserDAO;
import com.quickhire.dao.ReviewDAO;
import com.quickhire.model.User;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling user profile operations
 */
@WebServlet(urlPatterns = {"/profile", "/profile/edit", "/profile/view/*"})
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    private ReviewDAO reviewDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        reviewDAO = new ReviewDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Require login for all profile operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            switch (path) {
                case "/profile":
                    // View own profile
                    showUserProfile(request, response);
                    break;
                    
                case "/profile/edit":
                    // Show edit profile form
                    showEditProfileForm(request, response);
                    break;
                    
                case "/profile/view":
                    // View another user's profile
                    String pathInfo = request.getPathInfo();
                    if (pathInfo == null || pathInfo.equals("/")) {
                        response.sendRedirect(request.getContextPath() + "/");
                        return;
                    }
                    
                    // Extract user ID from path
                    try {
                        UUID userId = UUID.fromString(pathInfo.substring(1));
                        viewUserProfile(request, response, userId);
                    } catch (IllegalArgumentException e) {
                        response.sendRedirect(request.getContextPath() + "/");
                    }
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
        
        // Require login for all profile operations
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            if ("/profile/edit".equals(path)) {
                // Process profile update
                updateProfile(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    /**
     * Show the current user's profile
     */
    private void showUserProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User user = AuthUtil.getUserFromSession(request);
        
        // Get updated user data from database
        user = userDAO.findById(user.getId());
        
        // Get average rating
        double averageRating = reviewDAO.getAverageRating(user.getId());
        
        request.setAttribute("user", user);
        request.setAttribute("averageRating", averageRating);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
    
    /**
     * Show the edit profile form
     */
    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User user = AuthUtil.getUserFromSession(request);
        
        // Get updated user data from database
        user = userDAO.findById(user.getId());
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile-edit.jsp").forward(request, response);
    }
    
    /**
     * View another user's profile
     */
    private void viewUserProfile(HttpServletRequest request, HttpServletResponse response, UUID userId) 
            throws ServletException, IOException, SQLException {
        User currentUser = AuthUtil.getUserFromSession(request);
        Optional<User> profileUserOptional = userDAO.findById(userId);
        User profileUser = profileUserOptional.orElse(null);
        
        if (profileUser == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // If viewing own profile, redirect to profile page
        if (currentUser.getId().equals(userId)) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        // Get average rating
        double averageRating = reviewDAO.getAverageRating(profileUser.getId());
        
        request.setAttribute("profileUser", profileUser);
        request.setAttribute("averageRating", averageRating);
        request.getRequestDispatcher("/profile-view.jsp").forward(request, response);
    }
    
    /**
     * Update user profile
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        User user = AuthUtil.getUserFromSession(request);
        
        // Get updated user from database
        user = userDAO.findById(user.getId());
        
        // Update basic fields
        String fullName = request.getParameter("fullName");
        String location = request.getParameter("location");
        String phoneNumber = request.getParameter("phoneNumber");
        String profileDescription = request.getParameter("profileDescription");
        
        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName);
        }
        
        if (location != null) {
            user.setLocation(location);
        }
        
        if (phoneNumber != null) {
            user.setPhoneNumber(phoneNumber);
        }
        
        if (profileDescription != null) {
            user.setProfileDescription(profileDescription);
        }
        
        // Role-specific fields
        if (user.isFreelancer()) {
            String skills = request.getParameter("skills");
            if (skills != null) {
                user.setSkills(skills);
            }
        } else if (user.isCompany()) {
            String companyName = request.getParameter("companyName");
            String companyWebsite = request.getParameter("companyWebsite");
            
            if (companyName != null && !companyName.trim().isEmpty()) {
                user.setCompanyName(companyName);
            }
            
            if (companyWebsite != null) {
                user.setCompanyWebsite(companyWebsite);
            }
        }
        
        // Save updated user
        userDAO.update(user);
        
        // Update user in session
        AuthUtil.storeUserInSession(request, user);
        
        // Redirect back to profile with success message
        request.getSession().setAttribute("successMessage", "Profile updated successfully");
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
