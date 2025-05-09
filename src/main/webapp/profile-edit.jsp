<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="page-header">
            <div class="container">
                <h1>Edit Profile</h1>
                <p>Update your personal information and profile details</p>
            </div>
        </section>
        
        <section class="profile-edit-section">
            <div class="container">
                <div class="form-card">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${errorMessage}</span>
                        </div>
                    </c:if>
                    
                    <form action="<c:url value='/profile/edit'/>" method="post" class="profile-form">
                        <c:choose>
                            <c:when test="${user.isFreelancer()}">
                                <!-- Freelancer Profile Form -->
                                <div class="form-group">
                                    <label for="fullName">Full Name</label>
                                    <input type="text" id="fullName" name="fullName" value="${user.fullName}">
                                </div>
                                
                                <div class="form-group">
                                    <label for="location">Location</label>
                                    <input type="text" id="location" name="location" value="${user.location}" 
                                           placeholder="e.g., New York, USA">
                                </div>
                                
                                <div class="form-group">
                                    <label for="phoneNumber">Phone Number</label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" 
                                           placeholder="e.g., +1 (123) 456-7890">
                                </div>
                                
                                <div class="form-group">
                                    <label for="profileDescription">Professional Summary</label>
                                    <textarea id="profileDescription" name="profileDescription" rows="5" 
                                              placeholder="Tell potential clients about your background, experience, and expertise...">${user.profileDescription}</textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="skills">Skills (comma separated)</label>
                                    <input type="text" id="skills" name="skills" value="${user.skills}" 
                                           placeholder="e.g., Java, HTML, CSS, JavaScript, Project Management">
                                    <small>Add relevant skills to help clients find you for their projects</small>
                                </div>
                            </c:when>
                            
                            <c:when test="${user.isCompany()}">
                                <!-- Company Profile Form -->
                                <div class="form-group">
                                    <label for="companyName">Company Name</label>
                                    <input type="text" id="companyName" name="companyName" value="${user.companyName}">
                                </div>
                                
                                <div class="form-group">
                                    <label for="fullName">Contact Person</label>
                                    <input type="text" id="fullName" name="fullName" value="${user.fullName}">
                                </div>
                                
                                <div class="form-group">
                                    <label for="location">Location</label>
                                    <input type="text" id="location" name="location" value="${user.location}" 
                                           placeholder="e.g., San Francisco, CA">
                                </div>
                                
                                <div class="form-group">
                                    <label for="phoneNumber">Phone Number</label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" 
                                           placeholder="e.g., +1 (123) 456-7890">
                                </div>
                                
                                <div class="form-group">
                                    <label for="companyWebsite">Company Website</label>
                                    <input type="url" id="companyWebsite" name="companyWebsite" value="${user.companyWebsite}" 
                                           placeholder="e.g., https://www.yourcompany.com">
                                </div>
                                
                                <div class="form-group">
                                    <label for="profileDescription">Company Description</label>
                                    <textarea id="profileDescription" name="profileDescription" rows="5" 
                                              placeholder="Tell freelancers about your company, mission, and the type of projects you typically work on...">${user.profileDescription}</textarea>
                                </div>
                            </c:when>
                            
                            <c:otherwise>
                                <!-- Admin Profile Form -->
                                <div class="form-group">
                                    <label for="fullName">Full Name</label>
                                    <input type="text" id="fullName" name="fullName" value="${user.fullName}">
                                </div>
                                
                                <div class="form-group">
                                    <label for="phoneNumber">Phone Number</label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" 
                                           placeholder="e.g., +1 (123) 456-7890">
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="<c:url value='/profile'/>" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
                
                <div class="account-info-card">
                    <h3>Account Information</h3>
                    <div class="account-info">
                        <div class="info-item">
                            <span class="label">Username:</span>
                            <span class="value">${user.username}</span>
                        </div>
                        <div class="info-item">
                            <span class="label">Email:</span>
                            <span class="value">${user.email}</span>
                        </div>
                        <div class="info-item">
                            <span class="label">Account Type:</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${user.isFreelancer()}">Freelancer</c:when>
                                    <c:when test="${user.isCompany()}">Company</c:when>
                                    <c:when test="${user.isAdmin()}">Administrator</c:when>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <p class="note">Note: To change your username or email, please contact support.</p>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
</body>
</html>
