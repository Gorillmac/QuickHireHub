package com.quickhire.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quickhire.dao.UserDAO;
import com.quickhire.model.User;
import com.quickhire.util.AuthUtil;

/**
 * Servlet for handling authentication operations (login, register, logout)
 */
@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/login":
                // Check if already logged in
                if (AuthUtil.isLoggedIn(request)) {
                    redirectToDashboard(request, response);
                    return;
                }
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;
                
            case "/register":
                // Check if already logged in
                if (AuthUtil.isLoggedIn(request)) {
                    redirectToDashboard(request, response);
                    return;
                }
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;
                
            case "/logout":
                AuthUtil.logout(request);
                response.sendRedirect(request.getContextPath() + "/login");
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/login":
                processLogin(request, response);
                break;
                
            case "/register":
                processRegistration(request, response);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/");
                break;
        }
    }
    
    /**
     * Process login form submission
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Find user by username
            User user = userDAO.findByUsername(username);
            
            if (user == null) {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Check if user is active
            if (!user.isActive()) {
                request.setAttribute("errorMessage", "Your account has been suspended. Please contact support.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Verify password
            String hashedPassword = AuthUtil.hashPassword(password, user.getSalt());
            
            if (!hashedPassword.equals(user.getPasswordHash())) {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Store user in session
            AuthUtil.storeUserInSession(request, user);
            
            // Redirect to dashboard
            redirectToDashboard(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Process registration form submission
     */
    private void processRegistration(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            confirmPassword == null || confirmPassword.trim().isEmpty() || 
            role == null || role.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Validate username (alphanumeric, 3-20 chars)
        if (!username.matches("^[a-zA-Z0-9]{3,20}$")) {
            request.setAttribute("errorMessage", "Username must be 3-20 alphanumeric characters");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Validate email
        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("errorMessage", "Please enter a valid email address");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check password strength (at least 8 chars)
        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters long");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Validate role
        if (!role.equals(User.ROLE_FREELANCER) && !role.equals(User.ROLE_COMPANY)) {
            request.setAttribute("errorMessage", "Invalid user role");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if username already exists
            if (userDAO.findByUsername(username) != null) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            if (userDAO.findByEmail(email) != null) {
                request.setAttribute("errorMessage", "Email already exists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Generate salt and hash password
            String salt = AuthUtil.generateSalt();
            String hashedPassword = AuthUtil.hashPassword(password, salt);
            
            // Create user object
            User user = new User(username, email, hashedPassword, salt, role);
            
            // Additional fields based on role
            if (role.equals(User.ROLE_COMPANY)) {
                String companyName = request.getParameter("companyName");
                if (companyName != null && !companyName.trim().isEmpty()) {
                    user.setCompanyName(companyName);
                    user.setFullName(companyName); // Use company name as full name initially
                }
            } else if (role.equals(User.ROLE_FREELANCER)) {
                String fullName = request.getParameter("fullName");
                if (fullName != null && !fullName.trim().isEmpty()) {
                    user.setFullName(fullName);
                }
            }
            
            // Save user to database
            user = userDAO.create(user);
            
            // Store user in session
            AuthUtil.storeUserInSession(request, user);
            
            // Redirect to dashboard
            redirectToDashboard(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Redirect to appropriate dashboard based on user role
     */
    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String role = (String) session.getAttribute("userRole");
            
            if (role != null) {
                switch (role) {
                    case User.ROLE_FREELANCER:
                        response.sendRedirect(request.getContextPath() + "/dashboard-freelancer");
                        break;
                        
                    case User.ROLE_COMPANY:
                        response.sendRedirect(request.getContextPath() + "/dashboard-company");
                        break;
                        
                    case User.ROLE_ADMIN:
                        response.sendRedirect(request.getContextPath() + "/dashboard-admin");
                        break;
                        
                    default:
                        response.sendRedirect(request.getContextPath() + "/");
                        break;
                }
                return;
            }
        }
        
        // Default fallback
        response.sendRedirect(request.getContextPath() + "/");
    }
}
