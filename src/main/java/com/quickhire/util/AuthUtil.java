package com.quickhire.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.quickhire.model.User;

/**
 * Utility class for authentication and session management
 */
public class AuthUtil {
    
    private static final SecureRandom RANDOM = new SecureRandom();
    
    /**
     * Hash a password with SHA-256 algorithm
     * @param password The password to hash
     * @param salt The salt for the password
     * @return Hashed password
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt.getBytes());
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Generate a random salt for password hashing
     * @return A random salt string
     */
    public static String generateSalt() {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * Store user in session
     * @param request The HTTP request
     * @param user The user to store
     */
    public static void storeUserInSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("loggedIn", true);
    }
    
    /**
     * Get current logged-in user from session
     * @param request The HTTP request
     * @return The logged-in user or null if not logged in
     */
    public static User getUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
    
    /**
     * Check if user is logged in
     * @param request The HTTP request
     * @return true if logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("loggedIn") != null && 
                (Boolean) session.getAttribute("loggedIn");
    }
    
    /**
     * Check if user has required role
     * @param request The HTTP request
     * @param requiredRole The role required for access
     * @return true if user has required role, false otherwise
     */
    public static boolean hasRole(HttpServletRequest request, String requiredRole) {
        if (!isLoggedIn(request)) {
            return false;
        }
        
        HttpSession session = request.getSession(false);
        String userRole = (String) session.getAttribute("userRole");
        
        return userRole != null && userRole.equals(requiredRole);
    }
    
    /**
     * Logout the current user
     * @param request The HTTP request
     */
    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
