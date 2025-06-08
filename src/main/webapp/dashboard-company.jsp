<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Dashboard | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="dashboard-header">
            <div class="container">
                <h1>Company Dashboard</h1>
                <p>Manage your job postings and applications</p>
                
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
                    <a href="<c:url value='/jobs/create'/>" class="btn btn-primary"><i class="fas fa-plus"></i> Post New Job</a>
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
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${jobs.size()}</h3>
                            <p>Total Jobs</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-info">
                            <c:set var="pendingJobsCount" value="0" />
                            <c:forEach items="${jobs}" var="job">
                                <c:if test="${!job.approved}">
                                    <c:set var="pendingJobsCount" value="${pendingJobsCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <h3>${pendingJobsCount}</h3>
                            <p>Pending Approval</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <c:set var="totalApplications" value="0" />
                            <c:forEach items="${jobs}" var="job" varStatus="loop">
                                <c:if test="${not empty job.applicationCount}">
                                    <c:set var="totalApplications" value="${totalApplications + job.applicationCount}" />
                                </c:if>
                            </c:forEach>
                            <h3>${totalApplications}</h3>
                            <p>Total Applications</p>
                        </div>
                    </div>
                </div>
                
                <div class="dashboard-section">
                    <div class="section-header">
                        <h2>Your Job Postings</h2>
                        <div class="section-actions">
                            <select id="jobFilter" class="form-select">
                                <option value="all">All Jobs</option>
                                <option value="open">Open Jobs</option>
                                <option value="closed">Closed Jobs</option>
                                <option value="pending">Pending Approval</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="job-list">
                        <c:choose>
                            <c:when test="${empty jobs}">
                                <div class="empty-state">
                                    <i class="fas fa-briefcase"></i>
                                    <h3>No jobs posted yet</h3>
                                    <p>Start by posting your first job to find talented freelancers</p>
                                    <a href="<c:url value='/jobs/create'/>" class="btn btn-primary">Post a Job</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Title</th>
                                                <th>Posted Date</th>
                                                <th>Status</th>
                                                <th>Applications</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${jobs}" var="job">
                                                <tr class="job-row ${job.approved ? 'approved' : 'pending'} ${job.status}">
                                                    <td>
                                                        <a href="<c:url value='/jobs/view/${job.id}'/>">${job.title}</a>
                                                        <c:if test="${!job.approved}">
                                                            <span class="badge badge-warning">Pending Approval</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${job.postedAt}" pattern="MMM dd, yyyy" />
                                                    </td>
                                                    <td>
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
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty job.applicationCount}">
                                                            <span class="application-count">${job.applicationCount}</span>
                                                        </c:if>
                                                        <c:if test="${empty job.applicationCount}">
                                                            <span class="application-count">0</span>
                                                        </c:if>
                                                    </td>
                                                    <td class="actions">
                                                        <a href="<c:url value='/jobs/view/${job.id}'/>" class="btn btn-sm btn-secondary" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <c:if test="${job.status eq 'OPEN' && job.approved}">
                                                            <a href="<c:url value='/jobs/edit/${job.id}'/>" class="btn btn-sm btn-secondary" title="Edit Job">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="<c:url value='/jobs/close/${job.id}'/>" class="btn btn-sm btn-danger" title="Close Job" 
                                                               onclick="return confirm('Are you sure you want to close this job? This action cannot be undone.')">
                                                                <i class="fas fa-times-circle"></i>
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
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
    <script>
        // Job filtering functionality
        document.getElementById('jobFilter').addEventListener('change', function() {
            const filter = this.value;
            const rows = document.querySelectorAll('.job-row');
            
            rows.forEach(row => {
                if (filter === 'all') {
                    row.style.display = '';
                } else if (filter === 'open') {
                    row.style.display = row.classList.contains('OPEN') ? '' : 'none';
                } else if (filter === 'closed') {
                    row.style.display = (row.classList.contains('CLOSED') || row.classList.contains('COMPLETED')) ? '' : 'none';
                } else if (filter === 'pending') {
                    row.style.display = row.classList.contains('pending') ? '' : 'none';
                }
            });
        });
    </script>
</body>
</html>
