package com.quickhire.model;

import java.sql.Timestamp;

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
