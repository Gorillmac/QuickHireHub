<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Freelancer Dashboard - QuickHire</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/freelancer/dashboard">
                                <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/jobs">
                                <i class="fas fa-search mr-2"></i> Browse Jobs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/freelancer/applications">
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
                    <h1 class="h2">Freelancer Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">
                            <i class="fas fa-search"></i> Find Jobs
                        </a>
                    </div>
                </div>
                
                <!-- Welcome Banner -->
                <div class="alert alert-info" role="alert">
                    <h4 class="alert-heading">Welcome, ${user.firstName}!</h4>
                    <p>From your dashboard, you can browse available jobs, manage your applications, and communicate with potential employers.</p>
                </div>
                
                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white h-100">
                            <div class="card-body py-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase">Active Applications</h6>
                                        <h2>
                                            <c:set var="activeCount" value="0" />
                                            <c:forEach items="${applications}" var="application">
                                                <c:if test="${application.status == 'PENDING' || application.status == 'UNDER_REVIEW'}">
                                                    <c:set var="activeCount" value="${activeCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${activeCount}
                                        </h2>
                                    </div>
                                    <div>
                                        <i class="fas fa-file-alt fa-3x opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex">
                                <a href="${pageContext.request.contextPath}/freelancer/applications" class="text-white">
                                    View Applications <i class="fas fa-arrow-circle-right ml-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white h-100">
                            <div class="card-body py-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase">Accepted Jobs</h6>
                                        <h2>
                                            <c:set var="acceptedCount" value="0" />
                                            <c:forEach items="${applications}" var="application">
                                                <c:if test="${application.status == 'ACCEPTED'}">
                                                    <c:set var="acceptedCount" value="${acceptedCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${acceptedCount}
                                        </h2>
                                    </div>
                                    <div>
                                        <i class="fas fa-check-circle fa-3x opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex">
                                <a href="${pageContext.request.contextPath}/freelancer/applications?status=ACCEPTED" class="text-white">
                                    View Accepted Jobs <i class="fas fa-arrow-circle-right ml-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-info text-white h-100">
                            <div class="card-body py-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase">Unread Messages</h6>
                                        <h2>${unreadMessages}</h2>
                                    </div>
                                    <div>
                                        <i class="fas fa-envelope fa-3x opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex">
                                <a href="${pageContext.request.contextPath}/messaging/inbox" class="text-white">
                                    View Messages <i class="fas fa-arrow-circle-right ml-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Applications -->
                <div class="card shadow mb-4">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0">Recent Applications</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentApplications}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>Job Title</th>
                                                <th>Company</th>
                                                <th>Applied On</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${recentApplications}" var="application">
                                                <tr>
                                                    <td>${application.jobTitle}</td>
                                                    <td>${application.companyName}</td>
                                                    <td>${application.createdAt}</td>
                                                    <td>
                                                        <span class="badge ${application.getStatusStyle()}">${application.status}</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/applications/view/${application.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <img src="https://pixabay.com/get/g3ed11d93db16a95f3e6c7876026170f6d61fba13d2255f318778f23eeb351af7c018f61138c360fa01a7c191de95c4f8d1f7bbb966a82b64a1e95ceb94ef408b_1280.jpg" 
                                         alt="No applications yet" class="img-fluid mb-3" style="max-height: 200px;">
                                    <h5>You haven't applied to any jobs yet</h5>
                                    <p class="text-muted">Start browsing available jobs and submit your applications</p>
                                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Browse Jobs
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-footer bg-white">
                        <a href="${pageContext.request.contextPath}/freelancer/applications" class="text-primary">View all applications <i class="fas fa-arrow-right ml-1"></i></a>
                    </div>
                </div>
                
                <!-- Job Recommendations -->
                <div class="card shadow mb-4">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0">Recommended Jobs</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recommendedJobs}">
                                <div class="row">
                                    <c:forEach items="${recommendedJobs}" var="job">
                                        <div class="col-md-6 mb-4">
                                            <div class="card h-100 border-left-primary">
                                                <div class="card-body">
                                                    <h5 class="card-title">${job.title}</h5>
                                                    <h6 class="card-subtitle mb-2 text-muted">${job.companyName}</h6>
                                                    <p class="card-text">
                                                        <span class="badge badge-light"><i class="fas fa-map-marker-alt"></i> ${job.location}</span>
                                                        <span class="badge badge-light"><i class="fas fa-clock"></i> ${job.type}</span>
                                                        <span class="badge badge-light"><i class="fas fa-dollar-sign"></i> ${job.budget}</span>
                                                    </p>
                                                    <p class="card-text">${job.description.substring(0, Math.min(100, job.description.length()))}...</p>
                                                    <a href="${pageContext.request.contextPath}/jobs/view/${job.id}" class="btn btn-sm btn-outline-primary">View Details</a>
                                                </div>
                                                <div class="card-footer bg-transparent">
                                                    <small class="text-muted">Posted: ${job.createdAt}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <p>No job recommendations available. Complete your profile to get personalized job recommendations.</p>
                                    <a href="${pageContext.request.contextPath}/profile/edit" class="btn btn-outline-primary">Update Profile</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-footer bg-white">
                        <a href="${pageContext.request.contextPath}/jobs" class="text-primary">Browse all jobs <i class="fas fa-arrow-right ml-1"></i></a>
                    </div>
                </div>
                
                <!-- Complete Your Profile -->
                <c:if test="${empty user.bio || empty user.title || empty user.skills || empty user.location}">
                    <div class="card shadow mb-4">
                        <div class="card-header bg-warning py-3">
                            <h5 class="mb-0 text-dark">Complete Your Profile</h5>
                        </div>
                        <div class="card-body">
                            <p>Complete your profile to increase your chances of getting hired. Companies look for detailed profiles when hiring freelancers.</p>
                            <ul class="list-unstyled">
                                <c:if test="${empty user.title}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Professional Title</li>
                                </c:if>
                                <c:if test="${empty user.skills}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Skills</li>
                                </c:if>
                                <c:if test="${empty user.bio}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Professional Bio</li>
                                </c:if>
                                <c:if test="${empty user.location}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Location</li>
                                </c:if>
                            </ul>
                            <a href="${pageContext.request.contextPath}/profile/edit" class="btn btn-warning">Complete Profile</a>
                        </div>
                    </div>
                </c:if>
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
