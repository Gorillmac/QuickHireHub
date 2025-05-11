// QuickHire Dashboard JavaScript

// Store user info from login
let currentUser = null;
let userJobs = [];
let allJobs = [];

// Initialize the dashboard when the document is ready
document.addEventListener('DOMContentLoaded', () => {
    // Check if user is logged in by looking for userId in localStorage
    const userId = localStorage.getItem('userId');
    const userType = localStorage.getItem('userType');
    
    if (!userId) {
        // Not logged in, redirect to login page
        window.location.href = 'login.html';
        return;
    }
    
    // Set user information from localStorage
    currentUser = {
        id: userId,
        firstName: localStorage.getItem('firstName') || 'User',
        lastName: localStorage.getItem('lastName') || '',
        email: localStorage.getItem('email') || '',
        userType: userType || 'client',
        currency: localStorage.getItem('currency') || 'ZAR',
        locale: localStorage.getItem('locale') || 'en-ZA'
    };
    
    // Update user info display
    updateUserInfo();
    
    // Load dashboard data based on user type
    if (userType === 'freelancer') {
        initializeFreelancerDashboard();
    } else {
        initializeClientDashboard();
    }
    
    // Set up event listeners
    setupEventListeners();
});

// Update user information display
function updateUserInfo() {
    // Update welcome message
    const welcomeElement = document.getElementById('welcome-message');
    if (welcomeElement) {
        welcomeElement.textContent = `Welcome, ${currentUser.firstName}!`;
    }
    
    // Update profile name
    const profileNameElement = document.getElementById('profile-name');
    if (profileNameElement) {
        profileNameElement.textContent = `${currentUser.firstName} ${currentUser.lastName}`;
    }
    
    // Update other user-specific UI elements
    const userTypeElements = document.querySelectorAll('.user-type');
    userTypeElements.forEach(element => {
        element.textContent = currentUser.userType.charAt(0).toUpperCase() + currentUser.userType.slice(1);
    });
}

// Initialize client dashboard
function initializeClientDashboard() {
    console.log('Initializing client dashboard');
    
    // Load client's jobs
    loadClientJobs();
    
    // Show client-specific UI elements
    document.querySelectorAll('.client-only').forEach(element => {
        element.style.display = 'block';
    });
    
    // Hide freelancer-specific UI elements
    document.querySelectorAll('.freelancer-only').forEach(element => {
        element.style.display = 'none';
    });
}

// Initialize freelancer dashboard
function initializeFreelancerDashboard() {
    console.log('Initializing freelancer dashboard');
    
    // Load available jobs
    loadAvailableJobs();
    
    // Load freelancer's active jobs (applications)
    loadFreelancerJobs();
    
    // Show freelancer-specific UI elements
    document.querySelectorAll('.freelancer-only').forEach(element => {
        element.style.display = 'block';
    });
    
    // Hide client-specific UI elements
    document.querySelectorAll('.client-only').forEach(element => {
        element.style.display = 'none';
    });
}

// Load client's posted jobs
async function loadClientJobs() {
    try {
        const response = await fetch(`/jobs?client_id=${currentUser.id}`);
        if (!response.ok) {
            throw new Error(`Error: ${response.status}`);
        }
        
        userJobs = await response.json();
        displayClientJobs(userJobs);
    } catch (error) {
        console.error('Failed to load client jobs:', error);
        displayError('job-list', 'Failed to load your jobs. Please try again later.');
    }
}

// Load available jobs for freelancers
async function loadAvailableJobs() {
    try {
        // Get open jobs
        const response = await fetch('/jobs?status=OPEN');
        if (!response.ok) {
            throw new Error(`Error: ${response.status}`);
        }
        
        allJobs = await response.json();
        displayAvailableJobs(allJobs);
    } catch (error) {
        console.error('Failed to load available jobs:', error);
        displayError('available-jobs', 'Failed to load available jobs. Please try again later.');
    }
}

// Display client's posted jobs
function displayClientJobs(jobs) {
    const jobListContainer = document.getElementById('job-list');
    if (!jobListContainer) return;
    
    if (jobs.length === 0) {
        jobListContainer.innerHTML = '<div class="empty-state">You haven\'t posted any jobs yet. Click "Post a New Job" to get started.</div>';
        return;
    }
    
    // Clear container
    jobListContainer.innerHTML = '';
    
    // Create job cards
    jobs.forEach(job => {
        const jobCard = createJobCard(job, 'client');
        jobListContainer.appendChild(jobCard);
    });
}

// Display available jobs for freelancers
function displayAvailableJobs(jobs) {
    const availableJobsContainer = document.getElementById('available-jobs');
    if (!availableJobsContainer) return;
    
    if (jobs.length === 0) {
        availableJobsContainer.innerHTML = '<div class="empty-state">No jobs available at the moment. Check back later!</div>';
        return;
    }
    
    // Clear container
    availableJobsContainer.innerHTML = '';
    
    // Create job cards
    jobs.forEach(job => {
        const jobCard = createJobCard(job, 'freelancer');
        availableJobsContainer.appendChild(jobCard);
    });
}

// Create a job card element
function createJobCard(job, viewType) {
    const formatter = new Intl.NumberFormat(currentUser.locale, {
        style: 'currency',
        currency: currentUser.currency,
        minimumFractionDigits: 2
    });
    
    const formattedBudget = formatter.format(job.budget);
    console.log('Currency format example:', formattedBudget);
    
    const jobCard = document.createElement('div');
    jobCard.className = 'job-card';
    jobCard.dataset.jobId = job.id;
    
    // Status indicator
    const statusClass = job.status.toLowerCase().replace('_', '-');
    
    // Create card content based on view type (client or freelancer)
    if (viewType === 'client') {
        jobCard.innerHTML = `
            <div class="job-status ${statusClass}">${job.status.replace('_', ' ')}</div>
            <h3 class="job-title">${job.title}</h3>
            <div class="job-budget">${formattedBudget}</div>
            <div class="job-location"><i class="fa fa-map-marker"></i> ${job.location}</div>
            <div class="job-date">Posted: ${new Date(job.created_at).toLocaleDateString(currentUser.locale)}</div>
            <div class="job-skills">
                ${job.skills.map(skill => `<span class="skill-tag">${skill}</span>`).join('')}
            </div>
            <div class="job-actions">
                <button class="btn btn-primary btn-view-job" data-job-id="${job.id}">View Details</button>
                <button class="btn btn-secondary btn-edit-job" data-job-id="${job.id}">Edit Job</button>
            </div>
        `;
    } else {
        jobCard.innerHTML = `
            <h3 class="job-title">${job.title}</h3>
            <div class="job-budget">${formattedBudget}</div>
            <div class="job-location"><i class="fa fa-map-marker"></i> ${job.location}</div>
            <div class="job-date">Posted: ${new Date(job.created_at).toLocaleDateString(currentUser.locale)}</div>
            <div class="job-description">${job.description.substring(0, 100)}${job.description.length > 100 ? '...' : ''}</div>
            <div class="job-skills">
                ${job.skills.map(skill => `<span class="skill-tag">${skill}</span>`).join('')}
            </div>
            <div class="job-actions">
                <button class="btn btn-primary btn-view-job" data-job-id="${job.id}">View Details</button>
                <button class="btn btn-success btn-apply-job" data-job-id="${job.id}">Apply Now</button>
            </div>
        `;
    }
    
    return jobCard;
}

// Display job details
function displayJobDetails(jobId) {
    // Find the job in our cached data
    const job = [...userJobs, ...allJobs].find(job => job.id === jobId);
    if (!job) {
        console.error('Job not found:', jobId);
        return;
    }
    
    const formatter = new Intl.NumberFormat(currentUser.locale, {
        style: 'currency',
        currency: currentUser.currency,
        minimumFractionDigits: 2
    });
    
    // Create a modal for job details
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>${job.title}</h2>
            <div class="job-status ${job.status.toLowerCase().replace('_', '-')}">${job.status.replace('_', ' ')}</div>
            <div class="job-budget">${formatter.format(job.budget)}</div>
            <div class="job-location"><i class="fa fa-map-marker"></i> ${job.location}</div>
            <div class="job-date">Posted: ${new Date(job.created_at).toLocaleDateString(currentUser.locale)}</div>
            
            <h3>Description</h3>
            <div class="job-description">${job.description}</div>
            
            <h3>Required Skills</h3>
            <div class="job-skills">
                ${job.skills.map(skill => `<span class="skill-tag">${skill}</span>`).join('')}
            </div>
            
            <div class="modal-actions">
                ${currentUser.userType === 'freelancer' ? 
                    `<button class="btn btn-success btn-apply-job-modal" data-job-id="${job.id}">Apply for this Job</button>` : 
                    `<button class="btn btn-secondary btn-edit-job-modal" data-job-id="${job.id}">Edit Job</button>`
                }
                <button class="btn btn-tertiary btn-close-modal">Close</button>
            </div>
        </div>
    `;
    
    // Add modal to the document body
    document.body.appendChild(modal);
    
    // Show the modal
    setTimeout(() => {
        modal.style.display = 'block';
    }, 10);
    
    // Close button functionality
    const closeButton = modal.querySelector('.close');
    closeButton.addEventListener('click', () => {
        modal.style.display = 'none';
        setTimeout(() => {
            modal.remove();
        }, 300);
    });
    
    // Close modal button functionality
    const closeModalButton = modal.querySelector('.btn-close-modal');
    closeModalButton.addEventListener('click', () => {
        modal.style.display = 'none';
        setTimeout(() => {
            modal.remove();
        }, 300);
    });
    
    // Apply job button functionality (for freelancers)
    const applyButton = modal.querySelector('.btn-apply-job-modal');
    if (applyButton) {
        applyButton.addEventListener('click', () => {
            applyForJob(job.id);
            modal.style.display = 'none';
            setTimeout(() => {
                modal.remove();
            }, 300);
        });
    }
    
    // Edit job button functionality (for clients)
    const editButton = modal.querySelector('.btn-edit-job-modal');
    if (editButton) {
        editButton.addEventListener('click', () => {
            showEditJobForm(job);
            modal.style.display = 'none';
            setTimeout(() => {
                modal.remove();
            }, 300);
        });
    }
}

// Display new job form for clients
function showNewJobForm() {
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Post a New Job</h2>
            <form id="new-job-form">
                <div class="form-group">
                    <label for="job-title">Job Title</label>
                    <input type="text" id="job-title" name="title" required placeholder="E.g., Web Developer needed for E-commerce site">
                </div>
                
                <div class="form-group">
                    <label for="job-description">Description</label>
                    <textarea id="job-description" name="description" rows="6" required placeholder="Describe the job in detail, including responsibilities and deliverables"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="job-budget">Budget (${currentUser.currency})</label>
                    <input type="number" id="job-budget" name="budget" required min="1" placeholder="E.g., 10000">
                </div>
                
                <div class="form-group">
                    <label for="job-skills">Required Skills (comma separated)</label>
                    <input type="text" id="job-skills" name="skills" required placeholder="E.g., HTML, CSS, JavaScript, React">
                </div>
                
                <div class="form-group">
                    <label for="job-location">Location</label>
                    <input type="text" id="job-location" name="location" required placeholder="E.g., Cape Town / Remote">
                </div>
                
                <div class="form-group">
                    <label for="job-deadline">Deadline (optional)</label>
                    <input type="date" id="job-deadline" name="deadline">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Post Job</button>
                    <button type="button" class="btn btn-tertiary btn-cancel">Cancel</button>
                </div>
            </form>
        </div>
    `;
    
    // Add modal to the document body
    document.body.appendChild(modal);
    
    // Show the modal
    setTimeout(() => {
        modal.style.display = 'block';
    }, 10);
    
    // Close button functionality
    const closeButton = modal.querySelector('.close');
    closeButton.addEventListener('click', () => {
        modal.style.display = 'none';
        setTimeout(() => {
            modal.remove();
        }, 300);
    });
    
    // Cancel button functionality
    const cancelButton = modal.querySelector('.btn-cancel');
    cancelButton.addEventListener('click', () => {
        modal.style.display = 'none';
        setTimeout(() => {
            modal.remove();
        }, 300);
    });
    
    // Form submission
    const form = modal.querySelector('#new-job-form');
    form.addEventListener('submit', async (event) => {
        event.preventDefault();
        
        // Collect form data
        const formData = new FormData(form);
        const jobData = {
            title: formData.get('title'),
            description: formData.get('description'),
            budget: formData.get('budget'),
            skills: formData.get('skills'),
            location: formData.get('location'),
            deadline: formData.get('deadline') || null,
            client_id: currentUser.id,
            currency: currentUser.currency
        };
        
        try {
            // Submit the new job
            const response = await fetch('/jobs', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(jobData)
            });
            
            if (!response.ok) {
                throw new Error(`Error: ${response.status}`);
            }
            
            const newJob = await response.json();
            
            // Add the new job to our userJobs array
            userJobs.push(newJob);
            
            // Refresh the client's job list
            displayClientJobs(userJobs);
            
            // Close the modal
            modal.style.display = 'none';
            setTimeout(() => {
                modal.remove();
            }, 300);
            
            // Show success message
            showNotification('Job posted successfully!', 'success');
        } catch (error) {
            console.error('Failed to post job:', error);
            showNotification('Failed to post job. Please try again.', 'error');
        }
    });
}

// Display edit job form for clients
function showEditJobForm(job) {
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Edit Job</h2>
            <form id="edit-job-form">
                <div class="form-group">
                    <label for="job-title">Job Title</label>
                    <input type="text" id="job-title" name="title" required value="${job.title}">
                </div>
                
                <div class="form-group">
                    <label for="job-description">Description</label>
                    <textarea id="job-description" name="description" rows="6" required>${job.description}</textarea>
                </div>
                
                <div class="form-group">
                    <label for="job-budget">Budget (${currentUser.currency})</label>
                    <input type="number" id="job-budget" name="budget" required min="1" value="${job.budget}">
                </div>
                
                <div class="form-group">
                    <label for="job-skills">Required Skills (comma separated)</label>
                    <input type="text" id="job-skills" name="skills" required value="${Array.isArray(job.skills) ? job.skills.join(', ') : job.skills}">
                </div>
                
                <div class="form-group">
                    <label for="job-location">Location</label>
                    <input type="text" id="job-location" name="location" required value="${job.location}">
                </div>
                
                <div class="form-group">
                    <label for="job-status">Status</label>
                    <select id="job-status" name="status" required>
                        <option value="OPEN" ${job.status === 'OPEN' ? 'selected' : ''}>Open</option>
                        <option value="IN_PROGRESS" ${job.status === 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                        <option value="COMPLETED" ${job.status === 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        <option value="CANCELED" ${job.status === 'CANCELED' ? 'selected' : ''}>Canceled</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="job-deadline">Deadline (optional)</label>
                    <input type="date" id="job-deadline" name="deadline" value="${job.deadline || ''}">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update Job</button>
                    <button type="button" class="btn btn-tertiary btn-cancel">Cancel</button>
                </div>
            </form>
        </div>
    `;
    
    // Add modal to the document body
    document.body.appendChild(modal);
    
    // Show the modal
    setTimeout(() => {
        modal.style.display = 'block';
    }, 10);
    
    // Close button functionality
    const closeButton = modal.querySelector('.close');
    closeButton.addEventListener('click', () => {
        modal.style.display = 'none';
        setTimeout(() => {
            modal.remove();
        }, 300);
    });
    
    // Cancel button functionality
    const cancelButton = modal.querySelector('.btn-cancel');
    cancelButton.addEventListener('click', () => {
        modal.style.display = 'none';
        setTimeout(() => {
            modal.remove();
        }, 300);
    });
    
    // Form submission
    const form = modal.querySelector('#edit-job-form');
    form.addEventListener('submit', async (event) => {
        event.preventDefault();
        
        // Collect form data
        const formData = new FormData(form);
        const jobData = {
            title: formData.get('title'),
            description: formData.get('description'),
            budget: formData.get('budget'),
            skills: formData.get('skills'),
            location: formData.get('location'),
            status: formData.get('status'),
            deadline: formData.get('deadline') || null
        };
        
        try {
            // Submit the job update
            const response = await fetch(`/jobs/${job.id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(jobData)
            });
            
            if (!response.ok) {
                throw new Error(`Error: ${response.status}`);
            }
            
            const updatedJob = await response.json();
            
            // Update the job in our userJobs array
            const index = userJobs.findIndex(j => j.id === job.id);
            if (index !== -1) {
                userJobs[index] = updatedJob;
            }
            
            // Refresh the client's job list
            displayClientJobs(userJobs);
            
            // Close the modal
            modal.style.display = 'none';
            setTimeout(() => {
                modal.remove();
            }, 300);
            
            // Show success message
            showNotification('Job updated successfully!', 'success');
        } catch (error) {
            console.error('Failed to update job:', error);
            showNotification('Failed to update job. Please try again.', 'error');
        }
    });
}

// Apply for a job (freelancer)
async function applyForJob(jobId) {
    // In a real application, we would submit an application to the server
    // For now, we'll just show a success message
    showNotification('Application submitted successfully!', 'success');
    
    // TODO: Implement actual application submission when the API is ready
}

// Set up event listeners
function setupEventListeners() {
    // Logout button
    const logoutButton = document.getElementById('logout-btn');
    if (logoutButton) {
        logoutButton.addEventListener('click', () => {
            // Clear localStorage
            localStorage.clear();
            // Redirect to login page
            window.location.href = 'login.html';
        });
    }
    
    // Post new job button (for clients)
    const newJobButton = document.getElementById('new-job-btn');
    if (newJobButton) {
        newJobButton.addEventListener('click', showNewJobForm);
    }
    
    // Delegate for job cards (view details, edit, apply)
    document.addEventListener('click', (event) => {
        // View job details
        if (event.target.classList.contains('btn-view-job')) {
            const jobId = event.target.dataset.jobId;
            displayJobDetails(jobId);
        }
        
        // Edit job (client)
        if (event.target.classList.contains('btn-edit-job')) {
            const jobId = event.target.dataset.jobId;
            const job = userJobs.find(job => job.id === jobId);
            if (job) {
                showEditJobForm(job);
            }
        }
        
        // Apply for job (freelancer)
        if (event.target.classList.contains('btn-apply-job')) {
            const jobId = event.target.dataset.jobId;
            applyForJob(jobId);
        }
    });
    
    // Search functionality
    const searchForm = document.getElementById('search-form');
    if (searchForm) {
        searchForm.addEventListener('submit', (event) => {
            event.preventDefault();
            const searchInput = document.getElementById('search-input');
            const query = searchInput.value.trim();
            
            if (!query) {
                // If search is empty, show all jobs
                if (currentUser.userType === 'freelancer') {
                    displayAvailableJobs(allJobs);
                } else {
                    displayClientJobs(userJobs);
                }
                return;
            }
            
            // Filter jobs based on search query
            const filteredJobs = currentUser.userType === 'freelancer' ? 
                allJobs.filter(job => searchJob(job, query)) : 
                userJobs.filter(job => searchJob(job, query));
            
            // Display filtered jobs
            if (currentUser.userType === 'freelancer') {
                displayAvailableJobs(filteredJobs);
            } else {
                displayClientJobs(filteredJobs);
            }
        });
    }
}

// Search job based on query
function searchJob(job, query) {
    const lowerQuery = query.toLowerCase();
    return (
        job.title.toLowerCase().includes(lowerQuery) ||
        job.description.toLowerCase().includes(lowerQuery) ||
        job.location.toLowerCase().includes(lowerQuery) ||
        (Array.isArray(job.skills) && job.skills.some(skill => skill.toLowerCase().includes(lowerQuery)))
    );
}

// Display error message
function displayError(containerId, message) {
    const container = document.getElementById(containerId);
    if (container) {
        container.innerHTML = `<div class="error-message">${message}</div>`;
    }
}

// Show notification
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Show notification
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);
    
    // Hide and remove notification after 3 seconds
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// Load freelancer's active jobs
function loadFreelancerJobs() {
    // In a real app, we would fetch the freelancer's applications
    // For now, we'll use a placeholder
    const container = document.getElementById('active-jobs');
    if (container) {
        container.innerHTML = '<div class="empty-state">You haven\'t applied for any jobs yet. Browse available jobs to get started.</div>';
    }
}