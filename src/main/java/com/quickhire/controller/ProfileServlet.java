package com.quickhire.controller;

import com.quickhire.dao.UserDAO;
import com.quickhire.model.User;
import com.quickhire.util.PasswordUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet for handling user profile operations
 */
@WebServlet(urlPatterns = {
    "/profile",
    "/profile/edit",
    "/profile/change-password",
    "/freelancer/profile/*",
    "/company/profile/*"
})
public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        try {
            // Check if user is authenticated
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            switch (path) {
                case "/profile":
                    if (currentUser.isFreelancer()) {
                        response.sendRedirect(request.getContextPath() + "/freelancer/profile");
                    } else if (currentUser.isCompany()) {
                        response.sendRedirect(request.getContextPath() + "/company/profile");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    }
                    break;
                    
                case "/profile/edit":
                    request.setAttribute("currentUser", currentUser);
                    if (currentUser.isFreelancer()) {
                        request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
                    } else if (currentUser.isCompany()) {
                        request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    }
                    break;
                    
                case "/freelancer/profile":
                    if (pathInfo != null) {
                        viewFreelancerProfile(request, response, pathInfo.substring(1));
                    } else {
                        request.setAttribute("currentUser", currentUser);
                        request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
                    }
                    break;
                    
                case "/company/profile":
                    if (pathInfo != null) {
                        viewCompanyProfile(request, response, pathInfo.substring(1));
                    } else {
                        request.setAttribute("currentUser", currentUser);
                        request.getRequestDispatcher("/company/dashboard.jsp").forward(request, response);
                    }
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath());
                    break;
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        try {
            // Check if user is authenticated
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            switch (path) {
                case "/profile/edit":
                    updateProfile(request, response, currentUser);
                    break;
                    
                case "/profile/change-password":
                    changePassword(request, response, currentUser);
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath());
                    break;
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * View a freelancer's profile
     */
    private void viewFreelancerProfile(HttpServletRequest request, HttpServletResponse response, String userIdStr)
            throws ServletException, IOException, SQLException {
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User freelancer = userDAO.findById(userId);
            
            if (freelancer != null && freelancer.isFreelancer() && freelancer.isActive()) {
                request.setAttribute("freelancer", freelancer);
                request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/jobs");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }
    
    /**
     * View a company's profile
     */
    private void viewCompanyProfile(HttpServletRequest request, HttpServletResponse response, String userIdStr)
            throws ServletException, IOException, SQLException {
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User company = userDAO.findById(userId);
            
            if (company != null && company.isCompany() && company.isActive()) {
                request.setAttribute("company", company);
                request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/jobs");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/jobs");
        }
    }
    
    /**
     * Update a user's profile
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException, SQLException {
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String bio = request.getParameter("bio");
        String location = request.getParameter("location");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        
        // Additional fields based on role
        String companyName = request.getParameter("companyName");
        String title = request.getParameter("title");
        String skills = request.getParameter("skills");
        
        // Validate required fields
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            
            String errorMessage = "First name, last name, and email are required";
            request.setAttribute("error", errorMessage);
            request.setAttribute("currentUser", currentUser);
            
            if (currentUser.isFreelancer()) {
                request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
            }
            return;
        }
        
        // Check if company name is provided for company accounts
        if (currentUser.isCompany() && (companyName == null || companyName.trim().isEmpty())) {
            request.setAttribute("error", "Company name is required");
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
            return;
        }
        
        // Check if title and skills are provided for freelancer accounts
        if (currentUser.isFreelancer() && 
            ((title == null || title.trim().isEmpty()) || 
             (skills == null || skills.trim().isEmpty()))) {
            request.setAttribute("error", "Professional title and skills are required");
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
            return;
        }
        
        // Check if email is changed and already in use by another user
        if (!email.equals(currentUser.getEmail())) {
            User existingUser = userDAO.findByEmail(email);
            if (existingUser != null && existingUser.getId() != currentUser.getId()) {
                request.setAttribute("error", "Email is already in use by another account");
                request.setAttribute("currentUser", currentUser);
                
                if (currentUser.isFreelancer()) {
                    request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
                }
                return;
            }
        }
        
        // Update user object
        currentUser.setFirstName(firstName);
        currentUser.setLastName(lastName);
        currentUser.setEmail(email);
        currentUser.setBio(bio);
        currentUser.setLocation(location);
        currentUser.setPhone(phone);
        currentUser.setWebsite(website);
        
        if (currentUser.isCompany()) {
            currentUser.setCompanyName(companyName);
        }
        
        if (currentUser.isFreelancer()) {
            currentUser.setTitle(title);
            currentUser.setSkills(skills);
        }
        
        // Save updated user to database
        userDAO.update(currentUser);
        
        // Update session
        HttpSession session = request.getSession();
        session.setAttribute("user", currentUser);
        
        // Redirect to profile page with success message
        String successParam = "?success=Profile updated successfully!";
        if (currentUser.isFreelancer()) {
            response.sendRedirect(request.getContextPath() + "/freelancer/profile" + successParam);
        } else {
            response.sendRedirect(request.getContextPath() + "/company/profile" + successParam);
        }
    }
    
    /**
     * Change a user's password
     */
    private void changePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException, SQLException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            setPasswordError(request, response, currentUser, "All fields are required");
            return;
        }
        
        // Verify current password
        if (!PasswordUtils.verifyPassword(currentPassword, currentUser.getPassword())) {
            setPasswordError(request, response, currentUser, "Current password is incorrect");
            return;
        }
        
        // Check password match
        if (!newPassword.equals(confirmPassword)) {
            setPasswordError(request, response, currentUser, "New passwords do not match");
            return;
        }
        
        // Check password strength (simple check)
        if (newPassword.length() < 8) {
            setPasswordError(request, response, currentUser, "Password must be at least 8 characters long");
            return;
        }
        
        // Update password in database
        String hashedPassword = PasswordUtils.hashNewPassword(newPassword);
        userDAO.updatePassword(currentUser.getId(), hashedPassword);
        
        // Update user in session
        currentUser.setPassword(hashedPassword);
        HttpSession session = request.getSession();
        session.setAttribute("user", currentUser);
        
        // Redirect to profile page with success message
        String successParam = "?passwordSuccess=Password changed successfully!";
        if (currentUser.isFreelancer()) {
            response.sendRedirect(request.getContextPath() + "/freelancer/profile" + successParam);
        } else {
            response.sendRedirect(request.getContextPath() + "/company/profile" + successParam);
        }
    }
    
    /**
     * Set password error and forward to appropriate page
     */
    private void setPasswordError(HttpServletRequest request, HttpServletResponse response, User currentUser, String errorMessage)
            throws ServletException, IOException {
        
        request.setAttribute("passwordError", errorMessage);
        request.setAttribute("currentUser", currentUser);
        
        if (currentUser.isFreelancer()) {
            request.getRequestDispatcher("/freelancer/profile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/company/profile.jsp").forward(request, response);
        }
    }
}
