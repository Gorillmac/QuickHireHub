<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Job | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="page-header">
            <div class="container">
                <h1>Apply for Job</h1>
                <p>Submit your application for ${job.title}</p>
            </div>
        </section>
        
        <section class="application-form-section">
            <div class="container">
                <div class="application-grid">
                    <div class="application-form-container">
                        <div class="form-card">
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-error">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span>${errorMessage}</span>
                                </div>
                            </c:if>
                            
                            <form action="<c:url value='/applications/create/${job.id}'/>" method="post" class="application-form">
                                <div class="form-group">
                                    <label for="coverLetter">Cover Letter *</label>
                                    <textarea id="coverLetter" name="coverLetter" rows="8" required
                                              placeholder="Introduce yourself and explain why you're a good fit for this job..."></textarea>
                                    <small>Describe your relevant experience and why you're interested in this project</small>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-half">
                                        <label for="proposedRate">Proposed Rate ($) *</label>
                                        <input type="number" id="proposedRate" name="proposedRate" min="1" step="0.01" required
                                               placeholder="Your proposed rate">
                                        <small>
                                            <c:choose>
                                                <c:when test="${job.paymentType eq 'Hourly'}">Hourly rate in USD</c:when>
                                                <c:when test="${job.paymentType eq 'Fixed'}">Fixed price in USD</c:when>
                                                <c:otherwise>Your proposed rate in USD</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                    
                                    <div class="form-group col-half">
                                        <label for="estimatedDuration">Estimated Duration (days) *</label>
                                        <input type="number" id="estimatedDuration" name="estimatedDuration" min="1" required
                                               placeholder="Estimated completion time in days">
                                        <small>How long do you expect the project to take?</small>
                                    </div>
                                </div>
                                
                                <div class="form-notice">
                                    <p><i class="fas fa-info-circle"></i> 
                                        By submitting this application, you agree to the terms of service and commit to completing
                                        the project as described if your application is accepted.
                                    </p>
                                </div>
                                
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Submit Application</button>
                                    <a href="<c:url value='/jobs/view/${job.id}'/>" class="btn btn-secondary">Cancel</a>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <div class="job-summary">
                        <div class="job-summary-card">
                            <h3>Job Summary</h3>
                            <div class="job-info">
                                <h4>${job.title}</h4>
                                <p class="job-company">${company.companyName}</p>
                                
                                <div class="job-meta">
                                    <span class="job-category"><i class="fas fa-tag"></i> ${job.category}</span>
                                    <span class="job-location"><i class="fas fa-map-marker-alt"></i> ${job.location}</span>
                                </div>
                                
                                <div class="job-details">
                                    <div class="detail-item">
                                        <span class="label">Budget:</span>
                                        <span class="value">${job.budget != null ? '$'.concat(job.budget) : 'Not specified'}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="label">Payment Type:</span>
                                        <span class="value">${not empty job.paymentType ? job.paymentType : 'Not specified'}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="label">Duration:</span>
                                        <span class="value">${not empty job.duration ? job.duration : 'Not specified'}</span>
                                    </div>
                                    <div class="detail-item">
                                        <span class="label">Posted:</span>
                                        <span class="value"><fmt:formatDate value="${job.postedAt}" pattern="MMM dd, yyyy" /></span>
                                    </div>
                                </div>
                                
                                <div class="job-description-summary">
                                    <h5>Description:</h5>
                                    <p>${job.description.length() > 200 ? job.description.substring(0, 200).concat('...') : job.description}</p>
                                </div>
                                
                                <a href="<c:url value='/jobs/view/${job.id}'/>" class="btn btn-sm btn-secondary">View Full Job Details</a>
                            </div>
                        </div>
                        
                        <div class="application-tips">
                            <h3>Tips for a Successful Application</h3>
                            <ul>
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>Highlight relevant skills and experience</span>
                                </li>
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>Be specific about how you'll approach the project</span>
                                </li>
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>Set reasonable expectations for rates and timelines</span>
                                </li>
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>Personalize your application for this specific job</span>
                                </li>
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>Be professional and check for typos</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
</body>
</html>
