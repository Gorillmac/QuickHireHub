<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | QuickHire</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .error-container {
            text-align: center;
            padding: 100px 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .error-code {
            font-size: 120px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0;
            line-height: 1;
        }
        .error-message {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 30px;
        }
        .error-description {
            font-size: 18px;
            color: var(--medium-gray);
            margin-bottom: 40px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1 class="error-code">404</h1>
        <h2 class="error-message">Page Not Found</h2>
        <p class="error-description">Sorry, the page you are looking for does not exist or has been moved.</p>
        <div class="cta-buttons">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Back to Home</a>
            <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-secondary">Contact Support</a>
        </div>
    </div>
</body>
</html>