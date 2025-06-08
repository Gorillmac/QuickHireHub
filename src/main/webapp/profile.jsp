<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="profile-header">
            <div class="container">
                <h1>My Profile</h1>
                
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${sessionScope.successMessage}</span>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                
                <div class="profile-actions">
                    <a href="<c:url value='/profile/edit'/>" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit Profile
                    </a>
                    <c:if test="${user.isFreelancer()}">
                        <a href="<c:url value='/reviews/user/${user.id}'/>" class="btn btn-secondary">
                            <i class="fas fa-star"></i> My Reviews
                        </a>
                    </c:if>
                </div>
            </div>
        </section>
        
        <section class="profile-content">
            <div class="container">
                <div class="profile-grid">
                    <div class="profile-main">
                        <div class="profile-card">
                            <div class="profile-info">
                                <h2>
                                    <c:choose>
                                        <c:when test="${user.isFreelancer()}">
                                            ${not empty user.fullName ? user.fullName : user.username}
                                        </c:when>
                                        <c:when test="${user.isCompany()}">
                                            ${not empty user.companyName ? user.companyName : user.username}
                                        </c:when>
                                        <c:otherwise>
                                            ${user.username}
                                        </c:otherwise>
                                    </c:choose>
                                </h2>
                                
                                <div class="profile-meta">
                                    <c:if test="${user.isFreelancer()}">
                                        <span class="user-badge freelancer">Freelancer</span>
                                    </c:if>
                                    <c:if test="${user.isCompany()}">
                                        <span class="user-badge company">Company</span>
                                    </c:if>
                                    <c:if test="${user.isAdmin()}">
                                        <span class="user-badge admin">Admin</span>
                                    </c:if>
                                    
                                    <c:if test="${not empty user.location}">
                                        <span class="profile-location">
                                            <i class="fas fa-map-marker-alt"></i> ${user.location}
                                        </span>
                                    </c:if>
                                    
                                    <span class="profile-joined">
                                        <i class="fas fa-calendar-alt"></i> Member since 
                                        <fmt:formatDate value="${user.createdAt}" pattern="MMMM yyyy" />
                                    </span>
                                </div>
                                
                                <c:if test="${user.isFreelancer() && averageRating > 0}">
                                    <div class="rating">
                                        <div class="stars">
                                            <c:forEach begin="1" end="5" var="star">
                                                <i class="fas fa-star ${star <= averageRating ? 'filled' : ''}"></i>
                                            </c:forEach>
                                        </div>
                                        <span class="rating-value">${averageRating}/5</span>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="profile-description">
                                <h3>About Me</h3>
                                <c:choose>
                                    <c:when test="${not empty user.profileDescription}">
                                        <p>${user.profileDescription}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="empty-info">No profile description provided. <a href="<c:url value='/profile/edit'/>">Add one now</a>.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <c:if test="${user.isFreelancer() && not empty user.skills}">
                                <div class="profile-skills">
                                    <h3>Skills</h3>
                                    <div class="skills-tags">
                                        <c:forEach items="${fn:split(user.skills, ',')}" var="skill">
                                            <span class="skill-tag">${fn:trim(skill)}</span>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${user.isCompany()}">
                                <div class="company-details">
                                    <h3>Company Details</h3>
                                    <ul class="details-list">
                                        <c:if test="${not empty user.companyName}">
                                            <li>
                                                <i class="fas fa-building"></i>
                                                <div>
                                                    <span class="label">Company Name</span>
                                                    <span class="value">${user.companyName}</span>
                                                </div>
                                            </li>
                                        </c:if>
                                        
                                        <c:if test="${not empty user.companyWebsite}">
                                            <li>
                                                <i class="fas fa-globe"></i>
                                                <div>
                                                    <span class="label">Website</span>
                                                    <span class="value">
                                                        <a href="${user.companyWebsite}" target="_blank" rel="noopener noreferrer">
                                                            ${user.companyWebsite}
                                                        </a>
                                                    </span>
                                                </div>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="profile-sidebar">
                        <div class="sidebar-card">
                            <h3>Contact Information</h3>
                            <ul class="contact-list">
                                <li>
                                    <i class="fas fa-envelope"></i>
                                    <div>
                                        <span class="label">Email</span>
                                        <span class="value">${user.email}</span>
                                    </div>
                                </li>
                                
                                <c:if test="${not empty user.phoneNumber}">
                                    <li>
                                        <i class="fas fa-phone"></i>
                                        <div>
                                            <span class="label">Phone</span>
                                            <span class="value">${user.phoneNumber}</span>
                                        </div>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                        
                        <div class="sidebar-card">
                            <h3>Account Settings</h3>
                            <ul class="settings-list">
                                <li>
                                    <a href="<c:url value='/profile/edit'/>">
                                        <i class="fas fa-user-edit"></i> Edit Profile
                                    </a>
                                </li>
                                <li>
                                    <a href="<c:url value='/messages'/>">
                                        <i class="fas fa-envelope"></i> Messages
                                    </a>
                                </li>
                                <c:if test="${user.isFreelancer()}">
                                    <li>
                                        <a href="<c:url value='/dashboard-freelancer'/>">
                                            <i class="fas fa-tachometer-alt"></i> Dashboard
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${user.isCompany()}">
                                    <li>
                                        <a href="<c:url value='/dashboard-company'/>">
                                            <i class="fas fa-tachometer-alt"></i> Dashboard
                                        </a>
                                    </li>
                                </c:if>
                                <li>
                                    <a href="<c:url value='/logout'/>">
                                        <i class="fas fa-sign-out-alt"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
</body>
</html>
