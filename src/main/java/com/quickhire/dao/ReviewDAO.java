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

import com.quickhire.model.Review;
import com.quickhire.util.DatabaseUtil;

/**
 * Data Access Object for Review entities
 */
public class ReviewDAO {
    
    /**
     * Create a new review in the database
     * @param review The review to create
     * @return The created review with ID populated
     * @throws SQLException If a database error occurs
     */
    public Review create(Review review) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "INSERT INTO reviews (id, reviewer_id, reviewed_user_id, job_id, " +
                    "rating, comment, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, review.getId());
            ps.setObject(2, review.getReviewerId());
            ps.setObject(3, review.getReviewedUserId());
            ps.setObject(4, review.getJobId());
            ps.setInt(5, review.getRating());
            ps.setString(6, review.getComment());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating review failed, no rows affected.");
            }
            
            return review;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get a review by ID
     * @param id The review ID
     * @return The review or null if not found
     * @throws SQLException If a database error occurs
     */
    public Review findById(UUID id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reviews WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, id);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractReviewFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all reviews
     * @return List of all reviews
     * @throws SQLException If a database error occurs
     */
    public List<Review> findAll() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reviews ORDER BY created_at DESC";
            
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            
            return reviews;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get reviews for a specific user
     * @param userId The user ID
     * @return List of reviews for the user
     * @throws SQLException If a database error occurs
     */
    public List<Review> findByReviewedUser(UUID userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reviews WHERE reviewed_user_id = ? ORDER BY created_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, userId);
            
            rs = ps.executeQuery();
            
            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            
            return reviews;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get reviews written by a specific user
     * @param userId The user ID
     * @return List of reviews written by the user
     * @throws SQLException If a database error occurs
     */
    public List<Review> findByReviewer(UUID userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reviews WHERE reviewer_id = ? ORDER BY created_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, userId);
            
            rs = ps.executeQuery();
            
            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            
            return reviews;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get reviews for a specific job
     * @param jobId The job ID
     * @return List of reviews for the job
     * @throws SQLException If a database error occurs
     */
    public List<Review> findByJob(UUID jobId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reviews WHERE job_id = ? ORDER BY created_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, jobId);
            
            rs = ps.executeQuery();
            
            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                reviews.add(extractReviewFromResultSet(rs));
            }
            
            return reviews;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get average rating for a user
     * @param userId The user ID
     * @return Average rating or 0 if no reviews
     * @throws SQLException If a database error occurs
     */
    public double getAverageRating(UUID userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT AVG(rating) FROM reviews WHERE reviewed_user_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, userId);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
            
            return 0;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Check if a user has already reviewed a specific job
     * @param reviewerId The reviewer ID
     * @param jobId The job ID
     * @return true if already reviewed, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean hasReviewed(UUID reviewerId, UUID jobId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT COUNT(*) FROM reviews WHERE reviewer_id = ? AND job_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, reviewerId);
            ps.setObject(2, jobId);
            
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
     * Update a review in the database
     * @param review The review to update
     * @return The updated review
     * @throws SQLException If a database error occurs
     */
    public Review update(Review review) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE reviews SET rating = ?, comment = ? WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, review.getRating());
            ps.setString(2, review.getComment());
            ps.setObject(3, review.getId());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating review failed, no rows affected.");
            }
            
            return review;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Delete a review from the database
     * @param id The ID of the review to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean delete(UUID id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "DELETE FROM reviews WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setObject(1, id);
            
            int affectedRows = ps.executeUpdate();
            
            return affectedRows > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Extract a Review object from a ResultSet
     * @param rs The ResultSet containing review data
     * @return A Review object
     * @throws SQLException If a database error occurs
     */
    private Review extractReviewFromResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(UUID.fromString(rs.getString("id")));
        review.setReviewerId(UUID.fromString(rs.getString("reviewer_id")));
        review.setReviewedUserId(UUID.fromString(rs.getString("reviewed_user_id")));
        review.setJobId(UUID.fromString(rs.getString("job_id")));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        return review;
    }
}
