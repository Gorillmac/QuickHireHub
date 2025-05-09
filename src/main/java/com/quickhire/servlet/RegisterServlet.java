package com.quickhire.servlet;

import java.io.IOException;
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
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Retrieve form parameters
        String userType = request.getParameter("userType");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty() ||
            userType == null || userType.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if email is already in use
        if (userDAO.findByEmail(email).isPresent()) {
            request.setAttribute("error", "Email is already registered");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("userType", userType);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Create user
        User user = new User();
        user.setId(UUID.randomUUID());
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        
        // Generate salt and hash password
        String salt = PasswordUtil.generateSalt();
        String hashedPassword = PasswordUtil.hashPasswordWithSalt(password, salt);
        
        user.setPasswordHash(hashedPassword);
        user.setSalt(salt);
        user.setUserType(userType);
        
        // Save user to database
        boolean success = userDAO.create(user);
        
        if (success) {
            // Auto-login user
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId().toString());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userType", user.getUserType());
            
            // Redirect to appropriate dashboard
            if ("freelancer".equalsIgnoreCase(userType)) {
                response.sendRedirect("freelancer-dashboard.jsp");
            } else if ("client".equalsIgnoreCase(userType)) {
                response.sendRedirect("client-dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
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
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // User is not logged in, show registration form
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}