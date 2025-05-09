package com.quickhire.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.quickhire.model.Job;
import com.quickhire.util.DatabaseUtil;

/**
 * Data Access Object for Job entities
 */
public class JobDAO {
    
    /**
     * Create a new job in the database
     * @param job The job to create
     * @return The created job with ID populated
     * @throws SQLException If a database error occurs
     */
    public Job create(Job job) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "INSERT INTO jobs (company_id, title, description, requirements, " +
                    "location, budget, payment_type, duration, category, skills, status, " +
                    "posted_at, updated_at, expires_at, approved) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW(), ?, ?)";
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, job.getCompanyId());
            ps.setString(2, job.getTitle());
            ps.setString(3, job.getDescription());
            ps.setString(4, job.getRequirements());
            ps.setString(5, job.getLocation());
            ps.setBigDecimal(6, job.getBudget());
            ps.setString(7, job.getPaymentType());
            ps.setString(8, job.getDuration());
            ps.setString(9, job.getCategory());
            ps.setString(10, job.getSkills());
            ps.setString(11, job.getStatus());
            ps.setTimestamp(12, job.getExpiresAt());
            ps.setBoolean(13, job.isApproved());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating job failed, no rows affected.");
            }
            
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                job.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating job failed, no ID obtained.");
            }
            
            return job;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get a job by ID
     * @param id The job ID
     * @return The job or null if not found
     * @throws SQLException If a database error occurs
     */
    public Job findById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM jobs WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractJobFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all jobs
     * @return List of all jobs
     * @throws SQLException If a database error occurs
     */
    public List<Job> findAll() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM jobs ORDER BY posted_at DESC";
            
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            List<Job> jobs = new ArrayList<>();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
            
            return jobs;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all open jobs
     * @return List of all open jobs
     * @throws SQLException If a database error occurs
     */
    public List<Job> findAllOpen() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM jobs WHERE status = ? AND approved = true ORDER BY posted_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, Job.STATUS_OPEN);
            
            rs = ps.executeQuery();
            
            List<Job> jobs = new ArrayList<>();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
            
            return jobs;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get jobs by company ID
     * @param companyId The company ID
     * @return List of jobs posted by the company
     * @throws SQLException If a database error occurs
     */
    public List<Job> findByCompanyId(int companyId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM jobs WHERE company_id = ? ORDER BY posted_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, companyId);
            
            rs = ps.executeQuery();
            
            List<Job> jobs = new ArrayList<>();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
            
            return jobs;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Search for jobs by title, description, or skills
     * @param query The search query
     * @return List of matching jobs
     * @throws SQLException If a database error occurs
     */
    public List<Job> search(String query) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM jobs WHERE (title LIKE ? OR description LIKE ? OR skills LIKE ?) " +
                    "AND status = ? AND approved = true ORDER BY posted_at DESC";
            
            ps = conn.prepareStatement(sql);
            String searchPattern = "%" + query + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, Job.STATUS_OPEN);
            
            rs = ps.executeQuery();
            
            List<Job> jobs = new ArrayList<>();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
            
            return jobs;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get unapproved jobs for admin moderation
     * @return List of unapproved jobs
     * @throws SQLException If a database error occurs
     */
    public List<Job> findUnapproved() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM jobs WHERE approved = false ORDER BY posted_at ASC";
            
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            List<Job> jobs = new ArrayList<>();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
            
            return jobs;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Update a job in the database
     * @param job The job to update
     * @return The updated job
     * @throws SQLException If a database error occurs
     */
    public Job update(Job job) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE jobs SET title = ?, description = ?, requirements = ?, " +
                    "location = ?, budget = ?, payment_type = ?, duration = ?, category = ?, " +
                    "skills = ?, status = ?, updated_at = NOW(), expires_at = ?, approved = ? " +
                    "WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getDescription());
            ps.setString(3, job.getRequirements());
            ps.setString(4, job.getLocation());
            ps.setBigDecimal(5, job.getBudget());
            ps.setString(6, job.getPaymentType());
            ps.setString(7, job.getDuration());
            ps.setString(8, job.getCategory());
            ps.setString(9, job.getSkills());
            ps.setString(10, job.getStatus());
            ps.setTimestamp(11, job.getExpiresAt());
            ps.setBoolean(12, job.isApproved());
            ps.setInt(13, job.getId());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating job failed, no rows affected.");
            }
            
            return job;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Delete a job from the database
     * @param id The ID of the job to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean delete(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "DELETE FROM jobs WHERE id = ?";
            
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
     * Approve a job
     * @param id The job ID
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean approveJob(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE jobs SET approved = true, updated_at = NOW() WHERE id = ?";
            
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
     * Close a job
     * @param id The job ID
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean closeJob(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE jobs SET status = ?, updated_at = NOW() WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, Job.STATUS_CLOSED);
            ps.setInt(2, id);
            
            int affectedRows = ps.executeUpdate();
            
            return affectedRows > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Extract a Job object from a ResultSet
     * @param rs The ResultSet containing job data
     * @return A Job object
     * @throws SQLException If a database error occurs
     */
    private Job extractJobFromResultSet(ResultSet rs) throws SQLException {
        Job job = new Job();
        job.setId(rs.getInt("id"));
        job.setCompanyId(rs.getInt("company_id"));
        job.setTitle(rs.getString("title"));
        job.setDescription(rs.getString("description"));
        job.setRequirements(rs.getString("requirements"));
        job.setLocation(rs.getString("location"));
        job.setBudget(rs.getBigDecimal("budget"));
        job.setPaymentType(rs.getString("payment_type"));
        job.setDuration(rs.getString("duration"));
        job.setCategory(rs.getString("category"));
        job.setSkills(rs.getString("skills"));
        job.setStatus(rs.getString("status"));
        job.setPostedAt(rs.getTimestamp("posted_at"));
        job.setUpdatedAt(rs.getTimestamp("updated_at"));
        job.setExpiresAt(rs.getTimestamp("expires_at"));
        job.setApproved(rs.getBoolean("approved"));
        return job;
    }
}
