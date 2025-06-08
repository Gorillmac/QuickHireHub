package com.quickhire;

import java.io.File;

import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.HttpConfiguration;
import org.eclipse.jetty.server.HttpConnectionFactory;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.webapp.WebAppContext;

import com.quickhire.util.DatabaseInitializer;

/**
 * Embedded Jetty server for QuickHire application
 */
public class JettyServer {
    
    public static void main(String[] args) throws Exception {
        // Initialize the database
        DatabaseInitializer.initializeDatabase();
        
        // Create a basic server
        Server server = new Server();
        
        // HTTP Configuration
        HttpConfiguration httpConfig = new HttpConfiguration();
        httpConfig.setSendServerVersion(false);
        
        // The ServerConnector
        ServerConnector connector = new ServerConnector(server, new HttpConnectionFactory(httpConfig));
        connector.setPort(5000);
        connector.setHost("0.0.0.0");
        server.setConnectors(new Connector[] { connector });
        
        // Create a basic servlet context to serve files 
        WebAppContext context = new WebAppContext();
        context.setContextPath("/");
        context.setResourceBase(new File("src/main/webapp").getAbsolutePath());
        context.setParentLoaderPriority(true);
        
        // Enable directory listing for static content
        context.setInitParameter("org.eclipse.jetty.servlet.Default.dirAllowed", "true");
        
        // Make index.html and index.jsp welcome files
        context.setWelcomeFiles(new String[] { "index.jsp", "index.html" });
        
        // Set server handler
        server.setHandler(context);
        
        // Start the server
        try {
            System.out.println("Starting QuickHire server on port 5000...");
            server.start();
            System.out.println("QuickHire server started successfully!");
            server.join();
        } catch (Exception e) {
            System.err.println("Error starting server: " + e.getMessage());
            e.printStackTrace();
            server.stop();
            System.exit(1);
        }
    }
}