package com.quickhire.model;

import java.sql.Timestamp;

/**
 * Message entity class representing messages between users
 */
public class Message {
    private int id;
    private int senderId;
    private int receiverId;
    private String content;
    private boolean isRead;
    private Timestamp sentAt;
    private int jobId; // Optional, can be null if not related to a specific job
    
    // Default constructor
    public Message() {
    }
    
    // Constructor with essential fields
    public Message(int senderId, int receiverId, String content) {
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.content = content;
        this.isRead = false;
    }
    
    // Full constructor
    public Message(int id, int senderId, int receiverId, String content, 
            boolean isRead, Timestamp sentAt, int jobId) {
        this.id = id;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.content = content;
        this.isRead = isRead;
        this.sentAt = sentAt;
        this.jobId = jobId;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getSenderId() {
        return senderId;
    }
    
    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }
    
    public int getReceiverId() {
        return receiverId;
    }
    
    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
    
    public Timestamp getSentAt() {
        return sentAt;
    }
    
    public void setSentAt(Timestamp sentAt) {
        this.sentAt = sentAt;
    }
    
    public int getJobId() {
        return jobId;
    }
    
    public void setJobId(int jobId) {
        this.jobId = jobId;
    }
    
    @Override
    public String toString() {
        return "Message [id=" + id + ", senderId=" + senderId + ", receiverId=" + receiverId 
                + ", sentAt=" + sentAt + "]";
    }
}
