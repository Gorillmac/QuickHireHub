package com.quickhire.model;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

/**
 * Report entity class representing abuse reports in the system
 */
public class Report {
    
    // Constants for report status
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_INVESTIGATING = "INVESTIGATING";
    public static final String STATUS_RESOLVED = "RESOLVED";
    public static final String STATUS_DISMISSED = "DISMISSED";
    
    private int id;
    private int reporterId; // User who created the report
    private int reportedUserId; // User being reported
    private String reason;
    private String description;
    private String status;
    private String adminNotes;
    private int adminId; // Admin who handled the report
    private Timestamp createdAt;
    private Timestamp resolvedAt;
    
    // Attributes map for storing related objects
    private Map<String, Object> attributes = new HashMap<>();
    
    // Default constructor
    public Report() {
    }
    
    // Constructor with essential fields
    public Report(int reporterId, int reportedUserId, String reason, String description) {
        this.reporterId = reporterId;
        this.reportedUserId = reportedUserId;
        this.reason = reason;
        this.description = description;
        this.status = STATUS_PENDING;
    }
    
    // Full constructor
    public Report(int id, int reporterId, int reportedUserId, String reason, String description, 
            String status, String adminNotes, int adminId, Timestamp createdAt, Timestamp resolvedAt) {
        this.id = id;
        this.reporterId = reporterId;
        this.reportedUserId = reportedUserId;
        this.reason = reason;
        this.description = description;
        this.status = status;
        this.adminNotes = adminNotes;
        this.adminId = adminId;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getReporterId() {
        return reporterId;
    }
    
    public void setReporterId(int reporterId) {
        this.reporterId = reporterId;
    }
    
    public int getReportedUserId() {
        return reportedUserId;
    }
    
    public void setReportedUserId(int reportedUserId) {
        this.reportedUserId = reportedUserId;
    }
    
    public String getReason() {
        return reason;
    }
    
    public void setReason(String reason) {
        this.reason = reason;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getAdminNotes() {
        return adminNotes;
    }
    
    public void setAdminNotes(String adminNotes) {
        this.adminNotes = adminNotes;
    }
    
    public int getAdminId() {
        return adminId;
    }
    
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getResolvedAt() {
        return resolvedAt;
    }
    
    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }
    
    // Attribute methods for storing related objects
    public void setAttribute(String key, Object value) {
        attributes.put(key, value);
    }
    
    public Object getAttribute(String key) {
        return attributes.get(key);
    }
    
    public User getReporter() {
        return (User) getAttribute("reporter");
    }
    
    public User getReportedUser() {
        return (User) getAttribute("reportedUser");
    }
    
    public User getAdmin() {
        return (User) getAttribute("admin");
    }
    
    // Helper methods
    public boolean isPending() {
        return STATUS_PENDING.equals(status);
    }
    
    public boolean isInvestigating() {
        return STATUS_INVESTIGATING.equals(status);
    }
    
    public boolean isResolved() {
        return STATUS_RESOLVED.equals(status) || STATUS_DISMISSED.equals(status);
    }
    
    @Override
    public String toString() {
        return "Report [id=" + id + ", reporterId=" + reporterId + ", reportedUserId=" + reportedUserId 
                + ", status=" + status + "]";
    }
}
