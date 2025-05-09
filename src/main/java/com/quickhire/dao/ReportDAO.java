package com.quickhire.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.quickhire.model.Report;
import com.quickhire.util.DatabaseUtil;

/**
 * Data Access Object for Report entities
 */
public class ReportDAO {
    
    /**
     * Create a new report in the database
     * @param report The report to create
     * @return The created report with ID populated
     * @throws SQLException If a database error occurs
     */
    public Report create(Report report) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "INSERT INTO reports (reporter_id, reported_user_id, reason, description, " +
                    "status, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, report.getReporterId());
            ps.setInt(2, report.getReportedUserId());
            ps.setString(3, report.getReason());
            ps.setString(4, report.getDescription());
            ps.setString(5, report.getStatus());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating report failed, no rows affected.");
            }
            
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                report.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating report failed, no ID obtained.");
            }
            
            return report;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get a report by ID
     * @param id The report ID
     * @return The report or null if not found
     * @throws SQLException If a database error occurs
     */
    public Report findById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reports WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractReportFromResultSet(rs);
            }
            
            return null;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all reports
     * @return List of all reports
     * @throws SQLException If a database error occurs
     */
    public List<Report> findAll() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reports ORDER BY created_at DESC";
            
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            List<Report> reports = new ArrayList<>();
            while (rs.next()) {
                reports.add(extractReportFromResultSet(rs));
            }
            
            return reports;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get all pending reports
     * @return List of pending reports
     * @throws SQLException If a database error occurs
     */
    public List<Report> findPending() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reports WHERE status = ? ORDER BY created_at ASC";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, Report.STATUS_PENDING);
            
            rs = ps.executeQuery();
            
            List<Report> reports = new ArrayList<>();
            while (rs.next()) {
                reports.add(extractReportFromResultSet(rs));
            }
            
            return reports;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get reports by status
     * @param status The report status
     * @return List of reports with the specified status
     * @throws SQLException If a database error occurs
     */
    public List<Report> findByStatus(String status) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reports WHERE status = ? ORDER BY created_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            
            rs = ps.executeQuery();
            
            List<Report> reports = new ArrayList<>();
            while (rs.next()) {
                reports.add(extractReportFromResultSet(rs));
            }
            
            return reports;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Get reports filed against a specific user
     * @param reportedUserId The ID of the reported user
     * @return List of reports against the user
     * @throws SQLException If a database error occurs
     */
    public List<Report> findByReportedUser(int reportedUserId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT * FROM reports WHERE reported_user_id = ? ORDER BY created_at DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, reportedUserId);
            
            rs = ps.executeQuery();
            
            List<Report> reports = new ArrayList<>();
            while (rs.next()) {
                reports.add(extractReportFromResultSet(rs));
            }
            
            return reports;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Count reports filed against a specific user
     * @param reportedUserId The ID of the reported user
     * @return Number of reports against the user
     * @throws SQLException If a database error occurs
     */
    public int countByReportedUser(int reportedUserId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "SELECT COUNT(*) FROM reports WHERE reported_user_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, reportedUserId);
            
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
     * Update a report in the database
     * @param report The report to update
     * @return The updated report
     * @throws SQLException If a database error occurs
     */
    public Report update(Report report) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE reports SET status = ?, admin_notes = ?, admin_id = ? " +
                    "WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, report.getStatus());
            ps.setString(2, report.getAdminNotes());
            
            // Handle nullable admin_id
            if (report.getAdminId() > 0) {
                ps.setInt(3, report.getAdminId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            ps.setInt(4, report.getId());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating report failed, no rows affected.");
            }
            
            return report;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Update report status
     * @param id The report ID
     * @param status The new status
     * @param adminId The admin handling the report
     * @param adminNotes Admin notes on the report
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean updateStatus(int id, String status, int adminId, String adminNotes) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "UPDATE reports SET status = ?, admin_id = ?, admin_notes = ?, " +
                    "resolved_at = ? WHERE id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, adminId);
            ps.setString(3, adminNotes);
            
            // Set resolved_at to current time if status is resolved or dismissed
            if (Report.STATUS_RESOLVED.equals(status) || Report.STATUS_DISMISSED.equals(status)) {
                ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(4, java.sql.Types.TIMESTAMP);
            }
            
            ps.setInt(5, id);
            
            int affectedRows = ps.executeUpdate();
            
            return affectedRows > 0;
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) DatabaseUtil.closeConnection(conn);
        }
    }
    
    /**
     * Delete a report from the database
     * @param id The ID of the report to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    public boolean delete(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            String sql = "DELETE FROM reports WHERE id = ?";
            
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
     * Extract a Report object from a ResultSet
     * @param rs The ResultSet containing report data
     * @return A Report object
     * @throws SQLException If a database error occurs
     */
    private Report extractReportFromResultSet(ResultSet rs) throws SQLException {
        Report report = new Report();
        report.setId(rs.getInt("id"));
        report.setReporterId(rs.getInt("reporter_id"));
        report.setReportedUserId(rs.getInt("reported_user_id"));
        report.setReason(rs.getString("reason"));
        report.setDescription(rs.getString("description"));
        report.setStatus(rs.getString("status"));
        report.setAdminNotes(rs.getString("admin_notes"));
        
        // Handle nullable admin_id
        int adminId = rs.getInt("admin_id");
        if (!rs.wasNull()) {
            report.setAdminId(adminId);
        }
        
        report.setCreatedAt(rs.getTimestamp("created_at"));
        report.setResolvedAt(rs.getTimestamp("resolved_at"));
        
        return report;
    }
}
