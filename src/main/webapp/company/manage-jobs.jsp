<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Jobs - QuickHire</title>
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/dashboard">
                                <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/jobs/create">
                                <i class="fas fa-plus-circle mr-2"></i> Post New Job
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/company/jobs/manage">
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
                    <h1 class="h2">Manage Jobs</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/company/jobs/create" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Post New Job
                        </a>
                    </div>
                </div>
                
                <!-- Success Alert -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${param.success}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <!-- Job List -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">Your Job Listings</h6>
                        
                        <!-- Filter -->
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="filterDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-filter"></i> Filter
                            </button>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="filterDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/jobs/manage">All Jobs</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/jobs/manage?status=PUBLISHED">Active Jobs</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/jobs/manage?status=CLOSED">Closed Jobs</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/jobs/manage?status=FILLED">Filled Jobs</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/jobs/manage?status=DRAFT">Draft Jobs</a>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty jobs}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Title</th>
                                                <th>Status</th>
                                                <th>Applications</th>
                                                <th>Views</th>
                                                <th>Deadline</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${jobs}" var="job">
                                                <tr>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/jobs/view/${job.id}" class="text-primary font-weight-bold">${job.title}</a>
                                                        <div class="small text-muted">${job.type}</div>
                                                    </td>
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
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/company/applications/${job.id}">
                                                            ${job.applicationCount} <i class="fas fa-users text-muted"></i>
                                                        </a>
                                                    </td>
                                                    <td>${job.views}</td>
                                                    <td>
                                                        <fmt:formatDate value="${job.deadline}" pattern="MMM dd, yyyy" />
                                                        <c:if test="${job.isExpired()}">
                                                            <span class="badge badge-warning">Expired</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <a href="${pageContext.request.contextPath}/company/jobs/edit/${job.id}" class="btn btn-outline-primary">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/company/applications/${job.id}" class="btn btn-outline-info">
                                                                <i class="fas fa-users"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-outline-danger" data-toggle="modal" data-target="#deleteModal${job.id}">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                        
                                                        <!-- Delete Modal -->
                                                        <div class="modal fade" id="deleteModal${job.id}" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel${job.id}" aria-hidden="true">
                                                            <div class="modal-dialog" role="document">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="deleteModalLabel${job.id}">Confirm Delete</h5>
                                                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                            <span aria-hidden="true">&times;</span>
                                                                        </button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        Are you sure you want to delete the job listing: <strong>${job.title}</strong>?
                                                                        <p class="text-danger mt-2 mb-0">This action cannot be undone.</p>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                                                        <a href="${pageContext.request.contextPath}/company/jobs/delete/${job.id}" class="btn btn-danger">Delete</a>
                                                                    </div>
                                                                </div>
                                                            </div>
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
                                    <img src="https://pixabay.com/get/gfb1cf69b7f4349de3d5cc7092c08b94fc319fd42c21da4889e13916e68e1ea9c87419fdd1e881b91465838ae28eb1665b55661524f041d0e258e6f5351d24c88_1280.jpg" 
                                         alt="No jobs found" class="img-fluid mb-3" style="max-height: 200px;">
                                    <h4>No job listings found</h4>
                                    <p class="text-muted">You haven't posted any jobs yet.</p>
                                    <a href="${pageContext.request.contextPath}/company/jobs/create" class="btn btn-primary mt-2">
                                        <i class="fas fa-plus-circle"></i> Post Your First Job
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Job Stats Card -->
                <c:if test="${not empty jobs}">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Job Statistics</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <c:set var="totalJobs" value="${jobs.size()}" />
                                <c:set var="activeJobs" value="0" />
                                <c:set var="closedJobs" value="0" />
                                <c:set var="filledJobs" value="0" />
                                <c:set var="draftJobs" value="0" />
                                <c:set var="totalApplications" value="0" />
                                <c:set var="totalViews" value="0" />
                                
                                <c:forEach items="${jobs}" var="job">
                                    <c:if test="${job.status == 'PUBLISHED'}"><c:set var="activeJobs" value="${activeJobs + 1}" /></c:if>
                                    <c:if test="${job.status == 'CLOSED'}"><c:set var="closedJobs" value="${closedJobs + 1}" /></c:if>
                                    <c:if test="${job.status == 'FILLED'}"><c:set var="filledJobs" value="${filledJobs + 1}" /></c:if>
                                    <c:if test="${job.status == 'DRAFT'}"><c:set var="draftJobs" value="${draftJobs + 1}" /></c:if>
                                    <c:set var="totalApplications" value="${totalApplications + job.applicationCount}" />
                                    <c:set var="totalViews" value="${totalViews + job.views}" />
                                </c:forEach>
                                
                                <div class="col-md-3 col-sm-6 mb-4">
                                    <div class="card border-left-primary h-100 py-2">
                                        <div class="card-body">
                                            <div class="row no-gutters align-items-center">
                                                <div class="col mr-2">
                                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Jobs</div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${totalJobs}</div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="fas fa-briefcase fa-2x text-gray-300"></i>
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
                                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Active Jobs</div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${activeJobs}</div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="fas fa-check-circle fa-2x text-gray-300"></i>
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
                                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Total Applications</div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${totalApplications}</div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="fas fa-users fa-2x text-gray-300"></i>
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
                                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Total Views</div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${totalViews}</div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="fas fa-eye fa-2x text-gray-300"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
