<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Freelancer Dashboard | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="dashboard-header">
            <div class="container">
                <h1>Freelancer Dashboard</h1>
                <p>Manage your applications and find new opportunities</p>
                
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>${sessionScope.successMessage}</span>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${sessionScope.errorMessage}</span>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
                
                <div class="dashboard-actions">
                    <a href="<c:url value='/jobs'/>" class="btn btn-primary"><i class="fas fa-search"></i> Find Jobs</a>
                    <a href="<c:url value='/profile'/>" class="btn btn-secondary"><i class="fas fa-user"></i> View Profile</a>
                    <a href="<c:url value='/messages'/>" class="btn btn-secondary"><i class="fas fa-envelope"></i> Messages</a>
                </div>
            </div>
        </section>
        
        <section class="dashboard-content">
            <div class="container">
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${applications.size()}</h3>
                            <p>Total Applications</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-info">
                            <c:set var="acceptedCount" value="0" />
                            <c:forEach items="${applications}" var="app">
                                <c:if test="${app.status eq 'ACCEPTED'}">
                                    <c:set var="acceptedCount" value="${acceptedCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <h3>${acceptedCount}</h3>
                            <p>Accepted Applications</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-info">
                            <c:set var="pendingCount" value="0" />
                            <c:forEach items="${applications}" var="app">
                                <c:if test="${app.status eq 'PENDING'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <h3>${pendingCount}</h3>
                            <p>Pending Applications</p>
                        </div>
                    </div>
                </div>
                
                <div class="dashboard-section">
                    <div class="section-header">
                        <h2>Your Applications</h2>
                        <div class="section-actions">
                            <select id="applicationFilter" class="form-select">
                                <option value="all">All Applications</option>
                                <option value="pending">Pending</option>
                                <option value="accepted">Accepted</option>
                                <option value="rejected">Rejected</option>
                                <option value="withdrawn">Withdrawn</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="application-list">
                        <c:choose>
                            <c:when test="${empty applications}">
                                <div class="empty-state">
                                    <i class="fas fa-file-alt"></i>
                                    <h3>No applications yet</h3>
                                    <p>Browse jobs and submit your first application</p>
                                    <a href="<c:url value='/jobs'/>" class="btn btn-primary">Find Jobs</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Job Title</th>
                                                <th>Company</th>
                                                <th>Applied Date</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${applications}" var="application">
                                                <tr class="application-row ${application.status}">
                                                    <td>
                                                        <a href="<c:url value='/jobs/view/${application.jobId}'/>">
                                                            ${application.getAttribute("job").title}
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <a href="<c:url value='/profile/view/${application.getAttribute("job").companyId}'/>" class="company-name">
                                                            ${application.getAttribute("company").companyName}
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${application.appliedAt}" pattern="MMM dd, yyyy" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${application.status eq 'PENDING'}">
                                                                <span class="badge badge-warning">Pending</span>
                                                            </c:when>
                                                            <c:when test="${application.status eq 'ACCEPTED'}">
                                                                <span class="badge badge-success">Accepted</span>
                                                            </c:when>
                                                            <c:when test="${application.status eq 'REJECTED'}">
                                                                <span class="badge badge-danger">Rejected</span>
                                                            </c:when>
                                                            <c:when test="${application.status eq 'WITHDRAWN'}">
                                                                <span class="badge badge-secondary">Withdrawn</span>
                                                            </c:when>
                                                            <c:when test="${application.status eq 'COMPLETED'}">
                                                                <span class="badge badge-info">Completed</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="actions">
                                                        <a href="<c:url value='/applications/view/${application.id}'/>" class="btn btn-sm btn-secondary" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        
                                                        <c:if test="${application.status eq 'PENDING'}">
                                                            <a href="<c:url value='/applications/withdraw/${application.id}'/>" class="btn btn-sm btn-danger" title="Withdraw Application"
                                                               onclick="return confirm('Are you sure you want to withdraw this application? This action cannot be undone.')">
                                                                <i class="fas fa-undo"></i>
                                                            </a>
                                                        </c:if>
                                                        
                                                        <c:if test="${application.status eq 'ACCEPTED'}">
                                                            <a href="<c:url value='/messages/job-conversation/${application.getAttribute("job").companyId}-${application.jobId}'/>" 
                                                               class="btn btn-sm btn-secondary" title="Message Employer">
                                                                <i class="fas fa-comment"></i>
                                                            </a>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="dashboard-section">
                    <div class="section-header">
                        <h2>Recommended Jobs</h2>
                    </div>
                    
                    <div class="recommended-jobs">
                        <c:choose>
                            <c:when test="${empty recommendedJobs}">
                                <div class="empty-state">
                                    <i class="fas fa-search"></i>
                                    <h3>No recommended jobs</h3>
                                    <p>Update your profile with skills to get personalized recommendations</p>
                                    <a href="<c:url value='/profile/edit'/>" class="btn btn-primary">Update Profile</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="job-cards">
                                    <c:forEach items="${recommendedJobs}" var="job" begin="0" end="2">
                                        <div class="job-card">
                                            <div class="job-card-header">
                                                <h3><a href="<c:url value='/jobs/view/${job.id}'/>">${job.title}</a></h3>
                                                <span class="job-type">${job.location}</span>
                                            </div>
                                            <div class="job-card-body">
                                                <p class="job-description">${job.description.length() > 100 ? job.description.substring(0, 100).concat('...') : job.description}</p>
                                                <div class="job-tags">
                                                    <c:forEach items="${job.skills.split(',')}" var="skill" begin="0" end="3">
                                                        <span>${skill}</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="job-card-footer">
                                                <p class="job-budget">$${job.budget}</p>
                                                <a href="<c:url value='/jobs/view/${job.id}'/>" class="btn btn-small">View Details</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="view-more">
                                    <a href="<c:url value='/jobs'/>" class="btn btn-secondary">View All Jobs</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
    <script>
        // Application filtering functionality
        document.getElementById('applicationFilter').addEventListener('change', function() {
            const filter = this.value;
            const rows = document.querySelectorAll('.application-row');
            
            rows.forEach(row => {
                if (filter === 'all') {
                    row.style.display = '';
                } else {
                    row.style.display = row.classList.contains(filter.toUpperCase()) ? '' : 'none';
                }
            });
        });
    </script>
</body>
</html>
