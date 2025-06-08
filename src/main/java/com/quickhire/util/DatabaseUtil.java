package com.quickhire.util;

import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utility class for database connections
 */
public class DatabaseUtil {

    private static final String DRIVER = "org.postgresql.Driver";
    
    // Database connection parameters from environment variables
    private static final String DATABASE_URL = System.getenv("DATABASE_URL");
    private static final String PGHOST = System.getenv("PGHOST");
    private static final String PGDATABASE = System.getenv("PGDATABASE");
    private static final String PGUSER = System.getenv("PGUSER");
    private static final String PGPASSWORD = System.getenv("PGPASSWORD");
    private static final String PGPORT = System.getenv("PGPORT");
    
    /**
     * Get a connection to the database
     * @return Connection object
     * @throws SQLException If a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
            
            // Method 1: Try using the Replit PostgreSQL environment variables
            if (PGHOST != null && PGDATABASE != null && PGUSER != null && PGPASSWORD != null) {
                String pgPort = PGPORT != null ? PGPORT : "5432";
                String url = String.format("jdbc:postgresql://%s:%s/%s", PGHOST, pgPort, PGDATABASE);
                
                System.out.println("Connecting using PGHOST environment variables: " + url);
                return DriverManager.getConnection(url, PGUSER, PGPASSWORD);
            }
            
            // Method 2: Try to parse DATABASE_URL if it exists
            if (DATABASE_URL != null && !DATABASE_URL.isEmpty()) {
                try {
                    // Parse the DATABASE_URL to extract components
                    URI dbUri = new URI(DATABASE_URL);
                    
                    String username = null;
                    String password = null;
                    String userInfo = dbUri.getUserInfo();
                    
                    if (userInfo != null) {
                        String[] userInfoParts = userInfo.split(":");
                        username = userInfoParts[0];
                        if (userInfoParts.length > 1) {
                            password = userInfoParts[1];
                        }
                    }
                    
                    String dbUrl = "jdbc:postgresql://" + dbUri.getHost();
                    
                    if (dbUri.getPort() != -1) {
                        dbUrl += ":" + dbUri.getPort();
                    }
                    
                    dbUrl += dbUri.getPath();
                    
                    // Add parameters
                    String query = dbUri.getQuery();
                    if (query != null && !query.isEmpty()) {
                        dbUrl += "?" + query;
                    }
                    
                    System.out.println("Connecting with parsed DATABASE_URL: " + dbUrl);
                    
                    // Create connection
                    Properties props = new Properties();
                    if (username != null) props.setProperty("user", username);
                    if (password != null) props.setProperty("password", password);
                    
                    return DriverManager.getConnection(dbUrl, props);
                } catch (URISyntaxException e) {
                    throw new SQLException("Invalid DATABASE_URL format: " + e.getMessage(), e);
                }
            }
            
            // If we get here, we couldn't establish a connection
            throw new SQLException("No database connection information available");
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC driver not found", e);
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
