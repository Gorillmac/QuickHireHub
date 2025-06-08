<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${profileUser.isFreelancer()}">
                ${not empty profileUser.fullName ? profileUser.fullName : profileUser.username}'s Profile
            </c:when>
            <c:when test="${profileUser.isCompany()}">
                ${not empty profileUser.companyName ? profileUser.companyName : profileUser.username} | Company Profile
            </c:when>
            <c:otherwise>
                ${profileUser.username}'s Profile
            </c:otherwise>
        </c:choose>
        | QuickHire
    </title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="profile-header">
            <div class="container">
                <h1>
                    <c:choose>
                        <c:when test="${profileUser.isFreelancer()}">
                            ${not empty profileUser.fullName ? profileUser.fullName : profileUser.username}'s Profile
                        </c:when>
                        <c:when test="${profileUser.isCompany()}">
                            ${not empty profileUser.companyName ? profileUser.companyName : profileUser.username}
                        </c:when>
                        <c:otherwise>
                            ${profileUser.username}'s Profile
                        </c:otherwise>
                    </c:choose>
                </h1>
                
                <div class="profile-actions">
                    <a href="<c:url value='/messages/conversation/${profileUser.id}'/>" class="btn btn-primary">
                        <i class="fas fa-envelope"></i> Send Message
                    </a>
                    <a href="<c:url value='/reviews/user/${profileUser.id}'/>" class="btn btn-secondary">
                        <i class="fas fa-star"></i> View Reviews
                    </a>
                    <a href="<c:url value='/reports/create/${profileUser.id}'/>" class="btn btn-outline">
                        <i class="fas fa-flag"></i> Report User
                    </a>
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
                                        <c:when test="${profileUser.isFreelancer()}">
                                            ${not empty profileUser.fullName ? profileUser.fullName : profileUser.username}
                                        </c:when>
                                        <c:when test="${profileUser.isCompany()}">
                                            ${not empty profileUser.companyName ? profileUser.companyName : profileUser.username}
                                        </c:when>
                                        <c:otherwise>
                                            ${profileUser.username}
                                        </c:otherwise>
                                    </c:choose>
                                </h2>
                                
                                <div class="profile-meta">
                                    <c:if test="${profileUser.isFreelancer()}">
                                        <span class="user-badge freelancer">Freelancer</span>
                                    </c:if>
                                    <c:if test="${profileUser.isCompany()}">
                                        <span class="user-badge company">Company</span>
                                    </c:if>
                                    
                                    <c:if test="${not empty profileUser.location}">
                                        <span class="profile-location">
                                            <i class="fas fa-map-marker-alt"></i> ${profileUser.location}
                                        </span>
                                    </c:if>
                                    
                                    <span class="profile-joined">
                                        <i class="fas fa-calendar-alt"></i> Member since 
                                        <fmt:formatDate value="${profileUser.createdAt}" pattern="MMMM yyyy" />
                                    </span>
                                </div>
                                
                                <c:if test="${profileUser.isFreelancer() && averageRating > 0}">
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
                                <h3>About</h3>
                                <c:choose>
                                    <c:when test="${not empty profileUser.profileDescription}">
                                        <p>${profileUser.profileDescription}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="empty-info">No profile description available.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <c:if test="${profileUser.isFreelancer() && not empty profileUser.skills}">
                                <div class="profile-skills">
                                    <h3>Skills</h3>
                                    <div class="skills-tags">
                                        <c:forEach items="${fn:split(profileUser.skills, ',')}" var="skill">
                                            <span class="skill-tag">${fn:trim(skill)}</span>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${profileUser.isCompany()}">
                                <div class="company-details">
                                    <h3>Company Details</h3>
                                    <ul class="details-list">
                                        <c:if test="${not empty profileUser.companyWebsite}">
                                            <li>
                                                <i class="fas fa-globe"></i>
                                                <div>
                                                    <span class="label">Website</span>
                                                    <span class="value">
                                                        <a href="${profileUser.companyWebsite}" target="_blank" rel="noopener noreferrer">
                                                            ${profileUser.companyWebsite}
                                                        </a>
                                                    </span>
                                                </div>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                            </c:if>
                        </div>
                        
                        <c:if test="${profileUser.isCompany()}">
                            <div class="company-jobs">
                                <h3>Recent Job Postings</h3>
                                <div class="job-cards">
                                    <!-- This would be populated with backend data in a real implementation -->
                                    <p class="empty-info">No job postings available to display.</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                    
                    <div class="profile-sidebar">
                        <div class="sidebar-card">
                            <h3>Contact Information</h3>
                            <ul class="contact-list">
                                <c:if test="${sessionScope.loggedIn}">
                                    <li>
                                        <i class="fas fa-envelope"></i>
                                        <div>
                                            <span class="label">Email</span>
                                            <span class="value">${profileUser.email}</span>
                                        </div>
                                    </li>
                                    
                                    <c:if test="${not empty profileUser.phoneNumber}">
                                        <li>
                                            <i class="fas fa-phone"></i>
                                            <div>
                                                <span class="label">Phone</span>
                                                <span class="value">${profileUser.phoneNumber}</span>
                                            </div>
                                        </li>
                                    </c:if>
                                </c:if>
                                
                                <c:if test="${!sessionScope.loggedIn}">
                                    <li class="login-to-view">
                                        <p><i class="fas fa-lock"></i> Log in to view contact information</p>
                                        <a href="<c:url value='/login'/>" class="btn btn-sm btn-secondary">Log In</a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                        
                        <div class="sidebar-card">
                            <h3>Work with ${profileUser.isFreelancer() ? 'this Freelancer' : 'this Company'}</h3>
                            <div class="work-actions">
                                <a href="<c:url value='/messages/conversation/${profileUser.id}'/>" class="btn btn-primary btn-block">
                                    <i class="fas fa-comment"></i> Send a Message
                                </a>
                                
                                <c:if test="${sessionScope.loggedIn && sessionScope.userRole eq 'COMPANY' && profileUser.isFreelancer()}">
                                    <p>Have a job for this freelancer?</p>
                                    <a href="<c:url value='/jobs/create'/>" class="btn btn-secondary btn-block">
                                        <i class="fas fa-briefcase"></i> Post a Job
                                    </a>
                                </c:if>
                                
                                <c:if test="${sessionScope.loggedIn && sessionScope.userRole eq 'FREELANCER' && profileUser.isCompany()}">
                                    <p>Interested in working with this company?</p>
                                    <a href="<c:url value='/jobs'/>" class="btn btn-secondary btn-block">
                                        <i class="fas fa-search"></i> Browse Company Jobs
                                    </a>
                                </c:if>
                            </div>
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
