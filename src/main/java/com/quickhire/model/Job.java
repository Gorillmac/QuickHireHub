package com.quickhire.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.UUID;

/**
 * Represents a job posting in the system
 */
public class Job {
    
    private UUID id;
    private UUID clientId; // The user ID of the client who posted the job
    private String title;
    private String description;
    private String category;
    private String skills; // Comma-separated list of required skills
    private BigDecimal budget;
    private String budgetType; // "fixed" or "hourly"
    private String duration; // "short", "medium", "long"
    private String experienceLevel; // "entry", "intermediate", "expert"
    private String status; // "open", "in_progress", "completed", "cancelled"
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Default constructor
    public Job() {
        this.id = UUID.randomUUID();
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
        this.status = "open";
    }
    
    // Constructor with fields
    public Job(UUID clientId, String title, String description, String category, 
               String skills, BigDecimal budget, String budgetType, String duration, 
               String experienceLevel) {
        this();
        this.clientId = clientId;
        this.title = title;
        this.description = description;
        this.category = category;
        this.skills = skills;
        this.budget = budget;
        this.budgetType = budgetType;
        this.duration = duration;
        this.experienceLevel = experienceLevel;
    }
    
    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getClientId() {
        return clientId;
    }

    public void setClientId(UUID clientId) {
        this.clientId = clientId;
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

    public BigDecimal getBudget() {
        return budget;
    }

    public void setBudget(BigDecimal budget) {
        this.budget = budget;
    }

    public String getBudgetType() {
        return budgetType;
    }

    public void setBudgetType(String budgetType) {
        this.budgetType = budgetType;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getExperienceLevel() {
        return experienceLevel;
    }

    public void setExperienceLevel(String experienceLevel) {
        this.experienceLevel = experienceLevel;
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
        return "Job{" +
                "id=" + id +
                ", clientId=" + clientId +
                ", title='" + title + '\'' +
                ", category='" + category + '\'' +
                ", budget=" + budget +
                ", budgetType='" + budgetType + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}