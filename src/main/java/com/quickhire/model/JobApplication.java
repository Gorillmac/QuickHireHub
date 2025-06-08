package com.quickhire.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.UUID;

/**
 * Represents a job application in the system
 */
public class JobApplication {
    
    private UUID id;
    private UUID jobId;
    private UUID freelancerId;
    private String coverLetter;
    private BigDecimal proposedAmount;
    private String status; // "pending", "accepted", "rejected", "withdrawn"
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Default constructor
    public JobApplication() {
        this.id = UUID.randomUUID();
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
        this.status = "pending";
    }
    
    // Constructor with fields
    public JobApplication(UUID jobId, UUID freelancerId, String coverLetter, 
                         BigDecimal proposedAmount) {
        this();
        this.jobId = jobId;
        this.freelancerId = freelancerId;
        this.coverLetter = coverLetter;
        this.proposedAmount = proposedAmount;
    }
    
    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getJobId() {
        return jobId;
    }

    public void setJobId(UUID jobId) {
        this.jobId = jobId;
    }

    public UUID getFreelancerId() {
        return freelancerId;
    }

    public void setFreelancerId(UUID freelancerId) {
        this.freelancerId = freelancerId;
    }

    public String getCoverLetter() {
        return coverLetter;
    }

    public void setCoverLetter(String coverLetter) {
        this.coverLetter = coverLetter;
    }

    public BigDecimal getProposedAmount() {
        return proposedAmount;
    }

    public void setProposedAmount(BigDecimal proposedAmount) {
        this.proposedAmount = proposedAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "JobApplication{" +
                "id=" + id +
                ", jobId=" + jobId +
                ", freelancerId=" + freelancerId +
                ", proposedAmount=" + proposedAmount +
                ", status='" + status + '\'' +
                '}';
    }
}