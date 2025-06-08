<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty currentUser ? freelancer.getFullName() : 'My Profile'} - QuickHire</title>
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
            <!-- Sidebar (only for own profile) -->
            <c:if test="${not empty currentUser}">
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
                                <a class="nav-link active" href="${pageContext.request.contextPath}/profile/edit">
                                    <i class="fas fa-user-cog mr-2"></i> Profile Settings
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </c:if>
            
            <!-- Main Content -->
            <main role="main" class="${not empty currentUser ? 'col-md-9 ml-sm-auto col-lg-10' : 'col-md-12'} px-md-4 py-4">
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
                <c:if test="${not empty passwordSuccess}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${passwordSuccess}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                <c:if test="${not empty passwordError}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${passwordError}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <!-- Edit Profile Mode -->
                        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h1 class="h2">Edit Profile</h1>
                            <div class="btn-toolbar mb-2 mb-md-0">
                                <a href="${pageContext.request.contextPath}/freelancer/dashboard" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                                </a>
                            </div>
                        </div>
                        
                        <!-- Profile Form -->
                        <div class="row">
                            <div class="col-md-8">
                                <div class="card shadow mb-4">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0">Personal Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <form action="${pageContext.request.contextPath}/profile/edit" method="post">
                                            <div class="form-row">
                                                <div class="form-group col-md-6">
                                                    <label for="firstName">First Name</label>
                                                    <input type="text" class="form-control" id="firstName" name="firstName" value="${currentUser.firstName}" required>
                                                </div>
                                                <div class="form-group col-md-6">
                                                    <label for="lastName">Last Name</label>
                                                    <input type="text" class="form-control" id="lastName" name="lastName" value="${currentUser.lastName}" required>
                                                </div>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="email">Email</label>
                                                <input type="email" class="form-control" id="email" name="email" value="${currentUser.email}" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="title">Professional Title</label>
                                                <input type="text" class="form-control" id="title" name="title" value="${currentUser.title}" 
                                                       placeholder="e.g., Senior Web Developer, UI/UX Designer" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="skills">Skills</label>
                                                <input type="text" class="form-control" id="skills" name="skills" value="${currentUser.skills}" 
                                                       placeholder="e.g., Java, JavaScript, HTML, CSS, Project Management" required>
                                                <small class="form-text text-muted">Enter your skills separated by commas</small>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="bio">Professional Bio</label>
                                                <textarea class="form-control" id="bio" name="bio" rows="5" 
                                                          placeholder="Tell potential employers about yourself, your experience, and your expertise">${currentUser.bio}</textarea>
                                            </div>
                                            
                                            <div class="form-row">
                                                <div class="form-group col-md-6">
                                                    <label for="location">Location</label>
                                                    <input type="text" class="form-control" id="location" name="location" value="${currentUser.location}" 
                                                           placeholder="e.g., New York, NY, USA">
                                                </div>
                                                <div class="form-group col-md-6">
                                                    <label for="phone">Phone Number</label>
                                                    <input type="tel" class="form-control" id="phone" name="phone" value="${currentUser.phone}" 
                                                           placeholder="e.g., +1-555-123-4567">
                                                </div>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="website">Website or Portfolio</label>
                                                <input type="url" class="form-control" id="website" name="website" value="${currentUser.website}" 
                                                       placeholder="e.g., https://your-portfolio.com">
                                            </div>
                                            
                                            <button type="submit" class="btn btn-primary">Save Changes</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <!-- Password Change Card -->
                                <div class="card shadow mb-4">
                                    <div class="card-header bg-white py-3">
                                        <h5 class="mb-0">Change Password</h5>
                                    </div>
                                    <div class="card-body">
                                        <form action="${pageContext.request.contextPath}/profile/change-password" method="post">
                                            <div class="form-group">
                                                <label for="currentPassword">Current Password</label>
                                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="newPassword">New Password</label>
                                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="confirmPassword">Confirm New Password</label>
                                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                            </div>
                                            
                                            <button type="submit" class="btn btn-warning btn-block">Change Password</button>
                                        </form>
                                    </div>
                                </div>
                                
                                <!-- Profile Tips Card -->
                                <div class="card shadow mb-4">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0">Profile Tips</h5>
                                    </div>
                                    <div class="card-body">
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-check-circle text-success mr-2"></i> Use a clear, professional title</li>
                                            <li><i class="fas fa-check-circle text-success mr-2"></i> List your key skills</li>
                                            <li><i class="fas fa-check-circle text-success mr-2"></i> Write a detailed bio</li>
                                            <li><i class="fas fa-check-circle text-success mr-2"></i> Include your location</li>
                                            <li><i class="fas fa-check-circle text-success mr-2"></i> Add your contact information</li>
                                            <li><i class="fas fa-check-circle text-success mr-2"></i> Link to your portfolio</li>
                                        </ul>
                                        <p class="mb-0">Complete profiles get 2x more job offers!</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- View Profile Mode (for viewing other freelancers) -->
                        <div class="card shadow my-4">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="profile-info">
                                            <h2>${freelancer.getFullName()}</h2>
                                            <h5 class="text-muted">${freelancer.title}</h5>
                                            <p class="mb-4">${freelancer.bio}</p>
                                            
                                            <h6 class="font-weight-bold">Skills</h6>
                                            <div class="skills-container mb-4">
                                                <c:forEach items="${freelancer.skills.split(',')}" var="skill">
                                                    <span class="badge badge-primary px-3 py-2 mr-2 mb-2">${skill.trim()}</span>
                                                </c:forEach>
                                            </div>
                                            
                                            <div class="row mb-4">
                                                <div class="col-md-6">
                                                    <p>
                                                        <i class="fas fa-map-marker-alt mr-2 text-primary"></i>
                                                        <span>${not empty freelancer.location ? freelancer.location : 'Location not specified'}</span>
                                                    </p>
                                                    <c:if test="${not empty freelancer.website}">
                                                        <p>
                                                            <i class="fas fa-globe mr-2 text-primary"></i>
                                                            <a href="${freelancer.website}" target="_blank">${freelancer.website}</a>
                                                        </p>
                                                    </c:if>
                                                </div>
                                                <div class="col-md-6">
                                                    <p>
                                                        <i class="fas fa-user-circle mr-2 text-primary"></i>
                                                        <span>Member since <fmt:formatDate value="${freelancer.createdAt}" pattern="MMMM yyyy" /></span>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 text-center">
                                        <div class="profile-actions">
                                            <div class="avatar-container mb-3">
                                                <i class="fas fa-user-circle fa-6x text-muted"></i>
                                            </div>
                                            
                                            <c:if test="${not empty user && user.isCompany()}">
                                                <a href="${pageContext.request.contextPath}/messaging/conversation/${freelancer.id}" class="btn btn-primary btn-block mb-2">
                                                    <i class="fas fa-envelope"></i> Contact Freelancer
                                                </a>
                                            </c:if>
                                            
                                            <c:if test="${not empty user && (user.isAdmin() || user.isCompany() || user.isFreelancer())}">
                                                <a href="${pageContext.request.contextPath}/report/user/${freelancer.id}" class="btn btn-outline-danger btn-block">
                                                    <i class="fas fa-flag"></i> Report User
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
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
