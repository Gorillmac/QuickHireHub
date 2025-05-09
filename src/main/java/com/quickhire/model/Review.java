package com.quickhire.model;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

/**
 * Review entity class representing reviews between users
 */
public class Review {
    private int id;
    private int reviewerId; // User who wrote the review
    private int reviewedUserId; // User who received the review
    private int jobId; // Associated job
    private int rating; // 1-5 stars
    private String comment;
    private Timestamp createdAt;
    
    // Attributes map for storing related objects
    private Map<String, Object> attributes = new HashMap<>();
    
    // Default constructor
    public Review() {
    }
    
    // Constructor with essential fields
    public Review(int reviewerId, int reviewedUserId, int jobId, int rating, String comment) {
        this.reviewerId = reviewerId;
        this.reviewedUserId = reviewedUserId;
        this.jobId = jobId;
        this.rating = rating;
        this.comment = comment;
    }
    
    // Full constructor
    public Review(int id, int reviewerId, int reviewedUserId, int jobId, 
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
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getReviewerId() {
        return reviewerId;
    }
    
    public void setReviewerId(int reviewerId) {
        this.reviewerId = reviewerId;
    }
    
    public int getReviewedUserId() {
        return reviewedUserId;
    }
    
    public void setReviewedUserId(int reviewedUserId) {
        this.reviewedUserId = reviewedUserId;
    }
    
    public int getJobId() {
        return jobId;
    }
    
    public void setJobId(int jobId) {
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
