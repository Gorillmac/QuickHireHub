<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Jobs - QuickHire</title>
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
            <!-- Sidebar (if logged in as freelancer) -->
            <c:if test="${not empty user && user.isFreelancer()}">
                <div class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
                    <div class="sidebar-sticky pt-3">
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/freelancer/dashboard">
                                    <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/jobs">
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
            </c:if>
            
            <!-- Main Content -->
            <main role="main" class="${not empty user && user.isFreelancer() ? 'col-md-9 ml-sm-auto col-lg-10' : 'col-md-12'} px-md-4 py-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Browse Jobs</h1>
                </div>
                
                <!-- Success/Error Alerts -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${success}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <!-- Search and Filters -->
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/jobs/search" method="get" class="mb-0">
                            <div class="form-row align-items-center">
                                <div class="col-md-6 my-1">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="query" name="query" placeholder="Search jobs by title, skills, or location..." value="${searchQuery}">
                                        <div class="input-group-append">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-search"></i> Search
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 my-1">
                                    <select class="form-control" id="type" name="type">
                                        <option value="">Job Type</option>
                                        <option value="FULL_TIME" ${param.type == 'FULL_TIME' ? 'selected' : ''}>Full Time</option>
                                        <option value="PART_TIME" ${param.type == 'PART_TIME' ? 'selected' : ''}>Part Time</option>
                                        <option value="CONTRACT" ${param.type == 'CONTRACT' ? 'selected' : ''}>Contract</option>
                                        <option value="FREELANCE" ${param.type == 'FREELANCE' ? 'selected' : ''}>Freelance</option>
                                    </select>
                                </div>
                                <div class="col-md-2 my-1">
                                    <select class="form-control" id="location" name="location">
                                        <option value="">Location</option>
                                        <option value="Remote" ${param.location == 'Remote' ? 'selected' : ''}>Remote</option>
                                        <option value="USA" ${param.location == 'USA' ? 'selected' : ''}>USA</option>
                                        <option value="Europe" ${param.location == 'Europe' ? 'selected' : ''}>Europe</option>
                                        <option value="Asia" ${param.location == 'Asia' ? 'selected' : ''}>Asia</option>
                                    </select>
                                </div>
                                <div class="col-md-2 my-1">
                                    <button type="submit" class="btn btn-outline-secondary btn-block">
                                        <i class="fas fa-filter"></i> Filter
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <c:choose>
                    <c:when test="${not empty job}">
                        <!-- Single Job View Mode -->
                        <div class="card shadow mb-4">
                            <div class="card-header bg-white py-3 d-flex justify-content-between">
                                <h3 class="m-0 font-weight-bold text-primary">${job.title}</h3>
                                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Jobs
                                </a>
                            </div>
                            <div class="card-body">
                                <div class="row mb-4">
                                    <div class="col-md-8">
                                        <h5>
                                            <i class="fas fa-building text-muted mr-2"></i> 
                                            ${job.companyName}
                                        </h5>
                                        <p class="mb-2">
                                            <i class="fas fa-map-marker-alt text-muted mr-2"></i> 
                                            ${job.location}
                                        </p>
                                        <p class="mb-2">
                                            <i class="fas fa-briefcase text-muted mr-2"></i> 
                                            ${job.type}
                                        </p>
                                        <p class="mb-2">
                                            <i class="fas fa-dollar-sign text-muted mr-2"></i> 
                                            ${job.formattedBudget}
                                        </p>
                                        <p class="mb-2">
                                            <i class="fas fa-calendar-alt text-muted mr-2"></i> 
                                            Posted: <fmt:formatDate value="${job.createdAt}" pattern="MMM dd, yyyy" />
                                        </p>
                                        <p class="mb-0">
                                            <i class="fas fa-clock text-muted mr-2"></i> 
                                            Deadline: <fmt:formatDate value="${job.deadline}" pattern="MMM dd, yyyy" />
                                            <c:if test="${job.isExpired()}">
                                                <span class="badge badge-danger ml-2">Expired</span>
                                            </c:if>
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <!-- Application Button -->
                                        <c:choose>
                                            <c:when test="${not empty user && user.isFreelancer() && !hasApplied && !job.isExpired() && job.isActive()}">
                                                <button type="button" class="btn btn-lg btn-success mb-3" data-toggle="modal" data-target="#applyModal">
                                                    <i class="fas fa-paper-plane"></i> Apply Now
                                                </button>
                                            </c:when>
                                            <c:when test="${hasApplied}">
                                                <button type="button" class="btn btn-lg btn-secondary mb-3" disabled>
                                                    <i class="fas fa-check"></i> Applied
                                                </button>
                                            </c:when>
                                            <c:when test="${not empty user && !user.isFreelancer()}">
                                                <!-- No button for non-freelancers -->
                                            </c:when>
                                            <c:when test="${job.isExpired() || !job.isActive()}">
                                                <button type="button" class="btn btn-lg btn-secondary mb-3" disabled>
                                                    Not Available
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/login" class="btn btn-lg btn-primary mb-3">
                                                    Login to Apply
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <!-- Stats -->
                                        <p class="mb-1"><i class="fas fa-eye text-muted"></i> ${job.views} views</p>
                                        <p class="mb-0"><i class="fas fa-users text-muted"></i> ${job.applicationCount} applications</p>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <!-- Job Description -->
                                <div class="mt-4">
                                    <h4>Job Description</h4>
                                    <p>${job.description}</p>
                                </div>
                                
                                <!-- Requirements -->
                                <div class="mt-4">
                                    <h4>Requirements</h4>
                                    <p>${job.requirements}</p>
                                </div>
                                
                                <!-- Skills -->
                                <div class="mt-4">
                                    <h4>Skills</h4>
                                    <div class="skills-container">
                                        <c:forEach items="${job.skills.split(',')}" var="skill">
                                            <span class="badge badge-primary px-3 py-2 mr-2 mb-2">${skill.trim()}</span>
                                        </c:forEach>
                                    </div>
                                </div>
                                
                                <div class="text-center mt-5">
                                    <c:choose>
                                        <c:when test="${not empty user && user.isFreelancer() && !hasApplied && !job.isExpired() && job.isActive()}">
                                            <button type="button" class="btn btn-lg btn-success" data-toggle="modal" data-target="#applyModal">
                                                <i class="fas fa-paper-plane"></i> Apply Now
                                            </button>
                                        </c:when>
                                        <c:when test="${hasApplied}">
                                            <button type="button" class="btn btn-lg btn-secondary" disabled>
                                                <i class="fas fa-check"></i> You've Already Applied
                                            </button>
                                        </c:when>
                                        <c:when test="${not empty user && !user.isFreelancer()}">
                                            <!-- No button for non-freelancers -->
                                        </c:when>
                                        <c:when test="${job.isExpired() || !job.isActive()}">
                                            <button type="button" class="btn btn-lg btn-secondary" disabled>
                                                This Job is No Longer Available
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-lg btn-primary">
                                                Login to Apply
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Apply Modal -->
                        <div class="modal fade" id="applyModal" tabindex="-1" aria-labelledby="applyModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="applyModalLabel">Apply for: ${job.title}</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/applications/submit/${job.id}" method="post">
                                        <div class="modal-body">
                                            <div class="form-group">
                                                <label for="coverLetter">Cover Letter <span class="text-danger">*</span></label>
                                                <textarea class="form-control" id="coverLetter" name="coverLetter" rows="10" required
                                                          placeholder="Introduce yourself and explain why you're the right person for this job. Highlight relevant skills and experience."></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-success">Submit Application</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- Jobs List View Mode -->
                        <div class="card shadow mb-4">
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty jobs}">
                                        <div class="job-listings">
                                            <div class="row">
                                                <c:forEach items="${jobs}" var="job">
                                                    <div class="col-md-6 mb-4">
                                                        <div class="card h-100 job-card">
                                                            <div class="card-body">
                                                                <h5 class="card-title">
                                                                    <a href="${pageContext.request.contextPath}/jobs/view/${job.id}" class="text-primary">${job.title}</a>
                                                                </h5>
                                                                <h6 class="card-subtitle mb-2 text-muted">${job.companyName}</h6>
                                                                
                                                                <div class="job-meta mb-3">
                                                                    <span class="badge badge-light"><i class="fas fa-map-marker-alt"></i> ${job.location}</span>
                                                                    <span class="badge badge-light"><i class="fas fa-briefcase"></i> ${job.type}</span>
                                                                    <span class="badge badge-light"><i class="fas fa-dollar-sign"></i> ${job.formattedBudget}</span>
                                                                </div>
                                                                
                                                                <p class="card-text">${job.description.substring(0, Math.min(150, job.description.length()))}...</p>
                                                                
                                                                <div class="skills-container mb-3">
                                                                    <c:forEach items="${job.skills.split(',')}" var="skill" begin="0" end="2">
                                                                        <span class="badge badge-primary mr-1">${skill.trim()}</span>
                                                                    </c:forEach>
                                                                    <c:if test="${job.skills.split(',').length > 3}">
                                                                        <span class="badge badge-secondary">+${job.skills.split(',').length - 3} more</span>
                                                                    </c:if>
                                                                </div>
                                                                
                                                                <div class="job-footer">
                                                                    <div class="d-flex justify-content-between align-items-center">
                                                                        <small class="text-muted">
                                                                            <i class="fas fa-clock"></i> 
                                                                            <fmt:formatDate value="${job.createdAt}" pattern="MMM dd, yyyy" />
                                                                        </small>
                                                                        <a href="${pageContext.request.contextPath}/jobs/view/${job.id}" class="btn btn-sm btn-outline-primary">
                                                                            View Details
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <img src="https://pixabay.com/get/g2194254feb43ea0ee82f005b5ff2eb653a145af0a7ceba3c6d873b66e988583cd90ea96594aacd2253d2382332ee370967e72a39057377c2ee5c8732378d768a_1280.jpg" 
                                                 alt="No jobs found" class="img-fluid mb-3" style="max-height: 200px;">
                                            <h4>No jobs found</h4>
                                            <p class="text-muted">
                                                <c:choose>
                                                    <c:when test="${not empty searchQuery}">
                                                        No jobs match your search criteria.
                                                        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-sm btn-outline-primary mt-2">View All Jobs</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        There are no active job listings at the moment. Please check back later.
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
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
