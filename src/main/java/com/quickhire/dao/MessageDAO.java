package com.quickhire.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.quickhire.model.Message;
import com.quickhire.util.DatabaseUtil;

/**
 * Data Access Object for Message entities
 */
public class MessageDAO {
    
    /**
     * Create a new message in the database
     * @param message The message to create
     * @return The created message with ID populated
     * @throws SQLException If a database error occurs
     */
    public Message create(Message message) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "INSERT INTO messages (sender_id, receiver_id, content, is_read, sent_at, job_id) " +
                    "VALUES (?, ?, ?, ?, NOW(), ?)";
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, message.getSenderId());
            ps.setInt(2, message.getReceiverId());
            ps.setString(3, message.getContent());
            ps.setBoolean(4, message.isRead());
            
            // Handle nullable job_id
            if (message.getJobId() > 0) {
                ps.setInt(5, message.getJobId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating message failed, no rows affected.");
            }
            
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                message.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating message failed, no ID obtained.");
            }
            
            return message;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get a message by ID
     * @param id The message ID
     * @return The message or null if not found
     * @throws SQLException If a database error occurs
     */
    public Message findById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM messages WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractMessageFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get messages for a specific user
     * @param userId The user ID
     * @return List of messages received by the user
     * @throws SQLException If a database error occurs
     */
    public List<Message> findByReceiver(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM messages WHERE receiver_id = ? ORDER BY sent_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            rs = ps.executeQuery();
            
            List<Message> messages = new ArrayList<>();
            while (rs.next()) {
                messages.add(extractMessageFromResultSet(rs));
            }
            
            return messages;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get messages sent by a specific user
     * @param userId The user ID
     * @return List of messages sent by the user
     * @throws SQLException If a database error occurs
     */
    public List<Message> findBySender(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM messages WHERE sender_id = ? ORDER BY sent_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            rs = ps.executeQuery();
            
            List<Message> messages = new ArrayList<>();
            while (rs.next()) {
                messages.add(extractMessageFromResultSet(rs));
            }
            
            return messages;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get conversation between two users
     * @param user1Id First user ID
     * @param user2Id Second user ID
     * @return List of messages exchanged between the users
     * @throws SQLException If a database error occurs
     */
    public List<Message> getConversation(int user1Id, int user2Id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM messages WHERE (sender_id = ? AND receiver_id = ?) " +
                    "OR (sender_id = ? AND receiver_id = ?) ORDER BY sent_at ASC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, user1Id);
            ps.setInt(2, user2Id);
            ps.setInt(3, user2Id);
            ps.setInt(4, user1Id);
            
            rs = ps.executeQuery();
            
            List<Message> messages = new ArrayList<>();
            while (rs.next()) {
                messages.add(extractMessageFromResultSet(rs));
            }
            
            return messages;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get conversation between two users for a specific job
     * @param user1Id First user ID
     * @param user2Id Second user ID
     * @param jobId The job ID
     * @return List of messages exchanged between the users for the job
     * @throws SQLException If a database error occurs
     */
    public List<Message> getJobConversation(int user1Id, int user2Id, int jobId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM messages WHERE ((sender_id = ? AND receiver_id = ?) " +
                    "OR (sender_id = ? AND receiver_id = ?)) AND job_id = ? ORDER BY sent_at ASC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, user1Id);
            ps.setInt(2, user2Id);
            ps.setInt(3, user2Id);
            ps.setInt(4, user1Id);
            ps.setInt(5, jobId);
            
            rs = ps.executeQuery();
            
            List<Message> messages = new ArrayList<>();
            while (rs.next()) {
                messages.add(extractMessageFromResultSet(rs));
            }
            
            return messages;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get count of unread messages for a user
     * @param userId The user ID
     * @return Number of unread messages
     * @throws SQLException If a database error occurs
     */
    public int getUnreadCount(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND is_read = false";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
            return 0;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Mark message as read
     * @param id The message ID
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean markAsRead(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE messages SET is_read = true WHERE id = ?";
            
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
     * Mark all messages from a sender to a receiver as read
     * @param senderId The sender ID
     * @param receiverId The receiver ID
     * @return Number of messages marked as read
     * @throws SQLException If a database error occurs
     */
    public int markAllAsRead(int senderId, int receiverId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE messages SET is_read = true " +
                    "WHERE sender_id = ? AND receiver_id = ? AND is_read = false";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            
            return ps.executeUpdate();
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Delete a message from the database
     * @param id The ID of the message to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean delete(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "DELETE FROM messages WHERE id = ?";
            
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
     * Extract a Message object from a ResultSet
     * @param rs The ResultSet containing message data
     * @return A Message object
     * @throws SQLException If a database error occurs
     */
    private Message extractMessageFromResultSet(ResultSet rs) throws SQLException {
        Message message = new Message();
        message.setId(rs.getInt("id"));
        message.setSenderId(rs.getInt("sender_id"));
        message.setReceiverId(rs.getInt("receiver_id"));
        message.setContent(rs.getString("content"));
        message.setRead(rs.getBoolean("is_read"));
        message.setSentAt(rs.getTimestamp("sent_at"));
        
        // Handle nullable job_id
        int jobId = rs.getInt("job_id");
        if (!rs.wasNull()) {
            message.setJobId(jobId);
        }
        
        return message;
    }
}
