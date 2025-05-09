<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Jobs | QuickHire</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <section class="search-header">
            <div class="container">
                <h1>Find Your Next Opportunity</h1>
                <p>Browse and search for jobs that match your skills and interests</p>
                
                <form action="<c:url value='/jobs/search'/>" method="get" class="search-form">
                    <div class="search-input-group">
                        <input type="text" name="query" value="${searchQuery}" placeholder="Search for jobs by title, skills, or keywords">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </div>
                </form>
            </div>
        </section>
        
        <section class="job-listings">
            <div class="container">
                <div class="job-filters-and-results">
                    <div class="job-filters">
                        <div class="filter-card">
                            <h3>Filters</h3>
                            
                            <div class="filter-section">
                                <h4>Category</h4>
                                <div class="filter-options">
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="category" value="Web Development">
                                        <span>Web Development</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="category" value="Design & Creative">
                                        <span>Design & Creative</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="category" value="Writing">
                                        <span>Writing</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="category" value="Marketing">
                                        <span>Marketing</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="category" value="Mobile Development">
                                        <span>Mobile Development</span>
                                    </label>
                                </div>
                                <a href="#" class="show-more-link">Show more</a>
                            </div>
                            
                            <div class="filter-section">
                                <h4>Budget Range</h4>
                                <div class="filter-options">
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="budget" value="0-500">
                                        <span>$0 - $500</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="budget" value="500-1000">
                                        <span>$500 - $1,000</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="budget" value="1000-5000">
                                        <span>$1,000 - $5,000</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="budget" value="5000+">
                                        <span>$5,000+</span>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="filter-section">
                                <h4>Location</h4>
                                <div class="filter-options">
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="location" value="Remote">
                                        <span>Remote</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="location" value="US">
                                        <span>United States</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="location" value="Europe">
                                        <span>Europe</span>
                                    </label>
                                    <label class="checkbox-container">
                                        <input type="checkbox" name="location" value="Asia">
                                        <span>Asia</span>
                                    </label>
                                </div>
                                <a href="#" class="show-more-link">Show more</a>
                            </div>
                            
                            <button type="button" class="btn btn-secondary btn-block" id="applyFilters">Apply Filters</button>
                        </div>
                    </div>
                    
                    <div class="job-results">
                        <div class="results-header">
                            <div class="results-count">
                                <h2>
                                    <c:choose>
                                        <c:when test="${not empty searchQuery}">
                                            Search Results for "${searchQuery}"
                                        </c:when>
                                        <c:otherwise>
                                            All Available Jobs
                                        </c:otherwise>
                                    </c:choose>
                                </h2>
                                <p>${jobs.size()} jobs found</p>
                            </div>
                            <div class="results-sort">
                                <label for="sortOrder">Sort by:</label>
                                <select id="sortOrder" class="form-select">
                                    <option value="newest">Most Recent</option>
                                    <option value="budget-high">Budget: High to Low</option>
                                    <option value="budget-low">Budget: Low to High</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="job-list">
                            <c:choose>
                                <c:when test="${empty jobs}">
                                    <div class="empty-state">
                                        <i class="fas fa-search"></i>
                                        <h3>No jobs found</h3>
                                        <p>
                                            <c:choose>
                                                <c:when test="${not empty searchQuery}">
                                                    No jobs match your search criteria. Try different keywords or filters.
                                                </c:when>
                                                <c:otherwise>
                                                    There are currently no available jobs. Please check back later.
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <c:if test="${not empty searchQuery}">
                                            <a href="<c:url value='/jobs'/>" class="btn btn-primary">View All Jobs</a>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${jobs}" var="job">
                                        <div class="job-card horizontal" data-category="${job.category}" data-budget="${job.budget}" data-location="${job.location}">
                                            <div class="job-card-header">
                                                <h3><a href="<c:url value='/jobs/view/${job.id}'/>">${job.title}</a></h3>
                                                <span class="job-type">${job.location}</span>
                                            </div>
                                            <div class="job-card-body">
                                                <p class="job-company">
                                                    <c:if test="${not empty job.companyName}">
                                                        ${job.companyName}
                                                    </c:if>
                                                </p>
                                                <p class="job-description">
                                                    ${fn:substring(job.description, 0, 150)}${fn:length(job.description) > 150 ? '...' : ''}
                                                </p>
                                                <div class="job-meta">
                                                    <span class="job-category"><i class="fas fa-tag"></i> ${job.category}</span>
                                                    <span class="job-date"><i class="fas fa-calendar-alt"></i> <fmt:formatDate value="${job.postedAt}" pattern="MMM dd, yyyy" /></span>
                                                </div>
                                                <div class="job-tags">
                                                    <c:if test="${not empty job.skills}">
                                                        <c:forEach items="${fn:split(job.skills, ',')}" var="skill" begin="0" end="4">
                                                            <span>${fn:trim(skill)}</span>
                                                        </c:forEach>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="job-card-footer">
                                                <p class="job-budget">${job.budget != null ? '$'.concat(job.budget) : 'Budget not specified'}</p>
                                                <a href="<c:url value='/jobs/view/${job.id}'/>" class="btn btn-secondary">View Details</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Pagination would go here in a real implementation -->
                        <div class="pagination">
                            <a href="#" class="pagination-item disabled"><i class="fas fa-chevron-left"></i></a>
                            <a href="#" class="pagination-item active">1</a>
                            <a href="#" class="pagination-item">2</a>
                            <a href="#" class="pagination-item">3</a>
                            <span class="pagination-ellipsis">...</span>
                            <a href="#" class="pagination-item">10</a>
                            <a href="#" class="pagination-item"><i class="fas fa-chevron-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="<c:url value='/js/script.js'/>"></script>
    <script>
        // Client-side filtering and sorting (would be server-side in production)
        document.getElementById('applyFilters').addEventListener('click', function() {
            // In a real implementation, this would submit the form to the server
            // For now, we'll just show an alert
            alert('Filter functionality would be implemented on the server side in a production environment.');
        });
        
        document.getElementById('sortOrder').addEventListener('change', function() {
            const sortValue = this.value;
            const jobCards = document.querySelectorAll('.job-card.horizontal');
            const jobList = document.querySelector('.job-list');
            
            // Convert NodeList to Array for sorting
            const jobsArray = Array.from(jobCards);
            
            // Sort jobs based on selection
            if (sortValue === 'newest') {
                // No sorting needed, jobs are already sorted by newest
                // In a real implementation, this would go to the server
                alert('Sort by Most Recent would be implemented on the server side.');
            } else if (sortValue === 'budget-high') {
                alert('Sort by Budget: High to Low would be implemented on the server side.');
            } else if (sortValue === 'budget-low') {
                alert('Sort by Budget: Low to High would be implemented on the server side.');
            }
        });
    </script>
</body>
</html>
