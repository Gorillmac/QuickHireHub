package com.quickhire.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Job entity class representing job postings
 */
public class Job {
    
    // Constants for job status
    public static final String STATUS_OPEN = "OPEN";
    public static final String STATUS_CLOSED = "CLOSED";
    public static final String STATUS_COMPLETED = "COMPLETED";
    
    private int id;
    private int companyId; // User ID of the company
    private String title;
    private String description;
    private String requirements;
    private String location; // Could be "Remote" or specific location
    private BigDecimal budget;
    private String paymentType; // Hourly, Fixed, etc.
    private String duration; // E.g., "2 weeks", "3 months", etc.
    private String category;
    private String skills; // Comma-separated skills required
    private String status;
    private Timestamp postedAt;
    private Timestamp updatedAt;
    private Timestamp expiresAt;
    private boolean approved; // For admin approval
    
    // Default constructor
    public Job() {
    }
    
    // Constructor with essential fields
    public Job(int companyId, String title, String description, BigDecimal budget, String status) {
        this.companyId = companyId;
        this.title = title;
        this.description = description;
        this.budget = budget;
        this.status = status;
        this.approved = false; // Default to not approved
    }
    
    // Full constructor
    public Job(int id, int companyId, String title, String description, String requirements, 
            String location, BigDecimal budget, String paymentType, String duration, 
            String category, String skills, String status, Timestamp postedAt, 
            Timestamp updatedAt, Timestamp expiresAt, boolean approved) {
        this.id = id;
        this.companyId = companyId;
        this.title = title;
        this.description = description;
        this.requirements = requirements;
        this.location = location;
        this.budget = budget;
        this.paymentType = paymentType;
        this.duration = duration;
        this.category = category;
        this.skills = skills;
        this.status = status;
        this.postedAt = postedAt;
        this.updatedAt = updatedAt;
        this.expiresAt = expiresAt;
        this.approved = approved;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getCompanyId() {
        return companyId;
    }
    
    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getRequirements() {
        return requirements;
    }
    
    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public BigDecimal getBudget() {
        return budget;
    }
    
    public void setBudget(BigDecimal budget) {
        this.budget = budget;
    }
    
    public String getPaymentType() {
        return paymentType;
    }
    
    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getSkills() {
        return skills;
    }
    
    public void setSkills(String skills) {
        this.skills = skills;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getPostedAt() {
        return postedAt;
    }
    
    public void setPostedAt(Timestamp postedAt) {
        this.postedAt = postedAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Timestamp getExpiresAt() {
        return expiresAt;
    }
    
    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }
    
    public boolean isApproved() {
        return approved;
    }
    
    public void setApproved(boolean approved) {
        this.approved = approved;
    }
    
    // Helper methods
    public boolean isOpen() {
        return STATUS_OPEN.equals(status);
    }
    
    public boolean isClosed() {
        return STATUS_CLOSED.equals(status) || STATUS_COMPLETED.equals(status);
    }
    
    @Override
    public String toString() {
        return "Job [id=" + id + ", title=" + title + ", status=" + status + "]";
    }
}
