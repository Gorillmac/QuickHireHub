package com.quickhire.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for initializing the database with schema
 */
public class DatabaseInitializer {
    
    private static final Logger LOGGER = Logger.getLogger(DatabaseInitializer.class.getName());
    
    /**
     * Initialize the database by executing the schema.sql script
     */
    public static void initializeDatabase() {
        LOGGER.info("Initializing database...");
        Connection conn = null;
        Statement stmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            stmt = conn.createStatement();
            
            // Read schema.sql file
            String schemaScript = readSchemaFile();
            
            // Execute schema script
            if (schemaScript != null && !schemaScript.isEmpty()) {
                // Split by semicolons to execute each statement separately
                String[] statements = schemaScript.split(";");
                for (String statement : statements) {
                    if (statement.trim().isEmpty()) {
                        continue;
                    }
                    try {
                        stmt.execute(statement);
                    } catch (SQLException e) {
                        LOGGER.log(Level.WARNING, "Error executing SQL statement: " + e.getMessage(), e);
                        // Continue with next statement
                    }
                }
                LOGGER.info("Database initialized successfully.");
            } else {
                LOGGER.warning("Schema script is empty or could not be read.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database initialization failed: " + e.getMessage(), e);
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Read the schema.sql file from resources
     * @return The content of the schema file
     */
    private static String readSchemaFile() {
        StringBuilder schema = new StringBuilder();
        
        try (InputStream is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("schema.sql")) {
            if (is == null) {
                LOGGER.severe("Could not find schema.sql file in resources.");
                return null;
            }
            
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    // We'll keep the comments for better debugging if errors occur
                    schema.append(line).append("\n");
                }
            }
            
            return schema.toString();
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading schema file: " + e.getMessage(), e);
            return null;
        }
    }
}