package com.quickhire.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.quickhire.model.User;
import com.quickhire.util.DatabaseUtil;

/**
 * Data Access Object for User entities
 */
public class UserDAO {
    
    /**
     * Create a new user in the database
     * @param user The user to create
     * @return The created user with ID populated
     * @throws SQLException If a database error occurs
     */
    public User create(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "INSERT INTO users (username, email, password_hash, salt, role, " +
                    "full_name, profile_description, skills, company_name, company_website, " +
                    "location, phone_number, created_at, updated_at, active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW(), ?)";
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getSalt());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getFullName());
            ps.setString(7, user.getProfileDescription());
            ps.setString(8, user.getSkills());
            ps.setString(9, user.getCompanyName());
            ps.setString(10, user.getCompanyWebsite());
            ps.setString(11, user.getLocation());
            ps.setString(12, user.getPhoneNumber());
            ps.setBoolean(13, user.isActive());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }
            
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                user.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating user failed, no ID obtained.");
            }
            
            return user;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get a user by ID
     * @param id The user ID
     * @return The user or null if not found
     * @throws SQLException If a database error occurs
     */
    public User findById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM users WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Find a user by username
     * @param username The username to search for
     * @return The user or null if not found
     * @throws SQLException If a database error occurs
     */
    public User findByUsername(String username) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM users WHERE username = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Find a user by email
     * @param email The email to search for
     * @return The user or null if not found
     * @throws SQLException If a database error occurs
     */
    public User findByEmail(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM users WHERE email = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all users
     * @return List of all users
     * @throws SQLException If a database error occurs
     */
    public List<User> findAll() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM users ORDER BY id";
            
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            List<User> users = new ArrayList<>();
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
            
            return users;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all users by role
     * @param role The role to filter by
     * @return List of users with the specified role
     * @throws SQLException If a database error occurs
     */
    public List<User> findByRole(String role) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM users WHERE role = ? ORDER BY id";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            
            rs = ps.executeQuery();
            
            List<User> users = new ArrayList<>();
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
            
            return users;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Update a user in the database
     * @param user The user to update
     * @return The updated user
     * @throws SQLException If a database error occurs
     */
    public User update(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE users SET username = ?, email = ?, password_hash = ?, " +
                    "salt = ?, role = ?, full_name = ?, profile_description = ?, " +
                    "skills = ?, company_name = ?, company_website = ?, location = ?, " +
                    "phone_number = ?, updated_at = NOW(), active = ? WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getSalt());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getFullName());
            ps.setString(7, user.getProfileDescription());
            ps.setString(8, user.getSkills());
            ps.setString(9, user.getCompanyName());
            ps.setString(10, user.getCompanyWebsite());
            ps.setString(11, user.getLocation());
            ps.setString(12, user.getPhoneNumber());
            ps.setBoolean(13, user.isActive());
            ps.setInt(14, user.getId());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating user failed, no rows affected.");
            }
            
            return user;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Delete a user from the database
     * @param id The ID of the user to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean delete(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "DELETE FROM users WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int affectedRows = ps.executeUpdate();
            
            return affectedRows > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Set the active status of a user
     * @param id The user ID
     * @param active The active status
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean setActiveStatus(int id, boolean active) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE users SET active = ?, updated_at = NOW() WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            
            int affectedRows = ps.executeUpdate();
            
            return affectedRows > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Update a user's password
     * @param id The user ID
     * @param passwordHash The new password hash
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean updatePassword(int id, String passwordHash) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE users SET password_hash = ?, updated_at = NOW() WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, passwordHash);
            ps.setInt(2, id);
            
            int affectedRows = ps.executeUpdate();
            
            return affectedRows > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Search for freelancers by skills
     * @param skillQuery The skill to search for
     * @return List of freelancers matching the skill
     * @throws SQLException If a database error occurs
     */
    public List<User> searchFreelancersBySkills(String skillQuery) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM users WHERE role = ? AND skills LIKE ? AND active = true ORDER BY id";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, User.ROLE_FREELANCER);
            ps.setString(2, "%" + skillQuery + "%");
            
            rs = ps.executeQuery();
            
            List<User> freelancers = new ArrayList<>();
            while (rs.next()) {
                freelancers.add(extractUserFromResultSet(rs));
            }
            
            return freelancers;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Extract a User object from a ResultSet
     * @param rs The ResultSet containing user data
     * @return A User object
     * @throws SQLException If a database error occurs
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setSalt(rs.getString("salt"));
        user.setRole(rs.getString("role"));
        user.setFullName(rs.getString("full_name"));
        user.setProfileDescription(rs.getString("profile_description"));
        user.setSkills(rs.getString("skills"));
        user.setCompanyName(rs.getString("company_name"));
        user.setCompanyWebsite(rs.getString("company_website"));
        user.setLocation(rs.getString("location"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        user.setActive(rs.getBoolean("active"));
        return user;
    }
}
