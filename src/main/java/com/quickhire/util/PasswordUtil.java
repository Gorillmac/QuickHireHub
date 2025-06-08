package com.quickhire.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for password hashing and verification
 */
public class PasswordUtil {
    
    private static final int SALT_LENGTH = 16;
    private static final String HASH_ALGORITHM = "SHA-256";
    
    /**
     * Generate a random salt for password hashing
     * 
     * @return Base64 encoded salt string
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * Hash a password with a given salt
     * 
     * @param password The plain text password
     * @param salt The salt as a Base64 string
     * @return The hashed password
     */
    public static String hashPasswordWithSalt(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            
            // Add salt to the digest
            md.update(Base64.getDecoder().decode(salt));
            
            // Add password to the digest
            md.update(password.getBytes());
            
            // Generate the hash
            byte[] hashedPassword = md.digest();
            
            // Return the Base64 encoded hash
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password: " + e.getMessage(), e);
        }
    }
    
    /**
     * Verify a password against a stored hash and salt
     * 
     * @param password The plain text password to verify
     * @param storedHash The stored hash
     * @param storedSalt The stored salt
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash, String storedSalt) {
        String hashedPassword = hashPasswordWithSalt(password, storedSalt);
        return hashedPassword.equals(storedHash);
    }
}