package com.quickhire.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for password hashing and verification
 */
public class PasswordUtils {
    
    private static final int SALT_LENGTH = 16;
    private static final String HASH_ALGORITHM = "SHA-256";
    
    /**
     * Generate a random salt for password hashing
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * Hash a password with a given salt
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt.getBytes());
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Hash a password with a new random salt
     * Returns a string in the format "hash:salt"
     */
    public static String hashNewPassword(String password) {
        String salt = generateSalt();
        String hash = hashPassword(password, salt);
        return hash + ":" + salt;
    }
    
    /**
     * Verify a password against a stored hash:salt combination
     */
    public static boolean verifyPassword(String password, String storedHashWithSalt) {
        try {
            String[] parts = storedHashWithSalt.split(":");
            String storedHash = parts[0];
            String salt = parts[1];
            
            String computedHash = hashPassword(password, salt);
            return computedHash.equals(storedHash);
        } catch (Exception e) {
            return false;
        }
    }
}
