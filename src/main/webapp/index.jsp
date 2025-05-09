<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickHire - Connect with Top Freelancers</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .welcome-container {
            text-align: center;
            max-width: 800px;
            margin: 100px auto;
            padding: 20px;
        }
        .welcome-title {
            color: #4361ee;
            font-size: 2.5rem;
            margin-bottom: 20px;
        }
        .welcome-message {
            font-size: 1.2rem;
            margin-bottom: 30px;
            color: #333;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #4361ee;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            margin: 10px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #3f37c9;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <h1 class="welcome-title">Welcome to QuickHire</h1>
        <p class="welcome-message">
            QuickHire is a platform for connecting talented freelancers with companies looking for skilled professionals. 
            Our mission is to make the process of finding work or hiring talent as smooth and efficient as possible.
        </p>
        <p class="welcome-message">
            <%= "Server time: " + new java.util.Date() %>
        </p>
        <div>
            <a href="register.jsp" class="btn">Sign Up</a>
            <a href="login.jsp" class="btn">Log In</a>
        </div>
    </div>
    
    <script>
        console.log("QuickHire homepage loaded successfully");
    </script>
</body>
</html>
