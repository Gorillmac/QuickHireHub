package com.quickhire.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Application entity class representing job applications
 */
public class Application {
    
    // Constants for application status
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_ACCEPTED = "ACCEPTED";
    public static final String STATUS_REJECTED = "REJECTED";
    public static final String STATUS_WITHDRAWN = "WITHDRAWN";
    public static final String STATUS_COMPLETED = "COMPLETED";
    
    private int id;
    private int jobId;
    private int freelancerId;
    private String coverLetter;
    private BigDecimal proposedRate;
    private int estimatedDuration; // In days
    private String status;
    private Timestamp appliedAt;
    private Timestamp updatedAt;
    
    // Default constructor
    public Application() {
    }
    
    // Constructor with essential fields
    public Application(int jobId, int freelancerId, String coverLetter, BigDecimal proposedRate) {
        this.jobId = jobId;
        this.freelancerId = freelancerId;
        this.coverLetter = coverLetter;
        this.proposedRate = proposedRate;
        this.status = STATUS_PENDING;
    }
    
    // Full constructor
    public Application(int id, int jobId, int freelancerId, String coverLetter, 
            BigDecimal proposedRate, int estimatedDuration, String status, 
            Timestamp appliedAt, Timestamp updatedAt) {
        this.id = id;
        this.jobId = jobId;
        this.freelancerId = freelancerId;
        this.coverLetter = coverLetter;
        this.proposedRate = proposedRate;
        this.estimatedDuration = estimatedDuration;
        this.status = status;
        this.appliedAt = appliedAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getJobId() {
        return jobId;
    }
    
    public void setJobId(int jobId) {
        this.jobId = jobId;
    }
    
    public int getFreelancerId() {
        return freelancerId;
    }
    
    public void setFreelancerId(int freelancerId) {
        this.freelancerId = freelancerId;
    }
    
    public String getCoverLetter() {
        return coverLetter;
    }
    
    public void setCoverLetter(String coverLetter) {
        this.coverLetter = coverLetter;
    }
    
    public BigDecimal getProposedRate() {
        return proposedRate;
    }
    
    public void setProposedRate(BigDecimal proposedRate) {
        this.proposedRate = proposedRate;
    }
    
    public int getEstimatedDuration() {
        return estimatedDuration;
    }
    
    public void setEstimatedDuration(int estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getAppliedAt() {
        return appliedAt;
    }
    
    public void setAppliedAt(Timestamp appliedAt) {
        this.appliedAt = appliedAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Helper methods
    public boolean isPending() {
        return STATUS_PENDING.equals(status);
    }
    
    public boolean isAccepted() {
        return STATUS_ACCEPTED.equals(status);
    }
    
    public boolean isRejected() {
        return STATUS_REJECTED.equals(status);
    }
    
    public boolean isWithdrawn() {
        return STATUS_WITHDRAWN.equals(status);
    }
    
    public boolean isCompleted() {
        return STATUS_COMPLETED.equals(status);
    }
    
    @Override
    public String toString() {
        return "Application [id=" + id + ", jobId=" + jobId + ", freelancerId=" + freelancerId 
                + ", status=" + status + "]";
    }
}
