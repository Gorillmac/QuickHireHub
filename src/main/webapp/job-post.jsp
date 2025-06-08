<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${editing ? 'Edit Job' : 'Post New Job'} | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="page-header">
            <div class="container">
                <h1>${editing ? 'Edit Job Posting' : 'Post a New Job'}</h1>
                <p>${editing ? 'Update your job listing details' : 'Find the perfect freelancer for your project'}</p>
            </div>
        </section>
        
        <section class="job-post-section">
            <div class="container">
                <div class="form-card">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${errorMessage}</span>
                        </div>
                    </c:if>
                    
                    <form action="<c:url value='${editing ? "/jobs/edit/".concat(job.id) : "/jobs/create"}'/>" method="post" class="job-form">
                        <div class="form-group">
                            <label for="title">Job Title *</label>
                            <input type="text" id="title" name="title" required 
                                   value="${job != null ? job.title : ''}" 
                                   placeholder="e.g., Web Developer for E-commerce Site">
                            <small>Be specific to attract the right candidates</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Job Description *</label>
                            <textarea id="description" name="description" rows="6" required 
                                      placeholder="Describe the project, goals, and deliverables">${job != null ? job.description : ''}</textarea>
                            <small>Include key details about the project and requirements</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="requirements">Required Skills and Experience</label>
                            <textarea id="requirements" name="requirements" rows="4" 
                                      placeholder="List skills, experience, and qualifications needed">${job != null ? job.requirements : ''}</textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-half">
                                <label for="location">Location</label>
                                <input type="text" id="location" name="location" 
                                       value="${job != null ? job.location : ''}" 
                                       placeholder="e.g., Remote, New York, etc.">
                            </div>
                            
                            <div class="form-group col-half">
                                <label for="category">Category</label>
                                <select id="category" name="category">
                                    <option value="" ${job == null || empty job.category ? 'selected' : ''}>Select a category</option>
                                    <option value="Web Development" ${job != null && job.category == 'Web Development' ? 'selected' : ''}>Web Development</option>
                                    <option value="Mobile Development" ${job != null && job.category == 'Mobile Development' ? 'selected' : ''}>Mobile Development</option>
                                    <option value="Design & Creative" ${job != null && job.category == 'Design & Creative' ? 'selected' : ''}>Design & Creative</option>
                                    <option value="Writing" ${job != null && job.category == 'Writing' ? 'selected' : ''}>Writing</option>
                                    <option value="Marketing" ${job != null && job.category == 'Marketing' ? 'selected' : ''}>Marketing</option>
                                    <option value="Administrative" ${job != null && job.category == 'Administrative' ? 'selected' : ''}>Administrative</option>
                                    <option value="Customer Service" ${job != null && job.category == 'Customer Service' ? 'selected' : ''}>Customer Service</option>
                                    <option value="Accounting & Finance" ${job != null && job.category == 'Accounting & Finance' ? 'selected' : ''}>Accounting & Finance</option>
                                    <option value="Legal" ${job != null && job.category == 'Legal' ? 'selected' : ''}>Legal</option>
                                    <option value="Engineering & Architecture" ${job != null && job.category == 'Engineering & Architecture' ? 'selected' : ''}>Engineering & Architecture</option>
                                    <option value="Sales & Business Development" ${job != null && job.category == 'Sales & Business Development' ? 'selected' : ''}>Sales & Business Development</option>
                                    <option value="Other" ${job != null && job.category == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-half">
                                <label for="budget">Budget ($)</label>
                                <input type="number" id="budget" name="budget" min="0" step="0.01" 
                                       value="${job != null && job.budget != null ? job.budget : ''}" 
                                       placeholder="Enter your budget">
                            </div>
                            
                            <div class="form-group col-half">
                                <label for="paymentType">Payment Type</label>
                                <select id="paymentType" name="paymentType">
                                    <option value="" ${job == null || empty job.paymentType ? 'selected' : ''}>Select payment type</option>
                                    <option value="Fixed" ${job != null && job.paymentType == 'Fixed' ? 'selected' : ''}>Fixed Price</option>
                                    <option value="Hourly" ${job != null && job.paymentType == 'Hourly' ? 'selected' : ''}>Hourly Rate</option>
                                    <option value="Milestone" ${job != null && job.paymentType == 'Milestone' ? 'selected' : ''}>Milestone Based</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-half">
                                <label for="duration">Estimated Duration</label>
                                <input type="text" id="duration" name="duration" 
                                       value="${job != null ? job.duration : ''}" 
                                       placeholder="e.g., 2 weeks, 3 months">
                            </div>
                            
                            <div class="form-group col-half">
                                <label for="skills">Skills (comma separated)</label>
                                <input type="text" id="skills" name="skills" 
                                       value="${job != null ? job.skills : ''}" 
                                       placeholder="e.g., HTML, CSS, JavaScript">
                                <small>Important for matching with freelancers</small>
                            </div>
                        </div>
                        
                        <div class="form-notice">
                            <p><i class="fas fa-info-circle"></i> Note: Your job post will be reviewed by an admin before it becomes visible to freelancers.</p>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                ${editing ? 'Update Job' : 'Post Job'}
                            </button>
                            <a href="<c:url value='/dashboard-company'/>" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
</body>
</html>
