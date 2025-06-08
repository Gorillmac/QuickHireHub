package com.quickhire.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Factory class for creating database connections
 */
public class ConnectionFactory {
    private static ConnectionFactory instance;
    
    private String url;
    private String user;
    private String password;
    private String host;
    private String database;
    private String port;
    
    private ConnectionFactory() {
        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");
            
            // Get database connection details from environment variables
            this.url = System.getenv("DATABASE_URL");
            this.password = System.getenv("PGPASSWORD");
            this.database = System.getenv("PGDATABASE");
            this.host = System.getenv("PGHOST");
            this.user = System.getenv("PGUSER");
            this.port = System.getenv("PGPORT");
            
            // If DATABASE_URL is not set, build it from individual components
            if (this.url == null || this.url.isEmpty()) {
                this.url = "jdbc:postgresql://" + this.host + ":" + this.port + "/" + this.database;
            }
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL JDBC Driver not found", e);
        }
    }
    
    public static synchronized ConnectionFactory getInstance() {
        if (instance == null) {
            instance = new ConnectionFactory();
        }
        return instance;
    }
    
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}
