<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Dashboard - QuickHire</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/company/dashboard">
                                <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/jobs/create">
                                <i class="fas fa-plus-circle mr-2"></i> Post New Job
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/jobs/manage">
                                <i class="fas fa-briefcase mr-2"></i> Manage Jobs
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
                    <h1 class="h2">Company Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/company/jobs/create" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Post New Job
                        </a>
                    </div>
                </div>
                
                <!-- Welcome Banner -->
                <div class="alert alert-info" role="alert">
                    <h4 class="alert-heading">Welcome, ${user.companyName}!</h4>
                    <p>From your dashboard, you can post new jobs, manage existing ones, and communicate with freelancers.</p>
                </div>
                
                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card bg-primary text-white h-100">
                            <div class="card-body py-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase">Active Jobs</h6>
                                        <h2>
                                            <c:set var="activeCount" value="0" />
                                            <c:forEach items="${jobs}" var="job">
                                                <c:if test="${job.status == 'PUBLISHED'}">
                                                    <c:set var="activeCount" value="${activeCount + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${activeCount}
                                        </h2>
                                    </div>
                                    <div>
                                        <i class="fas fa-briefcase fa-3x opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex">
                                <a href="${pageContext.request.contextPath}/company/jobs/manage" class="text-white">
                                    View Jobs <i class="fas fa-arrow-circle-right ml-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white h-100">
                            <div class="card-body py-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase">Total Applications</h6>
                                        <h2>
                                            <c:set var="totalApplications" value="0" />
                                            <c:forEach items="${jobs}" var="job">
                                                <c:set var="totalApplications" value="${totalApplications + job.applicationCount}" />
                                            </c:forEach>
                                            ${totalApplications}
                                        </h2>
                                    </div>
                                    <div>
                                        <i class="fas fa-file-alt fa-3x opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex">
                                <a href="${pageContext.request.contextPath}/company/jobs/manage" class="text-white">
                                    View Applications <i class="fas fa-arrow-circle-right ml-1"></i>
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
                
                <!-- Recent Jobs -->
                <div class="card shadow mb-4">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0">Recently Posted Jobs</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentJobs}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>Title</th>
                                                <th>Status</th>
                                                <th>Applications</th>
                                                <th>Date Posted</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${recentJobs}" var="job">
                                                <tr>
                                                    <td>${job.title}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${job.status == 'PUBLISHED'}">
                                                                <span class="badge badge-success">Active</span>
                                                            </c:when>
                                                            <c:when test="${job.status == 'DRAFT'}">
                                                                <span class="badge badge-secondary">Draft</span>
                                                            </c:when>
                                                            <c:when test="${job.status == 'CLOSED'}">
                                                                <span class="badge badge-danger">Closed</span>
                                                            </c:when>
                                                            <c:when test="${job.status == 'FILLED'}">
                                                                <span class="badge badge-info">Filled</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>${job.applicationCount}</td>
                                                    <td>${job.createdAt}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/company/applications/${job.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-users"></i> Applications
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
                                    <img src="https://pixabay.com/get/g65cf616414b1c7bf08aeec233504d01f9eb61777b214b71932bf81d876bd3f064ed547a5504a92cd7f7ef342f29b2c5798d4f24bfa5fc5f723bd53c75146d457_1280.jpg" 
                                         alt="No jobs yet" class="img-fluid mb-3" style="max-height: 200px;">
                                    <h5>You haven't posted any jobs yet</h5>
                                    <p class="text-muted">Get started by posting your first job listing</p>
                                    <a href="${pageContext.request.contextPath}/company/jobs/create" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Post a New Job
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-footer bg-white">
                        <a href="${pageContext.request.contextPath}/company/jobs/manage" class="text-primary">View all jobs <i class="fas fa-arrow-right ml-1"></i></a>
                    </div>
                </div>
                
                <!-- Complete Your Profile -->
                <c:if test="${empty user.bio || empty user.location || empty user.phone || empty user.website}">
                    <div class="card shadow mb-4">
                        <div class="card-header bg-warning py-3">
                            <h5 class="mb-0 text-dark">Complete Your Company Profile</h5>
                        </div>
                        <div class="card-body">
                            <p>Companies with complete profiles attract more freelancers. Add more details to increase your chances of finding the right talent.</p>
                            <ul class="list-unstyled">
                                <c:if test="${empty user.bio}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Company Description</li>
                                </c:if>
                                <c:if test="${empty user.location}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Location</li>
                                </c:if>
                                <c:if test="${empty user.phone}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Contact Phone</li>
                                </c:if>
                                <c:if test="${empty user.website}">
                                    <li><i class="fas fa-times-circle text-danger mr-2"></i> Company Website</li>
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
