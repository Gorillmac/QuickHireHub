package com.quickhire.servlet;

import java.io.IOException;
import java.io.PrintWriter;
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

import org.json.JSONObject;

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
        System.out.println("LoginServlet initialized");
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("Login request received");
        
        // Set response type to JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        try {
            // Retrieve form parameters
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            boolean rememberMe = "on".equals(request.getParameter("rememberMe"));
            
            System.out.println("Login attempt for email: " + email);
            
            // Validate input
            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                jsonResponse.put("error", "Email and password are required");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Authentication logic
            Optional<User> userOpt = userDAO.findByEmail(email);
            
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                
                // Check if user is active
                if (!user.isActive()) {
                    jsonResponse.put("error", "Your account has been deactivated. Please contact support.");
                    out.print(jsonResponse.toString());
                    return;
                }
                
                // Verify password with salt
                if (PasswordUtil.verifyPassword(password, user.getPasswordHash(), user.getSalt())) {
                    // Authentication successful
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("userId", user.getId().toString());
                    session.setAttribute("userRole", user.getUserType());
                    session.setAttribute("userEmail", user.getEmail());
                    session.setAttribute("userName", user.getFullName());
                    
                    // Set session timeout (default: 30 minutes, extended if remember me is checked)
                    if (rememberMe) {
                        session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 days
                    } else {
                        session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    }
                    
                    // Determine the redirect URL based on user role
                    String redirectUrl = "";
                    if (user.isFreelancer()) {
                        redirectUrl = "freelancer-dashboard.html";
                    } else if (user.isClient()) {
                        redirectUrl = "client-dashboard.html";
                    } else if (user.isAdmin()) {
                        redirectUrl = "admin-dashboard.html";
                    } else {
                        redirectUrl = "index.html";
                    }
                    
                    System.out.println("Login successful. Redirecting to: " + redirectUrl);
                    
                    jsonResponse.put("success", "Login successful");
                    jsonResponse.put("redirect", redirectUrl);
                    jsonResponse.put("userRole", user.getUserType());
                } else {
                    System.out.println("Password verification failed");
                    jsonResponse.put("error", "Invalid email or password");
                }
            } else {
                System.out.println("User not found with email: " + email);
                jsonResponse.put("error", "Invalid email or password");
            }
        } catch (Exception e) {
            System.err.println("Login error: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.put("error", "An error occurred during login. Please try again.");
        }
        
        out.print(jsonResponse.toString());
    }
    
    /**
     * Handle GET requests - redirect to login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Simply forward to the login page
        response.sendRedirect("login.html");
    }
}