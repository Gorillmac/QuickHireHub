package com.quickhire.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.quickhire.model.Application;
import com.quickhire.util.DatabaseUtil;

/**
 * Data Access Object for Application entities
 */
public class ApplicationDAO {
    
    /**
     * Create a new application in the database
     * @param application The application to create
     * @return The created application with ID populated
     * @throws SQLException If a database error occurs
     */
    public Application create(Application application) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "INSERT INTO applications (id, job_id, freelancer_id, cover_letter, " +
                    "proposed_rate, estimated_duration, status, applied_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, application.getId());
            ps.setObject(2, application.getJobId());
            ps.setObject(3, application.getFreelancerId());
            ps.setString(4, application.getCoverLetter());
            ps.setBigDecimal(5, application.getProposedRate());
            ps.setInt(6, application.getEstimatedDuration());
            ps.setString(7, application.getStatus());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating application failed, no rows affected.");
            }
            
            // UUID is already set in the Application constructor, no need to fetch generated keys
            
            return application;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get an application by ID
     * @param id The application ID
     * @return The application or null if not found
     * @throws SQLException If a database error occurs
     */
    public Application findById(UUID id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM applications WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, id);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractApplicationFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all applications
     * @return List of all applications
     * @throws SQLException If a database error occurs
     */
    public List<Application> findAll() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM applications ORDER BY applied_at DESC";
            
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            List<Application> applications = new ArrayList<>();
            while (rs.next()) {
                applications.add(extractApplicationFromResultSet(rs));
            }
            
            return applications;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get applications by job ID
     * @param jobId The job ID
     * @return List of applications for the job
     * @throws SQLException If a database error occurs
     */
    public List<Application> findByJobId(UUID jobId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM applications WHERE job_id = ? ORDER BY applied_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, jobId);
            
            rs = ps.executeQuery();
            
            List<Application> applications = new ArrayList<>();
            while (rs.next()) {
                applications.add(extractApplicationFromResultSet(rs));
            }
            
            return applications;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get applications by freelancer ID
     * @param freelancerId The freelancer ID
     * @return List of applications from the freelancer
     * @throws SQLException If a database error occurs
     */
    public List<Application> findByFreelancerId(UUID freelancerId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM applications WHERE freelancer_id = ? ORDER BY applied_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, freelancerId);
            
            rs = ps.executeQuery();
            
            List<Application> applications = new ArrayList<>();
            while (rs.next()) {
                applications.add(extractApplicationFromResultSet(rs));
            }
            
            return applications;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Check if a freelancer has already applied to a job
     * @param jobId The job ID
     * @param freelancerId The freelancer ID
     * @return true if already applied, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean hasApplied(UUID jobId, UUID freelancerId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT COUNT(*) FROM applications WHERE job_id = ? AND freelancer_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, jobId);
            ps.setObject(2, freelancerId);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
            return false;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Update an application in the database
     * @param application The application to update
     * @return The updated application
     * @throws SQLException If a database error occurs
     */
    public Application update(Application application) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE applications SET cover_letter = ?, proposed_rate = ?, " +
                    "estimated_duration = ?, status = ?, updated_at = NOW() " +
                    "WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, application.getCoverLetter());
            ps.setBigDecimal(2, application.getProposedRate());
            ps.setInt(3, application.getEstimatedDuration());
            ps.setString(4, application.getStatus());
            ps.setInt(5, application.getId());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating application failed, no rows affected.");
            }
            
            return application;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Update application status
     * @param id The application ID
     * @param status The new status
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean updateStatus(int id, String status) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE applications SET status = ?, updated_at = NOW() WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            
            int affectedRows = ps.executeUpdate();
            
            return affectedRows > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Delete an application from the database
     * @param id The ID of the application to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean delete(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "DELETE FROM applications WHERE id = ?";
            
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
     * Extract an Application object from a ResultSet
     * @param rs The ResultSet containing application data
     * @return An Application object
     * @throws SQLException If a database error occurs
     */
    private Application extractApplicationFromResultSet(ResultSet rs) throws SQLException {
        Application application = new Application();
        application.setId(rs.getInt("id"));
        application.setJobId(rs.getInt("job_id"));
        application.setFreelancerId(rs.getInt("freelancer_id"));
        application.setCoverLetter(rs.getString("cover_letter"));
        application.setProposedRate(rs.getBigDecimal("proposed_rate"));
        application.setEstimatedDuration(rs.getInt("estimated_duration"));
        application.setStatus(rs.getString("status"));
        application.setAppliedAt(rs.getTimestamp("applied_at"));
        application.setUpdatedAt(rs.getTimestamp("updated_at"));
        return application;
    }
}
