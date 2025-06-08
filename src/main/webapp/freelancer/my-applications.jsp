<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - QuickHire</title>
    <!-- Include CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- Include navigation -->
    <jsp:include page="/include/navigation.jsp" />
    
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
                <div class="sidebar-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/freelancer/dashboard">
                                <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/jobs">
                                <i class="fas fa-search mr-2"></i> Browse Jobs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/freelancer/applications">
                                <i class="fas fa-file-alt mr-2"></i> My Applications
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/messaging/inbox">
                                <i class="fas fa-envelope mr-2"></i> Messages
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/profile/edit">
                                <i class="fas fa-user-cog mr-2"></i> Profile Settings
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <!-- Main Content -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4 py-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">My Applications</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">
                            <i class="fas fa-search"></i> Find More Jobs
                        </a>
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${not empty application}">
                        <!-- Single Application View Mode -->
                        <div class="card shadow mb-4">
                            <div class="card-header bg-white py-3 d-flex justify-content-between">
                                <h3 class="m-0 font-weight-bold text-primary">${application.jobTitle}</h3>
                                <a href="${pageContext.request.contextPath}/freelancer/applications" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Applications
                                </a>
                            </div>
                            <div class="card-body">
                                <div class="row mb-4">
                                    <div class="col-md-8">
                                        <h5>
                                            <i class="fas fa-building text-muted mr-2"></i> 
                                            ${application.companyName}
                                        </h5>
                                        <p class="mb-2">
                                            <i class="fas fa-calendar-alt text-muted mr-2"></i> 
                                            Applied on: <fmt:formatDate value="${application.createdAt}" pattern="MMMM dd, yyyy" />
                                        </p>
                                        <p class="mb-0">
                                            <i class="fas fa-info-circle text-muted mr-2"></i> 
                                            Status: <span class="badge ${application.getStatusStyle()}">${application.status}</span>
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <a href="${pageContext.request.contextPath}/jobs/view/${application.jobId}" class="btn btn-outline-primary mb-2">
                                            <i class="fas fa-eye"></i> View Job Listing
                                        </a>
                                        <a href="${pageContext.request.contextPath}/messaging/conversation/${job.companyId}" class="btn btn-outline-info">
                                            <i class="fas fa-envelope"></i> Message Employer
                                        </a>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <!-- Cover Letter -->
                                <div class="mt-4">
                                    <h4>Your Cover Letter</h4>
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <p>${application.coverLetter}</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Status Timeline -->
                                <div class="mt-5">
                                    <h4>Application Status</h4>
                                    <div class="position-relative mt-4">
                                        <div class="progress" style="height: 4px;">
                                            <div class="progress-bar" role="progressbar" style="width: 
                                                <c:choose>
                                                    <c:when test="${application.status == 'PENDING'}">25%</c:when>
                                                    <c:when test="${application.status == 'UNDER_REVIEW'}">50%</c:when>
                                                    <c:when test="${application.status == 'ACCEPTED'}">100%</c:when>
                                                    <c:when test="${application.status == 'REJECTED'}">100%</c:when>
                                                    <c:otherwise>0%</c:otherwise>
                                                </c:choose>
                                            " aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                        <div class="position-absolute" style="top: -10px; left: 0;">
                                            <div class="rounded-circle bg-${application.status == 'PENDING' || application.status == 'UNDER_REVIEW' || application.status == 'ACCEPTED' ? 'primary' : 'secondary'}" style="width: 20px; height: 20px;"></div>
                                            <div class="mt-2">Submitted</div>
                                        </div>
                                        <div class="position-absolute" style="top: -10px; left: 33%;">
                                            <div class="rounded-circle bg-${application.status == 'UNDER_REVIEW' || application.status == 'ACCEPTED' ? 'primary' : 'secondary'}" style="width: 20px; height: 20px;"></div>
                                            <div class="mt-2">Under Review</div>
                                        </div>
                                        <div class="position-absolute" style="top: -10px; left: 66%;">
                                            <div class="rounded-circle bg-${application.status == 'ACCEPTED' ? 'success' : application.status == 'REJECTED' ? 'danger' : 'secondary'}" style="width: 20px; height: 20px;"></div>
                                            <div class="mt-2">Decision</div>
                                        </div>
                                        <div class="position-absolute" style="top: -10px; right: 0;">
                                            <div class="rounded-circle bg-${application.status == 'ACCEPTED' ? 'success' : 'secondary'}" style="width: 20px; height: 20px;"></div>
                                            <div class="mt-2">Hired</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Status Messages -->
                                <div class="mt-5">
                                    <div class="alert 
                                        <c:choose>
                                            <c:when test="${application.status == 'PENDING'}">alert-warning</c:when>
                                            <c:when test="${application.status == 'UNDER_REVIEW'}">alert-info</c:when>
                                            <c:when test="${application.status == 'ACCEPTED'}">alert-success</c:when>
                                            <c:when test="${application.status == 'REJECTED'}">alert-danger</c:when>
                                        </c:choose>
                                    ">
                                        <c:choose>
                                            <c:when test="${application.status == 'PENDING'}">
                                                <h5><i class="fas fa-clock"></i> Application Pending</h5>
                                                <p class="mb-0">Your application has been submitted and is waiting to be reviewed by the employer.</p>
                                            </c:when>
                                            <c:when test="${application.status == 'UNDER_REVIEW'}">
                                                <h5><i class="fas fa-search"></i> Application Under Review</h5>
                                                <p class="mb-0">The employer is currently reviewing your application. Check back later for updates.</p>
                                            </c:when>
                                            <c:when test="${application.status == 'ACCEPTED'}">
                                                <h5><i class="fas fa-check-circle"></i> Application Accepted</h5>
                                                <p class="mb-0">Congratulations! Your application has been accepted. The employer may contact you soon.</p>
                                            </c:when>
                                            <c:when test="${application.status == 'REJECTED'}">
                                                <h5><i class="fas fa-times-circle"></i> Application Not Selected</h5>
                                                <p class="mb-0">We're sorry, but the employer has decided to pursue other candidates for this position.</p>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- Applications List View Mode -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold text-primary">All Applications</h6>
                                
                                <!-- Filter -->
                                <div class="dropdown">
                                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="filterDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fas fa-filter"></i> Filter by Status
                                    </button>
                                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="filterDropdown">
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/freelancer/applications">All Applications</a>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/freelancer/applications?status=PENDING">Pending</a>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/freelancer/applications?status=UNDER_REVIEW">Under Review</a>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/freelancer/applications?status=ACCEPTED">Accepted</a>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/freelancer/applications?status=REJECTED">Rejected</a>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty applications}">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead class="thead-light">
                                                    <tr>
                                                        <th>Job Title</th>
                                                        <th>Company</th>
                                                        <th>Applied On</th>
                                                        <th>Status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${applications}" var="application">
                                                        <tr>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/applications/view/${application.id}" class="text-primary">
                                                                    ${application.jobTitle}
                                                                </a>
                                                            </td>
                                                            <td>${application.companyName}</td>
                                                            <td><fmt:formatDate value="${application.createdAt}" pattern="MMM dd, yyyy" /></td>
                                                            <td>
                                                                <span class="badge ${application.getStatusStyle()}">${application.status}</span>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group btn-group-sm">
                                                                    <a href="${pageContext.request.contextPath}/applications/view/${application.id}" class="btn btn-outline-primary">
                                                                        <i class="fas fa-eye"></i> View
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/jobs/view/${application.jobId}" class="btn btn-outline-info">
                                                                        <i class="fas fa-briefcase"></i> Job
                                                                    </a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <img src="https://pixabay.com/get/ga3606a2be41b2f2c5bb397fb3038b0f8eae619a7e8cd254bae9a65b6c26d39eaa82799c6906ff3942b1ada26996c6cfc42326e833c7d262f9c00b9030446f56b_1280.jpg" 
                                                 alt="No applications" class="img-fluid mb-3" style="max-height: 200px;">
                                            <h4>No applications found</h4>
                                            <p class="text-muted">You haven't applied to any jobs yet.</p>
                                            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary mt-2">
                                                <i class="fas fa-search"></i> Browse Jobs
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <!-- Application Statistics -->
                        <c:if test="${not empty applications}">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Application Statistics</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <c:set var="totalApplications" value="${applications.size()}" />
                                        <c:set var="pendingCount" value="0" />
                                        <c:set var="reviewCount" value="0" />
                                        <c:set var="acceptedCount" value="0" />
                                        <c:set var="rejectedCount" value="0" />
                                        
                                        <c:forEach items="${applications}" var="app">
                                            <c:if test="${app.status == 'PENDING'}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if>
                                            <c:if test="${app.status == 'UNDER_REVIEW'}"><c:set var="reviewCount" value="${reviewCount + 1}" /></c:if>
                                            <c:if test="${app.status == 'ACCEPTED'}"><c:set var="acceptedCount" value="${acceptedCount + 1}" /></c:if>
                                            <c:if test="${app.status == 'REJECTED'}"><c:set var="rejectedCount" value="${rejectedCount + 1}" /></c:if>
                                        </c:forEach>
                                        
                                        <div class="col-md-3 col-sm-6 mb-4">
                                            <div class="card border-left-primary h-100 py-2">
                                                <div class="card-body">
                                                    <div class="row no-gutters align-items-center">
                                                        <div class="col mr-2">
                                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Applications</div>
                                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalApplications}</div>
                                                        </div>
                                                        <div class="col-auto">
                                                            <i class="fas fa-file-alt fa-2x text-gray-300"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-4">
                                            <div class="card border-left-warning h-100 py-2">
                                                <div class="card-body">
                                                    <div class="row no-gutters align-items-center">
                                                        <div class="col mr-2">
                                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Pending</div>
                                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${pendingCount}</div>
                                                        </div>
                                                        <div class="col-auto">
                                                            <i class="fas fa-clock fa-2x text-gray-300"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-4">
                                            <div class="card border-left-info h-100 py-2">
                                                <div class="card-body">
                                                    <div class="row no-gutters align-items-center">
                                                        <div class="col mr-2">
                                                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Under Review</div>
                                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${reviewCount}</div>
                                                        </div>
                                                        <div class="col-auto">
                                                            <i class="fas fa-search fa-2x text-gray-300"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3 col-sm-6 mb-4">
                                            <div class="card border-left-success h-100 py-2">
                                                <div class="card-body">
                                                    <div class="row no-gutters align-items-center">
                                                        <div class="col mr-2">
                                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Accepted</div>
                                                            <div class="h5 mb-0 font-weight-bold text-gray-800">${acceptedCount}</div>
                                                        </div>
                                                        <div class="col-auto">
                                                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Success Rate -->
                                    <div class="mt-4">
                                        <h6 class="text-muted">Application Success Rate</h6>
                                        <div class="progress" style="height: 25px;">
                                            <c:set var="successRate" value="${(acceptedCount / totalApplications) * 100}" />
                                            <div class="progress-bar bg-success" role="progressbar" style="width: ${successRate}%;" 
                                                 aria-valuenow="${successRate}" aria-valuemin="0" aria-valuemax="100">
                                                <c:if test="${successRate > 0}">
                                                    <fmt:formatNumber value="${successRate}" maxFractionDigits="1" />%
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>
    
    <!-- Include footer -->
    <jsp:include page="/include/footer.jsp" />
    
    <!-- Include JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
