package com.quickhire.model;

import java.sql.Timestamp;

/**
 * User entity class representing users in the system
 */
public class User {
    
    // Constants for user roles
    public static final String ROLE_FREELANCER = "FREELANCER";
    public static final String ROLE_COMPANY = "COMPANY";
    public static final String ROLE_ADMIN = "ADMIN";
    
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private String salt;
    private String role;
    private String fullName;
    private String profileDescription;
    private String skills; // Comma-separated list of skills (for freelancers)
    private String companyName; // For company users
    private String companyWebsite; // For company users
    private String location;
    private String phoneNumber;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean active;
    
    // Default constructor
    public User() {
    }
    
    // Constructor with essential fields
    public User(String username, String email, String passwordHash, String salt, String role) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.salt = salt;
        this.role = role;
        this.active = true;
    }
    
    // Full constructor
    public User(int id, String username, String email, String passwordHash, String salt, 
            String role, String fullName, String profileDescription, String skills, 
            String companyName, String companyWebsite, String location, String phoneNumber, 
            Timestamp createdAt, Timestamp updatedAt, boolean active) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.salt = salt;
        this.role = role;
        this.fullName = fullName;
        this.profileDescription = profileDescription;
        this.skills = skills;
        this.companyName = companyName;
        this.companyWebsite = companyWebsite;
        this.location = location;
        this.phoneNumber = phoneNumber;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.active = active;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getSalt() {
        return salt;
    }
    
    public void setSalt(String salt) {
        this.salt = salt;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getProfileDescription() {
        return profileDescription;
    }
    
    public void setProfileDescription(String profileDescription) {
        this.profileDescription = profileDescription;
    }
    
    public String getSkills() {
        return skills;
    }
    
    public void setSkills(String skills) {
        this.skills = skills;
    }
    
    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public String getCompanyWebsite() {
        return companyWebsite;
    }
    
    public void setCompanyWebsite(String companyWebsite) {
        this.companyWebsite = companyWebsite;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
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
    
    public boolean isActive() {
        return active;
    }
    
    public void setActive(boolean active) {
        this.active = active;
    }
    
    // Helper methods
    public boolean isFreelancer() {
        return ROLE_FREELANCER.equals(role);
    }
    
    public boolean isCompany() {
        return ROLE_COMPANY.equals(role);
    }
    
    public boolean isAdmin() {
        return ROLE_ADMIN.equals(role);
    }
    
    @Override
    public String toString() {
        return "User [id=" + id + ", username=" + username + ", email=" + email + ", role=" + role + "]";
    }
}
