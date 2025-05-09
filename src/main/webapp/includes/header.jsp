<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="site-header">
    <div class="container">
        <div class="logo">
            <a href="<c:url value='/'/>">
                <h1>QuickHire</h1>
            </a>
        </div>
        <nav class="main-nav">
            <ul>
                <li><a href="<c:url value='/jobs'/>">Find Jobs</a></li>
                <li><a href="<c:url value='/freelancers'/>">Find Freelancers</a></li>
                <li><a href="<c:url value='/about.jsp'/>">About Us</a></li>
                <li><a href="<c:url value='/contact.jsp'/>">Contact</a></li>
            </ul>
        </nav>
        <div class="auth-buttons">
            <a href="<c:url value='/login.jsp'/>" class="btn btn-outline">Log In</a>
            <a href="<c:url value='/register.jsp'/>" class="btn btn-primary">Sign Up</a>
        </div>
        <div class="mobile-menu-toggle">
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
</header>