package com.quickhire;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.util.resource.Resource;

/**
 * A simple standalone server that serves static content
 * Used to verify that basic server functionality works
 */
public class SimpleServer {
    public static void main(String[] args) throws Exception {
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
        resourceHandler.setWelcomeFiles(new String[]{"index.html", "index.jsp"});
        resourceHandler.setBaseResource(Resource.newResource("src/main/webapp"));
        
        // Add handlers
        HandlerList handlers = new HandlerList();
        handlers.addHandler(resourceHandler);
        handlers.addHandler(new DefaultHandler());
        server.setHandler(handlers);
        
        try {
            System.out.println("Starting simple server on port 5000...");
            server.start();
            System.out.println("Server started successfully!");
            server.join();
        } catch (Exception e) {
            System.err.println("Error starting server: " + e.getMessage());
            e.printStackTrace();
            server.stop();
            System.exit(1);
        }
    }
}