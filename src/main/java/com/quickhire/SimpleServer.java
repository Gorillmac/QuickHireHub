package com.quickhire;

import com.quickhire.util.DatabaseInitializer;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.DefaultServlet;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.webapp.WebAppContext;

/**
 * A simple standalone server for QuickHire
 */
public class SimpleServer {
    public static void main(String[] args) throws Exception {
        System.out.println("Initializing QuickHire application...");
        
        // Initialize the database
        try {
            DatabaseInitializer.initializeDatabase();
        } catch (Exception e) {
            System.err.println("Warning: Database initialization error: " + e.getMessage());
            // Continue without database for now
        }
        
        // Create a Jetty server instance
        Server server = new Server(5000);
        
        // Create and configure a WebAppContext
        WebAppContext webApp = new WebAppContext();
        webApp.setContextPath("/");
        webApp.setWar("src/main/webapp");
        webApp.setParentLoaderPriority(true);
        
        // Set default servlet
        ServletHolder defaultServlet = new ServletHolder("default", new DefaultServlet());
        defaultServlet.setInitParameter("dirAllowed", "true");
        webApp.addServlet(defaultServlet, "/");
        
        // Set welcome files
        webApp.setWelcomeFiles(new String[]{"index.jsp", "index.html"});
        
        // Use the WebAppContext as the handler
        server.setHandler(webApp);
        
        try {
            System.out.println("Starting QuickHire server on port 5000...");
            server.start();
            System.out.println("Server started successfully!");
            
            // Create a simple home page to indicate that the server is running
            if (!new java.io.File("src/main/webapp/index.html").exists()) {
                try {
                    System.out.println("Creating a simple home page...");
                    java.io.FileWriter writer = new java.io.FileWriter("src/main/webapp/index.html");
                    writer.write("<!DOCTYPE html>\n" +
                                "<html>\n" +
                                "<head>\n" +
                                "    <title>QuickHire - Server is Running</title>\n" +
                                "    <style>\n" +
                                "        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }\n" +
                                "        h1 { color: #4361ee; }\n" +
                                "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }\n" +
                                "        .success { color: green; font-weight: bold; }\n" +
                                "    </style>\n" +
                                "</head>\n" +
                                "<body>\n" +
                                "    <div class='container'>\n" +
                                "        <h1>QuickHire Freelance Platform</h1>\n" +
                                "        <p class='success'>The server is running successfully!</p>\n" +
                                "        <p>If you're seeing this page, it means the basic server functionality is working.</p>\n" +
                                "        <p>Current time: " + new java.util.Date() + "</p>\n" +
                                "    </div>\n" +
                                "</body>\n" +
                                "</html>");
                    writer.close();
                    System.out.println("Simple home page created.");
                } catch (Exception e) {
                    System.err.println("Error creating home page: " + e.getMessage());
                }
            }
            
            server.join();
        } catch (Exception e) {
            System.err.println("Error starting server: " + e.getMessage());
            e.printStackTrace();
            server.stop();
            System.exit(1);
        }
    }
}