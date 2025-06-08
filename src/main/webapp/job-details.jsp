<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${job.title} | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="job-header">
            <div class="container">
                <div class="job-header-content">
                    <h1>${job.title}</h1>
                    
                    <div class="job-meta">
                        <span class="job-category">
                            <i class="fas fa-tag"></i> ${job.category}
                        </span>
                        <span class="job-location">
                            <i class="fas fa-map-marker-alt"></i> ${job.location}
                        </span>
                        <span class="job-date">
                            <i class="fas fa-calendar-alt"></i> Posted <fmt:formatDate value="${job.postedAt}" pattern="MMM dd, yyyy" />
                        </span>
                    </div>
                    
                    <div class="job-status">
                        <c:choose>
                            <c:when test="${job.status eq 'OPEN'}">
                                <span class="badge badge-success">Open</span>
                            </c:when>
                            <c:when test="${job.status eq 'CLOSED'}">
                                <span class="badge badge-danger">Closed</span>
                            </c:when>
                            <c:when test="${job.status eq 'COMPLETED'}">
                                <span class="badge badge-info">Completed</span>
                            </c:when>
                        </c:choose>
                    </div>
                    
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success mt-3">
                            <i class="fas fa-check-circle"></i>
                            <span>${sessionScope.successMessage}</span>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-error mt-3">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${sessionScope.errorMessage}</span>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>
                </div>
            </div>
        </section>
        
        <section class="job-details-section">
            <div class="container">
                <div class="job-details-grid">
                    <div class="job-details-main">
                        <div class="job-description-card">
                            <h2>Job Description</h2>
                            <div class="job-description">
                                <p>${job.description}</p>
                            </div>
                            
                            <c:if test="${not empty job.requirements}">
                                <h3>Requirements</h3>
                                <div class="job-requirements">
                                    <p>${job.requirements}</p>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty job.skills}">
                                <h3>Skills</h3>
                                <div class="skills-tags">
                                    <c:forEach items="${fn:split(job.skills, ',')}" var="skill">
                                        <span class="skill-tag">${fn:trim(skill)}</span>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                        
                        <c:if test="${sessionScope.userRole eq 'FREELANCER' && job.status eq 'OPEN'}">
                            <div class="application-actions">
                                <c:choose>
                                    <c:when test="${hasApplied}">
                                        <div class="applied-notice">
                                            <i class="fas fa-check-circle"></i>
                                            <span>You've already applied to this job</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='/applications/create/${job.id}'/>" class="btn btn-primary btn-large">
                                            <i class="fas fa-paper-plane"></i> Apply for this Job
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.userRole eq 'COMPANY' && sessionScope.userId eq job.companyId}">
                            <div class="company-actions">
                                <c:if test="${job.status eq 'OPEN' && job.approved}">
                                    <a href="<c:url value='/jobs/edit/${job.id}'/>" class="btn btn-secondary">
                                        <i class="fas fa-edit"></i> Edit Job
                                    </a>
                                    <a href="<c:url value='/jobs/close/${job.id}'/>" class="btn btn-danger"
                                       onclick="return confirm('Are you sure you want to close this job? This action cannot be undone.')">
                                        <i class="fas fa-times-circle"></i> Close Job
                                    </a>
                                </c:if>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.userRole eq 'ADMIN' && !job.approved}">
                            <div class="admin-actions">
                                <a href="<c:url value='/admin/jobs/approve/${job.id}'/>" class="btn btn-success">
                                    <i class="fas fa-check"></i> Approve Job
                                </a>
                                <a href="<c:url value='/admin/jobs/reject/${job.id}'/>" class="btn btn-danger"
                                   onclick="return confirm('Are you sure you want to reject and delete this job? This action cannot be undone.')">
                                    <i class="fas fa-times"></i> Reject Job
                                </a>
                            </div>
                        </c:if>
                    </div>
                    
                    <div class="job-details-sidebar">
                        <div class="sidebar-card">
                            <h3>Job Overview</h3>
                            <ul class="job-overview-list">
                                <li>
                                    <i class="fas fa-money-bill-wave"></i>
                                    <div>
                                        <span class="label">Budget</span>
                                        <span class="value">${job.budget != null ? '$'.concat(job.budget) : 'Not specified'}</span>
                                    </div>
                                </li>
                                <li>
                                    <i class="fas fa-credit-card"></i>
                                    <div>
                                        <span class="label">Payment Type</span>
                                        <span class="value">${not empty job.paymentType ? job.paymentType : 'Not specified'}</span>
                                    </div>
                                </li>
                                <li>
                                    <i class="fas fa-clock"></i>
                                    <div>
                                        <span class="label">Duration</span>
                                        <span class="value">${not empty job.duration ? job.duration : 'Not specified'}</span>
                                    </div>
                                </li>
                                <li>
                                    <i class="fas fa-calendar-check"></i>
                                    <div>
                                        <span class="label">Expiry Date</span>
                                        <span class="value"><fmt:formatDate value="${job.expiresAt}" pattern="MMM dd, yyyy" /></span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        
                        <div class="sidebar-card">
                            <h3>About the Client</h3>
                            <div class="company-info">
                                <h4>${company.companyName}</h4>
                                <p class="company-location"><i class="fas fa-map-marker-alt"></i> ${not empty company.location ? company.location : 'Location not specified'}</p>
                                
                                <c:if test="${not empty company.companyWebsite}">
                                    <p><i class="fas fa-globe"></i> <a href="${company.companyWebsite}" target="_blank" rel="noopener noreferrer">${company.companyWebsite}</a></p>
                                </c:if>
                                
                                <div class="company-description">
                                    <p>${not empty company.profileDescription ? company.profileDescription : 'No company description available.'}</p>
                                </div>
                                
                                <c:if test="${sessionScope.userRole eq 'FREELANCER' && sessionScope.loggedIn}">
                                    <div class="contact-actions">
                                        <a href="<c:url value='/messages/job-conversation/${company.id}-${job.id}'/>" class="btn btn-secondary btn-sm">
                                            <i class="fas fa-envelope"></i> Contact Client
                                        </a>
                                        <a href="<c:url value='/profile/view/${company.id}'/>" class="btn btn-outline btn-sm">
                                            <i class="fas fa-user"></i> View Profile
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="similar-jobs">
                    <h2>Similar Jobs</h2>
                    <p>Browse more jobs in ${job.category}</p>
                    
                    <!-- This would be populated with backend data in a real implementation -->
                    <div class="job-cards">
                        <div class="job-card">
                            <div class="job-card-header">
                                <h3>Frontend Developer</h3>
                                <span class="job-type">Remote</span>
                            </div>
                            <div class="job-card-body">
                                <p class="job-company">TechSolutions Inc.</p>
                                <p class="job-description">Looking for a skilled frontend developer to work on a responsive web application.</p>
                                <div class="job-tags">
                                    <span>React</span>
                                    <span>CSS</span>
                                    <span>JavaScript</span>
                                </div>
                            </div>
                            <div class="job-card-footer">
                                <p class="job-budget">$2,000 - $4,000</p>
                                <a href="#" class="btn btn-small">View Details</a>
                            </div>
                        </div>
                        
                        <div class="job-card">
                            <div class="job-card-header">
                                <h3>UI/UX Designer</h3>
                                <span class="job-type">Remote</span>
                            </div>
                            <div class="job-card-body">
                                <p class="job-company">DesignHub</p>
                                <p class="job-description">Seeking a creative UI/UX designer for a mobile app redesign project.</p>
                                <div class="job-tags">
                                    <span>Figma</span>
                                    <span>UI Design</span>
                                    <span>Mobile</span>
                                </div>
                            </div>
                            <div class="job-card-footer">
                                <p class="job-budget">$1,500 - $3,000</p>
                                <a href="#" class="btn btn-small">View Details</a>
                            </div>
                        </div>
                        
                        <div class="job-card">
                            <div class="job-card-header">
                                <h3>Full Stack Developer</h3>
                                <span class="job-type">Remote</span>
                            </div>
                            <div class="job-card-body">
                                <p class="job-company">WebCraft Solutions</p>
                                <p class="job-description">Looking for a full stack developer for an e-commerce platform development.</p>
                                <div class="job-tags">
                                    <span>Node.js</span>
                                    <span>React</span>
                                    <span>MongoDB</span>
                                </div>
                            </div>
                            <div class="job-card-footer">
                                <p class="job-budget">$3,000 - $5,000</p>
                                <a href="#" class="btn btn-small">View Details</a>
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
