<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty job ? 'Post New Job' : 'Edit Job'} - QuickHire</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/company/jobs/create">
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
                    <h1 class="h2">${empty job ? 'Post New Job' : 'Edit Job'}</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/company/jobs/manage" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Jobs
                        </a>
                    </div>
                </div>
                
                <!-- Error Alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <!-- Job Form -->
                <div class="card shadow mb-4">
                    <div class="card-body">
                        <form action="${empty job ? pageContext.request.contextPath.concat('/company/jobs/create') : pageContext.request.contextPath.concat('/company/jobs/edit/').concat(job.id)}" method="post">
                            <div class="form-group">
                                <label for="title">Job Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="title" name="title" value="${job.title}" required>
                                <small class="form-text text-muted">Enter a clear title that describes the job role</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="description">Job Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="description" name="description" rows="5" required>${job.description}</textarea>
                                <small class="form-text text-muted">Describe the job, responsibilities, and objectives</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="requirements">Requirements <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="requirements" name="requirements" rows="4" required>${job.requirements}</textarea>
                                <small class="form-text text-muted">List the qualifications, experience, and skills needed</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="skills">Skills <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="skills" name="skills" value="${job.skills}" required>
                                <small class="form-text text-muted">Enter key skills separated by commas (e.g., Java, HTML, CSS)</small>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="location">Location <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="location" name="location" value="${job.location}" required>
                                        <small class="form-text text-muted">Enter job location or 'Remote'</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="type">Job Type <span class="text-danger">*</span></label>
                                        <select class="form-control" id="type" name="type" required>
                                            <option value="">Select Job Type</option>
                                            <option value="FULL_TIME" ${job.type == 'FULL_TIME' ? 'selected' : ''}>Full Time</option>
                                            <option value="PART_TIME" ${job.type == 'PART_TIME' ? 'selected' : ''}>Part Time</option>
                                            <option value="CONTRACT" ${job.type == 'CONTRACT' ? 'selected' : ''}>Contract</option>
                                            <option value="FREELANCE" ${job.type == 'FREELANCE' ? 'selected' : ''}>Freelance</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="budget">Budget ($) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="budget" name="budget" value="${job.budget}" step="0.01" min="0" required>
                                        <small class="form-text text-muted">Enter the budget or salary for this job</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="deadline">Application Deadline <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="deadline" name="deadline" 
                                               value="<fmt:formatDate value="${job.deadline}" pattern="yyyy-MM-dd" />" required>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty job}">
                                <div class="form-group">
                                    <label for="status">Job Status</label>
                                    <select class="form-control" id="status" name="status">
                                        <option value="PUBLISHED" ${job.status == 'PUBLISHED' ? 'selected' : ''}>Published</option>
                                        <option value="DRAFT" ${job.status == 'DRAFT' ? 'selected' : ''}>Draft</option>
                                        <option value="CLOSED" ${job.status == 'CLOSED' ? 'selected' : ''}>Closed</option>
                                        <option value="FILLED" ${job.status == 'FILLED' ? 'selected' : ''}>Filled</option>
                                    </select>
                                </div>
                            </c:if>
                            
                            <hr>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <button type="submit" class="btn btn-primary btn-block">
                                        ${empty job ? 'Post Job' : 'Update Job'}
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/company/jobs/manage" class="btn btn-outline-secondary btn-block">Cancel</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Tips Card -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">Tips for Writing Effective Job Listings</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check-circle text-success mr-2"></i> Use a clear, specific job title</li>
                                    <li><i class="fas fa-check-circle text-success mr-2"></i> Include detailed job responsibilities</li>
                                    <li><i class="fas fa-check-circle text-success mr-2"></i> Specify required skills and experience</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check-circle text-success mr-2"></i> Provide a realistic budget range</li>
                                    <li><i class="fas fa-check-circle text-success mr-2"></i> Mention benefits or perks</li>
                                    <li><i class="fas fa-check-circle text-success mr-2"></i> Set a reasonable application deadline</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
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
