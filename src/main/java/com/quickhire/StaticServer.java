package com.quickhire;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.util.resource.Resource;

/**
 * A standalone static file server for QuickHire
 * This class can be run directly without compiling the entire project
 */
public class StaticServer {
    public static void main(String[] args) throws Exception {
        System.out.println("Initializing QuickHire static file server...");
        
        // Create a basic server
        Server server = new Server();
        
        // Create a connector
        ServerConnector connector = new ServerConnector(server);
        connector.setPort(5000);
        connector.setHost("0.0.0.0");
        server.addConnector(connector);
        
        // Create a resource handler for static content
        ResourceHandler resourceHandler = new ResourceHandler();
        resourceHandler.setDirectoriesListed(true);
        resourceHandler.setWelcomeFiles(new String[]{"index.html"});
        resourceHandler.setBaseResource(Resource.newResource("src/main/webapp"));
        
        // Add handlers
        HandlerList handlers = new HandlerList();
        handlers.addHandler(resourceHandler);
        handlers.addHandler(new DefaultHandler());
        server.setHandler(handlers);
        
        try {
            System.out.println("Starting QuickHire server on port 5000...");
            server.start();
            System.out.println("Server started successfully!");
            System.out.println("Static HTML files are available, but dynamic features are disabled.");
            System.out.println("You can browse to http://localhost:5000/ to view the static prototype.");
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