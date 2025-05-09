<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | QuickHire</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="auth-section">
            <div class="container">
                <div class="auth-container">
                    <div class="auth-form-container">
                        <h1 class="auth-title">Create an Account</h1>
                        
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>${errorMessage}</span>
                            </div>
                        </c:if>
                        
                        <form action="<c:url value='/register'/>" method="post" class="auth-form">
                            <div class="form-group">
                                <label>I am a:</label>
                                <div class="radio-group">
                                    <label class="radio-container">
                                        <input type="radio" name="role" value="FREELANCER" checked id="role-freelancer">
                                        <span class="radio-label">Freelancer</span>
                                        <span class="radio-description">Looking for work opportunities</span>
                                    </label>
                                    
                                    <label class="radio-container">
                                        <input type="radio" name="role" value="COMPANY" id="role-company">
                                        <span class="radio-label">Company</span>
                                        <span class="radio-description">Looking to hire freelancers</span>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" id="username" name="username" required 
                                       pattern="^[a-zA-Z0-9]{3,20}$" 
                                       title="Username must be 3-20 alphanumeric characters">
                                <small>Username must be 3-20 alphanumeric characters</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" required>
                            </div>
                            
                            <div class="form-group" id="fullNameGroup">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName">
                            </div>
                            
                            <div class="form-group" id="companyNameGroup" style="display: none;">
                                <label for="companyName">Company Name</label>
                                <input type="text" id="companyName" name="companyName">
                            </div>
                            
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" required 
                                       minlength="8" 
                                       title="Password must be at least 8 characters long">
                                <small>Password must be at least 8 characters long</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="checkbox-container">
                                    <input type="checkbox" required>
                                    <span>I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></span>
                                </label>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary btn-block">Create Account</button>
                            </div>
                        </form>
                        
                        <div class="auth-links">
                            <p>Already have an account? <a href="<c:url value='/login.jsp'/>">Log In</a></p>
                        </div>
                    </div>
                    
                    <div class="auth-image">
                        <img src="https://pixabay.com/get/ga3606a2be41b2f2c5bb397fb3038b0f8eae619a7e8cd254bae9a65b6c26d39eaa82799c6906ff3942b1ada26996c6cfc42326e833c7d262f9c00b9030446f56b_1280.jpg" alt="Register">
                        <div class="auth-image-overlay">
                            <h2>Join QuickHire Today</h2>
                            <p>Connect with top freelancers and companies around the world.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
    <script>
        // Toggle between freelancer and company fields
        document.getElementById('role-freelancer').addEventListener('change', function() {
            document.getElementById('fullNameGroup').style.display = 'block';
            document.getElementById('companyNameGroup').style.display = 'none';
        });
        
        document.getElementById('role-company').addEventListener('change', function() {
            document.getElementById('fullNameGroup').style.display = 'none';
            document.getElementById('companyNameGroup').style.display = 'block';
        });
        
        // Password confirmation validation
        document.querySelector('.auth-form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match');
            }
        });
    </script>
</body>
</html>
