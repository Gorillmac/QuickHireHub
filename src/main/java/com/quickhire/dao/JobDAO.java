package com.quickhire.dao;

import com.quickhire.model.Job;
import com.quickhire.util.DatabaseUtil;

import java.math.BigDecimal;
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
 * Data Access Object for Job entities
 */
public class JobDAO {
    
    private static final Logger logger = Logger.getLogger(JobDAO.class.getName());
    
    /**
     * Create a new job in the database
     * 
     * @param job The job to create
     * @return true if the creation was successful, false otherwise
     */
    public boolean create(Job job) {
        String sql = "INSERT INTO jobs (id, company_id, title, description, category, requirements, " +
                    "budget, payment_type, duration, status, posted_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, job.getId());
            pstmt.setObject(2, job.getClientId());
            pstmt.setString(3, job.getTitle());
            pstmt.setString(4, job.getDescription());
            pstmt.setString(5, job.getCategory());
            pstmt.setString(6, job.getSkills());
            pstmt.setBigDecimal(7, job.getBudget());
            pstmt.setString(8, job.getBudgetType());
            pstmt.setString(9, job.getDuration());
            pstmt.setString(10, job.getStatus());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating job", e);
            return false;
        }
    }
    
    /**
     * Find a job by its ID
     * 
     * @param id The job ID to search for
     * @return An Optional containing the job if found, empty otherwise
     */
    public Optional<Job> findById(UUID id) {
        String sql = "SELECT * FROM jobs WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Job job = mapResultSetToJob(rs);
                return Optional.of(job);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding job by ID", e);
        }
        
        return Optional.empty();
    }
    
    /**
     * Get all jobs with a specific status
     * 
     * @param status The status to filter by ('open', 'in_progress', etc.)
     * @return A list of jobs with the specified status
     */
    public List<Job> findByStatus(String status) {
        String sql = "SELECT * FROM jobs WHERE status = ? ORDER BY posted_at DESC";
        List<Job> jobs = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Job job = mapResultSetToJob(rs);
                jobs.add(job);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding jobs by status", e);
        }
        
        return jobs;
    }
    
    /**
     * Get all jobs posted by a specific client
     * 
     * @param clientId The ID of the client
     * @return A list of jobs posted by the client
     */
    public List<Job> findByClientId(UUID clientId) {
        String sql = "SELECT * FROM jobs WHERE company_id = ? ORDER BY posted_at DESC";
        List<Job> jobs = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, clientId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Job job = mapResultSetToJob(rs);
                jobs.add(job);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding jobs by client ID", e);
        }
        
        return jobs;
    }
    
    /**
     * Find all jobs in the system
     * 
     * @return A list of all jobs
     */
    public List<Job> findAll() {
        String sql = "SELECT * FROM jobs ORDER BY posted_at DESC";
        List<Job> jobs = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Job job = mapResultSetToJob(rs);
                jobs.add(job);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding all jobs", e);
        }
        
        return jobs;
    }
    
    /**
     * Find all jobs waiting for approval
     * 
     * @return A list of jobs that are pending approval
     */
    public List<Job> findUnapproved() {
        // Depending on your schema, this could be jobs with a status of "pending"
        // or you might have a separate "approved" field
        String sql = "SELECT * FROM jobs WHERE status = 'pending_approval' ORDER BY posted_at DESC";
        List<Job> jobs = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Job job = mapResultSetToJob(rs);
                jobs.add(job);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding unapproved jobs", e);
        }
        
        return jobs;
    }
    
    /**
     * Search for jobs by category, skills, or title
     * 
     * @param searchTerm The term to search for
     * @return A list of jobs matching the search criteria
     */
    public List<Job> search(String searchTerm) {
        String sql = "SELECT * FROM jobs WHERE " +
                     "category ILIKE ? OR " +
                     "requirements ILIKE ? OR " +
                     "title ILIKE ? " +
                     "ORDER BY posted_at DESC";
        List<Job> jobs = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String term = "%" + searchTerm + "%";
            pstmt.setString(1, term);
            pstmt.setString(2, term);
            pstmt.setString(3, term);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Job job = mapResultSetToJob(rs);
                jobs.add(job);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching jobs", e);
        }
        
        return jobs;
    }
    
    /**
     * Update an existing job in the database
     * 
     * @param job The job with updated information
     * @return true if the update was successful, false otherwise
     */
    public boolean update(Job job) {
        String sql = "UPDATE jobs SET title = ?, description = ?, category = ?, " +
                    "requirements = ?, budget = ?, payment_type = ?, duration = ?, " +
                    "status = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, job.getTitle());
            pstmt.setString(2, job.getDescription());
            pstmt.setString(3, job.getCategory());
            pstmt.setString(4, job.getSkills());
            pstmt.setBigDecimal(5, job.getBudget());
            pstmt.setString(6, job.getBudgetType());
            pstmt.setString(7, job.getDuration());
            pstmt.setString(8, job.getStatus());
            pstmt.setObject(9, job.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating job", e);
            return false;
        }
    }
    
    /**
     * Update the status of a job
     * 
     * @param id The ID of the job
     * @param status The new status
     * @return true if the update was successful, false otherwise
     */
    public boolean updateStatus(UUID id, String status) {
        String sql = "UPDATE jobs SET status = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setObject(2, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating job status", e);
            return false;
        }
    }
    
    /**
     * Approve a job (set approved status to true)
     * 
     * @param id The ID of the job to approve
     * @return true if the job was approved successfully, false otherwise
     */
    public boolean approveJob(UUID id) {
        String sql = "UPDATE jobs SET approved = true, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error approving job", e);
            return false;
        }
    }
    
    /**
     * Delete a job from the database
     * 
     * @param id The ID of the job to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean delete(UUID id) {
        String sql = "DELETE FROM jobs WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setObject(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting job", e);
            return false;
        }
    }
    
    /**
     * Close a job (change its status to 'closed')
     * 
     * @param id The ID of the job to close
     * @return true if the job was closed successfully, false otherwise
     */
    public boolean closeJob(UUID id) {
        return updateStatus(id, "closed");
    }
    
    /**
     * Map a ResultSet to a Job object
     * 
     * @param rs The ResultSet containing job data
     * @return A Job object with data from the ResultSet
     * @throws SQLException If there is an error accessing the ResultSet
     */
    private Job mapResultSetToJob(ResultSet rs) throws SQLException {
        Job job = new Job();
        job.setId(UUID.fromString(rs.getString("id")));
        job.setClientId(UUID.fromString(rs.getString("company_id")));
        job.setTitle(rs.getString("title"));
        job.setDescription(rs.getString("description"));
        job.setCategory(rs.getString("category"));
        job.setSkills(rs.getString("requirements"));
        job.setBudget(rs.getBigDecimal("budget"));
        job.setBudgetType(rs.getString("payment_type"));
        job.setDuration(rs.getString("duration"));
        job.setStatus(rs.getString("status"));
        job.setCreatedAt(rs.getTimestamp("posted_at"));
        job.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return job;
    }
}