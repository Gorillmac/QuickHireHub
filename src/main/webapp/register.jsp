<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - QuickHire</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --secondary: #4cc9f0;
            --accent: #f72585;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
            --success: #4caf50;
            --warning: #ff9800;
            --danger: #f44336;
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
            background-color: #f0f2f5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .container {
            width: 95%;
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 15px;
        }
        
        /* Header */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
        }
        
        .logo i {
            margin-right: 0.5rem;
        }
        
        .nav-links {
            display: flex;
            align-items: center;
        }
        
        .nav-links a {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: var(--transition);
            border-radius: var(--border-radius);
        }
        
        .nav-links a:hover {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }
        
        .nav-links a.active {
            background-color: var(--primary);
            color: white;
        }
        
        /* Registration Form */
        .register-section {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        
        .register-container {
            width: 100%;
            max-width: 500px;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 2rem;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .register-header h1 {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        
        .register-header p {
            color: var(--gray);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
        }
        
        .user-type-container {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .user-type-option {
            flex: 1;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .user-type-option:hover {
            border-color: var(--primary);
        }
        
        .user-type-option.selected {
            border-color: var(--primary);
            background-color: rgba(67, 97, 238, 0.05);
        }
        
        .user-type-option i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 1rem;
            display: block;
        }
        
        .user-type-option h3 {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }
        
        .user-type-option p {
            font-size: 0.9rem;
            color: var(--gray);
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
            width: 100%;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
        }
        
        .form-footer {
            margin-top: 2rem;
            text-align: center;
        }
        
        .form-footer p {
            margin-bottom: 1rem;
            color: var(--gray);
        }
        
        .form-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }
        
        .form-footer a:hover {
            text-decoration: underline;
        }
        
        .error-message {
            background-color: rgba(244, 67, 54, 0.1);
            color: var(--danger);
            padding: 0.75rem 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
        
        /* Footer */
        footer {
            background-color: white;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
            padding: 2rem 0;
            margin-top: auto;
        }
        
        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .footer-logo {
            display: flex;
            align-items: center;
            font-weight: 700;
            color: var(--primary);
            gap: 0.5rem;
        }
        
        .footer-links a {
            color: var(--gray);
            text-decoration: none;
            margin-left: 1.5rem;
            transition: var(--transition);
        }
        
        .footer-links a:hover {
            color: var(--primary);
        }
        
        .footer-bottom {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #eee;
            color: var(--gray);
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .header-container, .footer-content {
                flex-direction: column;
                gap: 1rem;
            }
            
            .nav-links, .footer-links {
                width: 100%;
                justify-content: center;
            }
            
            .footer-links a {
                margin: 0 0.75rem;
            }
            
            .register-container {
                padding: 1.5rem;
            }
            
            .user-type-container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container header-container">
            <a href="index.jsp" class="logo"><i class="fas fa-bolt"></i> QuickHire</a>
            
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="about-us.jsp">About Us</a>
                <a href="contact.jsp">Contact</a>
                <a href="login.jsp">Log In</a>
                <a href="register.jsp" class="active">Sign Up</a>
            </div>
        </div>
    </header>
    
    <!-- Registration Form -->
    <section class="register-section">
        <div class="register-container">
            <div class="register-header">
                <h1>Create an Account</h1>
                <p>Join QuickHire to connect with top talent or find work</p>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="register" method="post" id="registerForm">
                <input type="hidden" name="userType" id="userType" value="${userType != null ? userType : 'freelancer'}">
                
                <div class="user-type-container">
                    <div class="user-type-option ${userType == null || userType == 'freelancer' ? 'selected' : ''}" data-type="freelancer">
                        <i class="fas fa-laptop-code"></i>
                        <h3>I'm a Freelancer</h3>
                        <p>Looking for work</p>
                    </div>
                    
                    <div class="user-type-option ${userType == 'client' ? 'selected' : ''}" data-type="client">
                        <i class="fas fa-building"></i>
                        <h3>I'm a Client</h3>
                        <p>Hiring for a project</p>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" class="form-control" value="${firstName != null ? firstName : ''}" required>
                </div>
                
                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="form-control" value="${lastName != null ? lastName : ''}" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" value="${email != null ? email : ''}" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                </div>
                
                <button type="submit" class="btn btn-primary">Create Account</button>
                
                <div class="form-footer">
                    <p>Already have an account? <a href="login.jsp">Log In</a></p>
                    <p>By signing up, you agree to our <a href="terms.jsp">Terms of Service</a> and <a href="privacy.jsp">Privacy Policy</a></p>
                </div>
            </form>
        </div>
    </section>
    
    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-logo">
                    <i class="fas fa-bolt"></i>
                    <span>QuickHire</span>
                </div>
                
                <div class="footer-links">
                    <a href="about-us.jsp">About Us</a>
                    <a href="how-it-works.jsp">How It Works</a>
                    <a href="terms.jsp">Terms</a>
                    <a href="privacy.jsp">Privacy</a>
                    <a href="contact.jsp">Contact</a>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 QuickHire Inc. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // User type selection
            const userTypeOptions = document.querySelectorAll('.user-type-option');
            const userTypeInput = document.getElementById('userType');
            
            userTypeOptions.forEach(option => {
                option.addEventListener('click', function() {
                    // Remove 'selected' class from all options
                    userTypeOptions.forEach(opt => opt.classList.remove('selected'));
                    
                    // Add 'selected' class to clicked option
                    this.classList.add('selected');
                    
                    // Update hidden input value
                    userTypeInput.value = this.getAttribute('data-type');
                });
            });
            
            // Form validation
            const registerForm = document.getElementById('registerForm');
            
            registerForm.addEventListener('submit', function(e) {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    return false;
                }
                
                return true;
            });
        });
    </script>
</body>
</html>