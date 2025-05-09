package com.quickhire.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle user logout
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("Logout request received");
        
        // Get the session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Log the logout
            String userId = (String) session.getAttribute("userId");
            String email = (String) session.getAttribute("userEmail");
            
            if (userId != null && email != null) {
                System.out.println("Logging out user: " + email + " (ID: " + userId + ")");
            }
            
            // Invalidate the session
            session.invalidate();
            System.out.println("Session invalidated");
        }
        
        // Redirect to the homepage
        response.sendRedirect("index.html");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle POST the same as GET
        doGet(request, response);
    }
}