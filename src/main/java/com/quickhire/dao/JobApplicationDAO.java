package com.quickhire.dao;

import com.quickhire.model.JobApplication;
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
 * Data Access Object for JobApplication entities
 */
public class JobApplicationDAO {
    
    private static final Logger logger = Logger.getLogger(JobApplicationDAO.class.getName());
    
    /**
     * Create a new job application in the database
     * 
     * @param application The job application to create
     * @return true if the creation was successful, false otherwise
     */
    public boolean create(JobApplication application) {
        String sql = "INSERT INTO applications (id, job_id, freelancer_id, cover_letter, " +
                    "proposed_rate, estimated_duration, status, applied_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, 30, ?, NOW(), NOW())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, application.getId());
            pstmt.setObject(2, application.getJobId());
            pstmt.setObject(3, application.getFreelancerId());
            pstmt.setString(4, application.getCoverLetter());
            pstmt.setBigDecimal(5, application.getProposedAmount());
            pstmt.setString(6, application.getStatus());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating job application", e);
            return false;
        }
    }
    
    /**
     * Find a job application by its ID
     * 
     * @param id The job application ID to search for
     * @return An Optional containing the job application if found, empty otherwise
     */
    public Optional<JobApplication> findById(UUID id) {
        String sql = "SELECT * FROM applications WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                JobApplication application = mapResultSetToJobApplication(rs);
                return Optional.of(application);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding job application by ID", e);
        }
        
        return Optional.empty();
    }
    
    /**
     * Get all job applications for a specific job
     * 
     * @param jobId The ID of the job
     * @return A list of job applications for the job
     */
    public List<JobApplication> findByJobId(UUID jobId) {
        String sql = "SELECT * FROM applications WHERE job_id = ? ORDER BY applied_at DESC";
        List<JobApplication> applications = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, jobId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                JobApplication application = mapResultSetToJobApplication(rs);
                applications.add(application);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding job applications by job ID", e);
        }
        
        return applications;
    }
    
    /**
     * Get all job applications submitted by a specific freelancer
     * 
     * @param freelancerId The ID of the freelancer
     * @return A list of job applications submitted by the freelancer
     */
    public List<JobApplication> findByFreelancerId(UUID freelancerId) {
        String sql = "SELECT * FROM applications WHERE freelancer_id = ? ORDER BY applied_at DESC";
        List<JobApplication> applications = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, freelancerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                JobApplication application = mapResultSetToJobApplication(rs);
                applications.add(application);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding job applications by freelancer ID", e);
        }
        
        return applications;
    }
    
    /**
     * Update the status of a job application
     * 
     * @param id The ID of the job application
     * @param status The new status ('pending', 'accepted', 'rejected', 'withdrawn')
     * @return true if the update was successful, false otherwise
     */
    public boolean updateStatus(UUID id, String status) {
        String sql = "UPDATE applications SET status = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setObject(2, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating job application status", e);
            return false;
        }
    }
    
    /**
     * Delete a job application from the database
     * 
     * @param id The ID of the job application to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean delete(UUID id) {
        String sql = "DELETE FROM applications WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting job application", e);
            return false;
        }
    }
    
    /**
     * Map a ResultSet to a JobApplication object
     * 
     * @param rs The ResultSet containing job application data
     * @return A JobApplication object with data from the ResultSet
     * @throws SQLException If there is an error accessing the ResultSet
     */
    private JobApplication mapResultSetToJobApplication(ResultSet rs) throws SQLException {
        JobApplication application = new JobApplication();
        application.setId(UUID.fromString(rs.getString("id")));
        application.setJobId(UUID.fromString(rs.getString("job_id")));
        application.setFreelancerId(UUID.fromString(rs.getString("freelancer_id")));
        application.setCoverLetter(rs.getString("cover_letter"));
        application.setProposedAmount(rs.getBigDecimal("proposed_rate"));
        application.setStatus(rs.getString("status"));
        application.setCreatedAt(rs.getTimestamp("applied_at"));
        application.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return application;
    }
}