package com.quickhire.model;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Review entity class representing reviews between users
 */
public class Review {
    private UUID id;
    private UUID reviewerId; // User who wrote the review
    private UUID reviewedUserId; // User who received the review
    private UUID jobId; // Associated job
    private int rating; // 1-5 stars
    private String comment;
    private Timestamp createdAt;
    
    // Attributes map for storing related objects
    private Map<String, Object> attributes = new HashMap<>();
    
    // Default constructor
    public Review() {
        this.id = UUID.randomUUID();
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }
    
    // Constructor with essential fields
    public Review(UUID reviewerId, UUID reviewedUserId, UUID jobId, int rating, String comment) {
        this();
        this.reviewerId = reviewerId;
        this.reviewedUserId = reviewedUserId;
        this.jobId = jobId;
        this.rating = rating;
        this.comment = comment;
    }
    
    // Full constructor
    public Review(UUID id, UUID reviewerId, UUID reviewedUserId, UUID jobId, 
            int rating, String comment, Timestamp createdAt) {
        this.id = id;
        this.reviewerId = reviewerId;
        this.reviewedUserId = reviewedUserId;
        this.jobId = jobId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }
    
    // Getters and setters
    public UUID getId() {
        return id;
    }
    
    public void setId(UUID id) {
        this.id = id;
    }
    
    public UUID getReviewerId() {
        return reviewerId;
    }
    
    public void setReviewerId(UUID reviewerId) {
        this.reviewerId = reviewerId;
    }
    
    public UUID getReviewedUserId() {
        return reviewedUserId;
    }
    
    public void setReviewedUserId(UUID reviewedUserId) {
        this.reviewedUserId = reviewedUserId;
    }
    
    public UUID getJobId() {
        return jobId;
    }
    
    public void setJobId(UUID jobId) {
        this.jobId = jobId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // Attribute methods for storing related objects
    public void setAttribute(String key, Object value) {
        attributes.put(key, value);
    }
    
    public Object getAttribute(String key) {
        return attributes.get(key);
    }
    
    public User getReviewer() {
        return (User) getAttribute("reviewer");
    }
    
    public Job getJob() {
        return (Job) getAttribute("job");
    }
    
    @Override
    public String toString() {
        return "Review [id=" + id + ", reviewerId=" + reviewerId + ", reviewedUserId=" + reviewedUserId 
                + ", rating=" + rating + "]";
    }
}
