package com.quickhire.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for database connections
 */
public class DatabaseUtil {

    private static final String DRIVER = "org.postgresql.Driver";
    
    // Database connection parameters from environment variables
    private static final String URL = System.getenv("DATABASE_URL");
    private static final String HOST = System.getenv("PGHOST");
    private static final String DATABASE = System.getenv("PGDATABASE");
    private static final String USER = System.getenv("PGUSER");
    private static final String PASSWORD = System.getenv("PGPASSWORD");
    private static final String PORT = System.getenv("PGPORT");
    
    /**
     * Get a connection to the database
     * @return Connection object
     * @throws SQLException If a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
            
            // If DATABASE_URL is provided, use it
            if (URL != null && !URL.isEmpty()) {
                return DriverManager.getConnection(URL);
            }
            
            // Otherwise, build connection string from individual parameters
            String connectionUrl = String.format("jdbc:postgresql://%s:%s/%s", 
                    HOST, PORT, DATABASE);
            
            return DriverManager.getConnection(connectionUrl, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } catch (SQLException e) {
            throw new SQLException("Database connection error: " + e.getMessage(), e);
        }
    }
    
    /**
     * Close a database connection safely
     * @param connection The connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                // Log error but don't throw exception
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}
