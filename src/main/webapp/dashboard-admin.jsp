<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="dashboard-header">
            <div class="container">
                <h1>Admin Dashboard</h1>
                <p>Manage platform, users, and content</p>
                
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
                    <a href="<c:url value='/admin/users'/>" class="btn btn-primary"><i class="fas fa-users"></i> Manage Users</a>
                    <a href="<c:url value='/admin/reports'/>" class="btn btn-secondary"><i class="fas fa-flag"></i> 
                        Manage Reports
                        <c:if test="${not empty pendingReports && pendingReports.size() > 0}">
                            <span class="badge">${pendingReports.size()}</span>
                        </c:if>
                    </a>
                </div>
            </div>
        </section>
        
        <section class="dashboard-content">
            <div class="container">
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${userCount}</h3>
                            <p>Total Users</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-user-tie"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${freelancerCount}</h3>
                            <p>Freelancers</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${companyCount}</h3>
                            <p>Companies</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${jobCount}</h3>
                            <p>Total Jobs</p>
                        </div>
                    </div>
                </div>
                
                <div class="dashboard-section">
                    <div class="section-header">
                        <h2>Jobs Pending Approval</h2>
                    </div>
                    
                    <div class="pending-jobs">
                        <c:choose>
                            <c:when test="${empty unapprovedJobs}">
                                <div class="empty-state">
                                    <i class="fas fa-check-circle"></i>
                                    <h3>No jobs pending approval</h3>
                                    <p>All jobs have been reviewed</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Job Title</th>
                                                <th>Company</th>
                                                <th>Posted Date</th>
                                                <th>Budget</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${unapprovedJobs}" var="job">
                                                <tr>
                                                    <td>
                                                        <a href="<c:url value='/jobs/view/${job.id}'/>">${job.title}</a>
                                                    </td>
                                                    <td>${job.companyName}</td>
                                                    <td>
                                                        <fmt:formatDate value="${job.postedAt}" pattern="MMM dd, yyyy" />
                                                    </td>
                                                    <td>$${job.budget}</td>
                                                    <td class="actions">
                                                        <a href="<c:url value='/jobs/view/${job.id}'/>" class="btn btn-sm btn-secondary" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="<c:url value='/admin/jobs/approve/${job.id}'/>" class="btn btn-sm btn-success" title="Approve Job">
                                                            <i class="fas fa-check"></i>
                                                        </a>
                                                        <a href="<c:url value='/admin/jobs/reject/${job.id}'/>" class="btn btn-sm btn-danger" title="Reject Job"
                                                           onclick="return confirm('Are you sure you want to reject and delete this job? This action cannot be undone.')">
                                                            <i class="fas fa-times"></i>
                                                        </a>
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
                        <h2>Recent Reports</h2>
                        <div class="section-actions">
                            <a href="<c:url value='/admin/reports'/>" class="btn btn-sm btn-secondary">View All</a>
                        </div>
                    </div>
                    
                    <div class="recent-reports">
                        <c:choose>
                            <c:when test="${empty pendingReports}">
                                <div class="empty-state">
                                    <i class="fas fa-flag"></i>
                                    <h3>No pending reports</h3>
                                    <p>No abuse or scam reports to review</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Reporter</th>
                                                <th>Reported User</th>
                                                <th>Reason</th>
                                                <th>Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${pendingReports}" var="report" begin="0" end="4">
                                                <tr>
                                                    <td>${report.reporterId}</td>
                                                    <td>${report.reportedUserId}</td>
                                                    <td>${report.reason}</td>
                                                    <td>
                                                        <fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy" />
                                                    </td>
                                                    <td class="actions">
                                                        <a href="<c:url value='/admin/reports'/>" class="btn btn-sm btn-secondary">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
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
</body>
</html>
