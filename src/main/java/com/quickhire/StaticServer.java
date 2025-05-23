package com.quickhire;

import java.util.EnumSet;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.util.resource.Resource;

import com.quickhire.servlet.LoginServlet;
import com.quickhire.servlet.LogoutServlet;
import com.quickhire.servlet.RegisterServlet;
import com.quickhire.util.DatabaseInitializer;
import jakarta.servlet.DispatcherType;

/**
 * A standalone server for QuickHire that serves both static files and servlet endpoints
 */
public class StaticServer {
    public static void main(String[] args) throws Exception {
        System.out.println("Initializing QuickHire static file server...");
        
        // Initialize the database schema
        System.out.println("Initializing database schema...");
        try {
            DatabaseInitializer.initializeDatabase();
            System.out.println("Database schema initialized successfully.");
        } catch (Exception e) {
            System.err.println("Error initializing database schema: " + e.getMessage());
            e.printStackTrace();
            // Continue execution - we don't want to fail startup if database
            // schema is already present or partially initialized
        }
        
        // Create a basic server
        Server server = new Server();
        
        // Create a connector
        ServerConnector connector = new ServerConnector(server);
        connector.setPort(5000);
        connector.setHost("0.0.0.0");
        server.addConnector(connector);
        
        // Create a context handler for servlets
        ServletContextHandler servletHandler = new ServletContextHandler(ServletContextHandler.SESSIONS);
        servletHandler.setContextPath("/");
        
        // Register servlets
        servletHandler.addServlet(new ServletHolder(new LoginServlet()), "/login");
        servletHandler.addServlet(new ServletHolder(new RegisterServlet()), "/register");
        servletHandler.addServlet(new ServletHolder(new LogoutServlet()), "/logout");
        
        // Create a resource handler for static content
        ResourceHandler resourceHandler = new ResourceHandler();
        resourceHandler.setDirectoriesListed(false);
        resourceHandler.setWelcomeFiles(new String[]{"index.html"});
        resourceHandler.setBaseResource(Resource.newResource("src/main/webapp"));
        
        // Add handlers in order of precedence
        HandlerList handlers = new HandlerList();
        handlers.addHandler(servletHandler);  // Servlets take precedence
        handlers.addHandler(resourceHandler); // Static resources next
        handlers.addHandler(new DefaultHandler()); // Default handler last
        server.setHandler(handlers);
        
        try {
            System.out.println("Starting QuickHire server on port 5000...");
            server.start();
            System.out.println("Server started successfully!");
            System.out.println("Both static files and dynamic features are now available.");
            System.out.println("You can browse to http://localhost:5000/ to access the application.");
            System.out.println("Available pages:");
            System.out.println("- Homepage: http://localhost:5000/index.html");
            System.out.println("- Login: http://localhost:5000/login.html");
            System.out.println("- Register: http://localhost:5000/register.html");
            System.out.println("- Client Dashboard: http://localhost:5000/client-dashboard.html");
            System.out.println("- Freelancer Dashboard: http://localhost:5000/freelancer-dashboard.html");
            
            server.join();
        } catch (Exception e) {
            System.err.println("Error starting server: " + e.getMessage());
            e.printStackTrace();
            server.stop();
            System.exit(1);
        }
    }
}