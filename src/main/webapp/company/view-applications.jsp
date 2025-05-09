<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Applications - QuickHire</title>
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
                    <h1 class="h2">Applications for "${job.title}"</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/company/jobs/manage" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Jobs
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
                
                <!-- Job Details Card -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">Job Overview</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Status:</strong> 
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
                                </p>
                                <p><strong>Location:</strong> ${job.location}</p>
                                <p><strong>Type:</strong> ${job.type}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Total Views:</strong> ${job.views}</p>
                                <p><strong>Total Applications:</strong> ${applications.size()}</p>
                                <p><strong>Deadline:</strong> <fmt:formatDate value="${job.deadline}" pattern="MMM dd, yyyy" /></p>
                            </div>
                        </div>
                        <div class="mt-3 d-flex">
                            <a href="${pageContext.request.contextPath}/jobs/view/${job.id}" class="btn btn-outline-primary btn-sm mr-2">
                                <i class="fas fa-eye"></i> View Job Listing
                            </a>
                            <a href="${pageContext.request.contextPath}/company/jobs/edit/${job.id}" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-edit"></i> Edit Job
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Applications List -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">All Applications (${applications.size()})</h6>
                        
                        <!-- Filter -->
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle btn-sm" type="button" id="filterDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-filter"></i> Filter by Status
                            </button>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="filterDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/applications/${job.id}">All Applications</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/applications/${job.id}?status=PENDING">Pending</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/applications/${job.id}?status=UNDER_REVIEW">Under Review</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/applications/${job.id}?status=ACCEPTED">Accepted</a>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/company/applications/${job.id}?status=REJECTED">Rejected</a>
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
                                                <th>Applicant</th>
                                                <th>Applied On</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${applications}" var="application">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar mr-3">
                                                                <i class="fas fa-user-circle fa-2x text-muted"></i>
                                                            </div>
                                                            <div>
                                                                <h6 class="mb-0">${application.freelancerName}</h6>
                                                                <small class="text-muted">ID: ${application.freelancerId}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${application.createdAt}" pattern="MMM dd, yyyy" />
                                                    </td>
                                                    <td>
                                                        <span class="badge ${application.getStatusStyle()}">${application.status}</span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <button type="button" class="btn btn-outline-primary" data-toggle="modal" data-target="#applicationModal${application.id}">
                                                                <i class="fas fa-eye"></i> View
                                                            </button>
                                                            <a href="${pageContext.request.contextPath}/messaging/conversation/${application.freelancerId}" class="btn btn-outline-info">
                                                                <i class="fas fa-envelope"></i> Message
                                                            </a>
                                                        </div>
                                                        
                                                        <!-- Application Modal -->
                                                        <div class="modal fade" id="applicationModal${application.id}" tabindex="-1" role="dialog" aria-labelledby="applicationModalLabel${application.id}" aria-hidden="true">
                                                            <div class="modal-dialog modal-lg" role="document">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="applicationModalLabel${application.id}">Application Details</h5>
                                                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                            <span aria-hidden="true">&times;</span>
                                                                        </button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div class="card mb-3">
                                                                            <div class="card-header bg-light">
                                                                                <h6 class="mb-0">Applicant Information</h6>
                                                                            </div>
                                                                            <div class="card-body">
                                                                                <div class="row">
                                                                                    <div class="col-md-6">
                                                                                        <p><strong>Name:</strong> ${application.freelancerName}</p>
                                                                                        <p><strong>Applied On:</strong> <fmt:formatDate value="${application.createdAt}" pattern="MMM dd, yyyy HH:mm" /></p>
                                                                                        <p><strong>Status:</strong> <span class="badge ${application.getStatusStyle()}">${application.status}</span></p>
                                                                                    </div>
                                                                                    <div class="col-md-6">
                                                                                        <p>
                                                                                            <a href="${pageContext.request.contextPath}/freelancer/profile/${application.freelancerId}" class="btn btn-outline-primary btn-sm" target="_blank">
                                                                                                <i class="fas fa-user"></i> View Profile
                                                                                            </a>
                                                                                        </p>
                                                                                        <p>
                                                                                            <a href="${pageContext.request.contextPath}/messaging/conversation/${application.freelancerId}" class="btn btn-outline-info btn-sm">
                                                                                                <i class="fas fa-envelope"></i> Send Message
                                                                                            </a>
                                                                                        </p>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <div class="card mb-3">
                                                                            <div class="card-header bg-light">
                                                                                <h6 class="mb-0">Cover Letter</h6>
                                                                            </div>
                                                                            <div class="card-body">
                                                                                <p>${application.coverLetter}</p>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                        <div class="card">
                                                                            <div class="card-header bg-light">
                                                                                <h6 class="mb-0">Update Application Status</h6>
                                                                            </div>
                                                                            <div class="card-body">
                                                                                <form action="${pageContext.request.contextPath}/company/applications/update-status" method="post">
                                                                                    <input type="hidden" name="applicationId" value="${application.id}">
                                                                                    <input type="hidden" name="jobId" value="${job.id}">
                                                                                    
                                                                                    <div class="form-group">
                                                                                        <label for="status${application.id}">Set Status</label>
                                                                                        <select class="form-control" id="status${application.id}" name="status">
                                                                                            <option value="PENDING" ${application.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                                                                            <option value="UNDER_REVIEW" ${application.status == 'UNDER_REVIEW' ? 'selected' : ''}>Under Review</option>
                                                                                            <option value="ACCEPTED" ${application.status == 'ACCEPTED' ? 'selected' : ''}>Accepted</option>
                                                                                            <option value="REJECTED" ${application.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                                                                        </select>
                                                                                    </div>
                                                                                    
                                                                                    <button type="submit" class="btn btn-primary">Update Status</button>
                                                                                </form>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
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
                                    <img src="https://pixabay.com/get/g0c0e7da1fd7a7427f5da6b3b85f224e86d29c7bfe0c1125c0e436762413cac8ee6c686c15e623da25fc368b36ee9189fe2d53cefdf8fc048957f960e3919dfc3_1280.jpg" 
                                         alt="No applications" class="img-fluid mb-3" style="max-height: 200px;">
                                    <h4>No applications yet</h4>
                                    <p class="text-muted">No one has applied to this job yet.</p>
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
                                
                                <div class="col-md-3 col-sm-6 mb-4">
                                    <div class="card border-left-danger h-100 py-2">
                                        <div class="card-body">
                                            <div class="row no-gutters align-items-center">
                                                <div class="col mr-2">
                                                    <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Rejected</div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">${rejectedCount}</div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="fas fa-times-circle fa-2x text-gray-300"></i>
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
