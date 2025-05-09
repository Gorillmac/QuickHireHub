package com.quickhire.model;

import java.sql.Timestamp;
import java.util.UUID;

/**
 * Represents a user in the system
 */
public class User {
    // Constants for user roles
    public static final String ROLE_FREELANCER = "FREELANCER";
    public static final String ROLE_CLIENT = "CLIENT";
    public static final String ROLE_ADMIN = "ADMIN";
    
    private UUID id;
    private String email;
    private String passwordHash;
    private String password; // Not stored, used for password confirmation
    private String salt;
    private String firstName;
    private String lastName;
    private String userType; // "freelancer" or "client" or "admin" 
    private String bio;
    private String location;
    private String phone;
    private String website;
    private String companyName;
    private String title;
    private String skills;
    private String profilePicture;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;
    
    // Default constructor
    public User() {
        this.id = UUID.randomUUID();
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
        this.isActive = true;
    }
    
    // Constructor with fields
    public User(String email, String passwordHash, String firstName, String lastName, String userType) {
        this();
        this.email = email;
        this.passwordHash = passwordHash;
        this.firstName = firstName;
        this.lastName = lastName;
        this.userType = userType;
    }
    
    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
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
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getSalt() {
        return salt;
    }
    
    public void setSalt(String salt) {
        this.salt = salt;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getUserType() {
        return userType;
    }
    
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    public String getBio() {
        return bio;
    }
    
    public void setBio(String bio) {
        this.bio = bio;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getWebsite() {
        return website;
    }
    
    public void setWebsite(String website) {
        this.website = website;
    }
    
    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getSkills() {
        return skills;
    }
    
    public void setSkills(String skills) {
        this.skills = skills;
    }
    
    public String getProfilePicture() {
        return profilePicture;
    }
    
    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
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
        return isActive;
    }
    
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    // Helper methods
    public boolean isFreelancer() {
        return ROLE_FREELANCER.equalsIgnoreCase(userType);
    }
    
    public boolean isClient() {
        return ROLE_CLIENT.equalsIgnoreCase(userType);
    }
    
    public boolean isAdmin() {
        return ROLE_ADMIN.equalsIgnoreCase(userType);
    }
    
    public boolean isCompany() {
        return isClient(); // Alias for isClient()
    }
    
    @Override
    public String toString() {
        return "User{" +
               "id=" + id +
               ", email='" + email + '\'' +
               ", firstName='" + firstName + '\'' +
               ", lastName='" + lastName + '\'' +
               ", userType='" + userType + '\'' +
               ", isActive=" + isActive +
               '}';
    }
}