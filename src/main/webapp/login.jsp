<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - QuickHire</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
            --border-radius: 8px;
            --box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
        }
        
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
        }
        
        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
        }
        
        .logo i {
            margin-right: 0.5rem;
        }
        
        .auth-form-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 4rem 1rem;
        }
        
        .auth-form {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            width: 100%;
            max-width: 450px;
            padding: 2.5rem;
        }
        
        .auth-form-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .auth-form-header h2 {
            font-size: 2rem;
            color: var(--dark);
            margin-bottom: 1rem;
        }
        
        .auth-form-header p {
            color: var(--gray);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }
        
        .form-control {
            width: 100%;
            padding: 0.8rem 1rem;
            font-size: 1rem;
            border: 1px solid #ced4da;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }
        
        .form-control:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }
        
        .form-check {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .form-check-input {
            margin-right: 0.5rem;
            width: 18px;
            height: 18px;
        }
        
        .form-check-label {
            color: var(--gray);
        }
        
        .btn {
            display: inline-block;
            padding: 0.8rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 1rem;
            width: 100%;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
        }
        
        .forgot-password {
            display: block;
            text-align: center;
            margin-top: 1.5rem;
            color: var(--primary);
            text-decoration: none;
        }
        
        .forgot-password:hover {
            text-decoration: underline;
        }
        
        .auth-form-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #dee2e6;
            color: var(--gray);
        }
        
        .auth-form-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }
        
        .auth-form-footer a:hover {
            text-decoration: underline;
        }
        
        .social-login {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }
        
        .social-btn {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.8rem;
            border-radius: var(--border-radius);
            border: 1px solid #dee2e6;
            color: var(--dark);
            text-decoration: none;
            transition: var(--transition);
            background-color: white;
        }
        
        .social-btn i {
            margin-right: 0.5rem;
        }
        
        .social-btn:hover {
            background-color: #f8f9fa;
        }
        
        .btn-google {
            color: #ea4335;
        }
        
        .btn-facebook {
            color: #3b5998;
        }
        
        footer {
            background-color: var(--dark);
            color: white;
            padding: 1.5rem 0;
            margin-top: auto;
        }
        
        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .footer-content p {
            color: #adb5bd;
            font-size: 0.9rem;
        }
        
        .footer-links {
            display: flex;
            gap: 1.5rem;
        }
        
        .footer-links a {
            color: #adb5bd;
            text-decoration: none;
            font-size: 0.9rem;
            transition: var(--transition);
        }
        
        .footer-links a:hover {
            color: white;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .auth-form {
                padding: 2rem 1.5rem;
            }
            
            .footer-content {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container header-container">
            <a href="index.jsp" class="logo"><i class="fas fa-bolt"></i> QuickHire</a>
        </div>
    </header>
    
    <!-- Login Form -->
    <div class="auth-form-container">
        <div class="auth-form">
            <div class="auth-form-header">
                <h2>Welcome Back</h2>
                <p>Log in to access your QuickHire account</p>
            </div>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                </div>
                
                <div class="form-check">
                    <input type="checkbox" id="remember" name="remember" class="form-check-input">
                    <label for="remember" class="form-check-label">Remember me</label>
                </div>
                
                <button type="submit" class="btn btn-primary">Log In</button>
                
                <a href="#" class="forgot-password">Forgot your password?</a>
            </form>
            
            <div class="auth-form-footer">
                <p>Or log in with:</p>
                <div class="social-login">
                    <a href="#" class="social-btn btn-google">
                        <i class="fab fa-google"></i> Google
                    </a>
                    <a href="#" class="social-btn btn-facebook">
                        <i class="fab fa-facebook-f"></i> Facebook
                    </a>
                </div>
                
                <p style="margin-top: 2rem;">Don't have an account? <a href="register.jsp">Sign Up</a></p>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer>
        <div class="container footer-content">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> QuickHire Inc. All rights reserved.</p>
            
            <div class="footer-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Help Center</a>
            </div>
        </div>
    </footer>
    
    <script>
        console.log("QuickHire login page loaded successfully");
    </script>
</body>
</html>