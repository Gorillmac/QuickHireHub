<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Under Construction - QuickHire</title>
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
        
        .construction-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 5rem 1rem;
            text-align: center;
        }
        
        .construction-icon {
            font-size: 5rem;
            color: var(--primary);
            margin-bottom: 2rem;
        }
        
        .construction-title {
            font-size: 2.5rem;
            color: var(--dark);
            margin-bottom: 1rem;
        }
        
        .construction-message {
            font-size: 1.2rem;
            max-width: 600px;
            color: var(--gray);
            margin-bottom: 2.5rem;
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
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
            border: 2px solid var(--primary);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
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
        
        /* Animation */
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-30px);
            }
            60% {
                transform: translateY(-15px);
            }
        }
        
        .animated {
            animation: bounce 2s infinite;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .construction-title {
                font-size: 2rem;
            }
            
            .construction-message {
                font-size: 1rem;
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
    
    <!-- Under Construction Content -->
    <div class="construction-container">
        <i class="fas fa-hard-hat construction-icon animated"></i>
        <h1 class="construction-title">Under Construction</h1>
        <p class="construction-message">
            We're working hard to build this feature for you. Please check back soon as we're making improvements to enhance your QuickHire experience.
        </p>
        <a href="index.jsp" class="btn btn-primary">Back to Home</a>
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
        console.log("QuickHire under construction page loaded");
    </script>
</body>
</html>