package com.quickhire.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Optional;
import java.util.UUID;

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
 * Servlet to handle user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        System.out.println("RegisterServlet initialized");
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("Registration request received at: " + new java.util.Date());
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Content type: " + request.getContentType());
        
        // Set response type to JSON
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        try {
            // Retrieve form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String userType = request.getParameter("userType"); // freelancer or client
            
            System.out.println("Registration attempt for email: " + email + ", user type: " + userType);
            
            // Validate input
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty() ||
                userType == null || userType.trim().isEmpty()) {
                
                jsonResponse.put("error", "All fields are required");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Validate email format
            String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
            if (!email.matches(emailRegex)) {
                jsonResponse.put("error", "Please enter a valid email address");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Check if passwords match
            if (!password.equals(confirmPassword)) {
                jsonResponse.put("error", "Passwords do not match");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Check password length
            if (password.length() < 8) {
                jsonResponse.put("error", "Password must be at least 8 characters long");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Check if user already exists
            Optional<User> existingUser = userDAO.findByEmail(email);
            if (existingUser.isPresent()) {
                jsonResponse.put("error", "Email is already registered");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Create new user
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setUserType(userType.toUpperCase());
            
            // Generate salt and hash password
            String salt = PasswordUtil.generateSalt();
            String passwordHash = PasswordUtil.hashPasswordWithSalt(password, salt);
            
            user.setSalt(salt);
            user.setPasswordHash(passwordHash);
            
            // Save user to database
            boolean success = userDAO.create(user);
            
            if (success) {
                // Store user in session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId().toString());
                session.setAttribute("userRole", user.getUserType());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userName", user.getFullName());
                
                // Default session timeout - 30 minutes
                session.setMaxInactiveInterval(30 * 60);
                
                // Determine redirect URL based on user type
                String redirectUrl = "";
                if (user.isFreelancer()) {
                    redirectUrl = "freelancer-dashboard.html";
                } else if (user.isClient()) {
                    redirectUrl = "client-dashboard.html";
                } else {
                    redirectUrl = "index.html";
                }
                
                System.out.println("Registration successful. Redirecting to: " + redirectUrl);
                
                jsonResponse.put("success", "Registration successful! You are now logged in.");
                jsonResponse.put("redirect", redirectUrl);
                jsonResponse.put("userRole", user.getUserType());
            } else {
                jsonResponse.put("error", "Registration failed. Please try again.");
            }
            
        } catch (Exception e) {
            System.err.println("Registration error: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.put("error", "An error occurred during registration. Please try again.");
        }
        
        out.print(jsonResponse.toString());
    }
    
    /**
     * Handle GET requests - redirect to registration page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Simply forward to the registration page
        response.sendRedirect("register.html");
    }
}