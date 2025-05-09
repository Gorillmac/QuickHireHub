<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="site-footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-section about">
                <h3>About QuickHire</h3>
                <p>QuickHire is a leading freelance platform connecting businesses with talented professionals from around the world.</p>
                <div class="social-media">
                    <a href="#" class="social-icon"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-linkedin"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            
            <div class="footer-section links">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="<c:url value='/jobs'/>">Browse Jobs</a></li>
                    <li><a href="<c:url value='/freelancers'/>">Find Freelancers</a></li>
                    <li><a href="<c:url value='/how-it-works.jsp'/>">How It Works</a></li>
                    <li><a href="<c:url value='/pricing.jsp'/>">Pricing</a></li>
                    <li><a href="<c:url value='/faq.jsp'/>">FAQ</a></li>
                </ul>
            </div>
            
            <div class="footer-section contact">
                <h3>Contact Us</h3>
                <ul class="contact-info">
                    <li><i class="fas fa-map-marker-alt"></i> 123 Business Avenue, Tech City</li>
                    <li><i class="fas fa-envelope"></i> info@quickhire.com</li>
                    <li><i class="fas fa-phone"></i> +1 (555) 123-4567</li>
                </ul>
            </div>
            
            <div class="footer-section newsletter">
                <h3>Newsletter</h3>
                <p>Subscribe to our newsletter for the latest updates and job opportunities.</p>
                <form class="newsletter-form">
                    <input type="email" placeholder="Enter your email" required>
                    <button type="submit" class="btn btn-primary">Subscribe</button>
                </form>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; 2025 QuickHire. All rights reserved.</p>
            <div class="footer-bottom-links">
                <a href="<c:url value='/terms.jsp'/>">Terms of Service</a>
                <a href="<c:url value='/privacy.jsp'/>">Privacy Policy</a>
                <a href="<c:url value='/cookies.jsp'/>">Cookie Policy</a>
            </div>
        </div>
    </div>
</footer>