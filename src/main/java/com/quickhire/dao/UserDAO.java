package com.quickhire.dao;

import com.quickhire.model.User;
import com.quickhire.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for User entities
 */
public class UserDAO {
    
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());
    
    /**
     * Create a new user in the database
     * 
     * @param user The user to create
     * @return true if the creation was successful, false otherwise
     */
    public boolean create(User user) {
        String sql = "INSERT INTO users (id, username, email, password_hash, salt, role, full_name, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, user.getId());
            pstmt.setString(2, user.getEmail().split("@")[0]); // Generate username from email
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPasswordHash());
            pstmt.setString(5, user.getSalt() != null ? user.getSalt() : "salt123"); // In a real app, use a proper salt generation
            pstmt.setString(6, user.getUserType().toUpperCase());
            pstmt.setString(7, user.getFullName());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating user", e);
            return false;
        }
    }
    
    /**
     * Find a user by their email address
     * 
     * @param email The email to search for
     * @return An Optional containing the user if found, empty otherwise
     */
    public Optional<User> findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                return Optional.of(user);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding user by email", e);
        }
        
        return Optional.empty();
    }
    
    /**
     * Find a user by their ID
     * 
     * @param id The user ID to search for
     * @return An Optional containing the user if found, empty otherwise
     */
    public Optional<User> findById(UUID id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                return Optional.of(user);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding user by ID", e);
        }
        
        return Optional.empty();
    }
    
    /**
     * Get all users of a specific type
     * 
     * @param userType The type of users to find ('freelancer' or 'client')
     * @return A list of users of the specified type
     */
    public List<User> findByUserType(String userType) {
        String sql = "SELECT * FROM users WHERE role = ?";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, userType.toUpperCase());
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding users by type", e);
        }
        
        return users;
    }
    
    /**
     * Get all users in the system
     * 
     * @return A list of all users
     */
    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding all users", e);
        }
        
        return users;
    }
    
    /**
     * Update an existing user in the database
     * 
     * @param user The user with updated information
     * @return true if the update was successful, false otherwise
     */
    public boolean update(User user) {
        String sql = "UPDATE users SET email = ?, password_hash = ?, full_name = ?, " +
                    "profile_description = ?, location = ?, phone_number = ?, " +
                    "company_name = ?, company_website = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getPasswordHash());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getBio() != null ? user.getBio() : "");
            pstmt.setString(5, user.getLocation() != null ? user.getLocation() : "");
            pstmt.setString(6, user.getPhone() != null ? user.getPhone() : "");
            pstmt.setString(7, user.getCompanyName() != null ? user.getCompanyName() : "");
            pstmt.setString(8, user.getWebsite() != null ? user.getWebsite() : "");
            pstmt.setObject(9, user.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user", e);
            return false;
        }
    }
    
    /**
     * Update a user's password
     * 
     * @param id The ID of the user
     * @param newPasswordHash The new hashed password
     * @return true if the update was successful, false otherwise
     */
    public boolean updatePassword(UUID id, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPasswordHash);
            pstmt.setObject(2, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user password", e);
            return false;
        }
    }
    
    /**
     * Delete a user from the database
     * 
     * @param id The ID of the user to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean delete(UUID id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting user", e);
            return false;
        }
    }
    
    /**
     * Activate or deactivate a user
     * 
     * @param id The ID of the user
     * @param active The new active status
     * @return true if the update was successful, false otherwise
     */
    public boolean setActive(UUID id, boolean active) {
        String sql = "UPDATE users SET active = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, active);
            pstmt.setObject(2, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user active status", e);
            return false;
        }
    }
    
    /**
     * Verify user credentials for login
     * 
     * @param email The user's email
     * @param passwordHash The hash of the password entered
     * @return An Optional containing the user if credentials match, empty otherwise
     */
    public Optional<User> verifyCredentials(String email, String passwordHash) {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, passwordHash);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                return Optional.of(user);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error verifying credentials", e);
        }
        
        return Optional.empty();
    }
    
    /**
     * Map a ResultSet to a User object
     * 
     * @param rs The ResultSet containing user data
     * @return A User object with data from the ResultSet
     * @throws SQLException If there is an error accessing the ResultSet
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(UUID.fromString(rs.getString("id")));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setSalt(rs.getString("salt"));
        
        // Extract first and last name from full_name
        String fullName = rs.getString("full_name");
        if (fullName != null && !fullName.isEmpty()) {
            String[] nameParts = fullName.split(" ", 2);
            user.setFirstName(nameParts[0]);
            user.setLastName(nameParts.length > 1 ? nameParts[1] : "");
        }
        
        user.setUserType(rs.getString("role").toLowerCase());
        
        // Additional profile details
        user.setBio(rs.getString("profile_description"));
        user.setLocation(rs.getString("location"));
        user.setPhone(rs.getString("phone_number"));
        user.setCompanyName(rs.getString("company_name"));
        user.setWebsite(rs.getString("company_website"));
        user.setSkills(rs.getString("skills"));
        
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        user.setActive(rs.getBoolean("active"));
        
        return user;
    }
}