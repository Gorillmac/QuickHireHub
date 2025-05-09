<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | QuickHire</title>
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
                        <h1 class="auth-title">Log In to Your Account</h1>
                        
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>${errorMessage}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i>
                                <span>${successMessage}</span>
                            </div>
                        </c:if>
                        
                        <form action="<c:url value='/login'/>" method="post" class="auth-form">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" id="username" name="username" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" required>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary btn-block">Log In</button>
                            </div>
                        </form>
                        
                        <div class="auth-links">
                            <p>Don't have an account? <a href="<c:url value='/register.jsp'/>">Sign Up</a></p>
                        </div>
                    </div>
                    
                    <div class="auth-image">
                        <img src="https://pixabay.com/get/g2177c836da7458b89db5273b1ba70ddaa12241bc94dcca845a26d765cdd22e772df8d3d571ce60437ab4a962364755378404ed35a215840a5ad2cb25b1f5ac21_1280.jpg" alt="Login">
                        <div class="auth-image-overlay">
                            <h2>Welcome Back!</h2>
                            <p>Log in to access your account and continue your freelance journey.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
</body>
</html>
