<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickhire.model.User" %>
<%@ page import="com.quickhire.model.Job" %>
<%@ page import="com.quickhire.model.JobApplication" %>
<%@ page import="com.quickhire.dao.JobDAO" %>
<%@ page import="com.quickhire.dao.JobApplicationDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.UUID" %>

<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !currentUser.isFreelancer()) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user's applications
    JobApplicationDAO applicationDAO = new JobApplicationDAO();
    List<JobApplication> userApplications = applicationDAO.findByFreelancerId(currentUser.getId());
    
    // Get open jobs for recommendations
    JobDAO jobDAO = new JobDAO();
    List<Job> openJobs = jobDAO.findByStatus("open");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Freelancer Dashboard - QuickHire</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --secondary: #4cc9f0;
            --accent: #f72585;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
            --success: #4caf50;
            --warning: #ff9800;
            --danger: #f44336;
            --border-radius: 8px;
            --box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--dark);
            background-color: #f0f2f5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .container {
            width: 95%;
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 15px;
        }
        
        /* Header */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
        }
        
        .logo i {
            margin-right: 0.5rem;
        }
        
        .nav-links {
            display: flex;
            align-items: center;
        }
        
        .nav-links a {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: var(--transition);
            border-radius: var(--border-radius);
        }
        
        .nav-links a:hover {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }
        
        .nav-links a.active {
            background-color: var(--primary);
            color: white;
        }
        
        .user-menu {
            position: relative;
        }
        
        .user-button {
            background: none;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            color: var(--dark);
            padding: 0.5rem 1rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }
        
        .user-button:hover {
            background-color: rgba(67, 97, 238, 0.1);
        }
        
        .user-button img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            width: 200px;
            padding: 0.5rem 0;
            display: none;
            z-index: 1000;
        }
        
        .dropdown-menu.show {
            display: block;
        }
        
        .dropdown-menu a, .dropdown-menu button {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            text-decoration: none;
            color: var(--dark);
            transition: var(--transition);
            width: 100%;
            text-align: left;
            border: none;
            background: none;
            font-size: 1rem;
            cursor: pointer;
        }
        
        .dropdown-menu a:hover, .dropdown-menu button:hover {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }
        
        .dropdown-menu hr {
            margin: 0.5rem 0;
            border: none;
            border-top: 1px solid #eee;
        }
        
        /* Dashboard layout */
        .dashboard {
            display: flex;
            flex: 1;
        }
        
        .sidebar {
            width: 250px;
            background-color: white;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            padding: 2rem 0;
            position: sticky;
            top: 70px;
            height: calc(100vh - 70px);
            overflow-y: auto;
        }
        
        .sidebar-links {
            list-style: none;
        }
        
        .sidebar-links li {
            margin-bottom: 0.5rem;
        }
        
        .sidebar-links a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1.5rem;
            text-decoration: none;
            color: var(--dark);
            transition: var(--transition);
            border-left: 3px solid transparent;
            font-weight: 500;
        }
        
        .sidebar-links a:hover {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left-color: var(--primary);
        }
        
        .sidebar-links a.active {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left-color: var(--primary);
            font-weight: 600;
        }
        
        .main-content {
            flex: 1;
            padding: 2rem;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        
        .greeting h1 {
            font-size: 1.8rem;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }
        
        .greeting p {
            color: var(--gray);
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.6rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
        }
        
        .btn-outline {
            background-color: transparent;
            border: 2px solid var(--primary);
            color: var(--primary);
        }
        
        .btn-outline:hover {
            background-color: var(--primary);
            color: white;
        }
        
        /* Dashboard widgets */
        .dashboard-widgets {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .widget {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            transition: var(--transition);
        }
        
        .widget:hover {
            transform: translateY(-5px);
        }
        
        .widget-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .widget-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
        }
        
        .widget-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }
        
        .bg-primary {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }
        
        .bg-success {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--success);
        }
        
        .bg-warning {
            background-color: rgba(255, 152, 0, 0.1);
            color: var(--warning);
        }
        
        .widget-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .widget-description {
            color: var(--gray);
            font-size: 0.9rem;
        }
        
        /* Jobs section */
        .jobs-section {
            margin-bottom: 2rem;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark);
        }
        
        .job-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }
        
        .job-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            transition: var(--transition);
            border-left: 4px solid var(--primary);
        }
        
        .job-card:hover {
            transform: translateY(-5px);
        }
        
        .job-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }
        
        .job-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }
        
        .job-company {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .job-status {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-open {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--success);
        }
        
        .status-pending {
            background-color: rgba(255, 152, 0, 0.1);
            color: var(--warning);
        }
        
        .status-accepted {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--success);
        }
        
        .status-rejected {
            background-color: rgba(244, 67, 54, 0.1);
            color: var(--danger);
        }
        
        .job-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .job-detail {
            display: flex;
            flex-direction: column;
        }
        
        .job-detail-label {
            font-size: 0.85rem;
            color: var(--gray);
            margin-bottom: 0.2rem;
        }
        
        .job-detail-value {
            font-weight: 600;
        }
        
        .job-description {
            color: var(--gray);
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .job-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .job-meta {
            font-size: 0.85rem;
            color: var(--gray);
        }
        
        /* Responsive design */
        @media (max-width: 992px) {
            .dashboard {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                height: auto;
                position: static;
                padding: 1rem 0;
            }
            
            .sidebar-links {
                display: flex;
                flex-wrap: wrap;
                padding: 0 1rem;
            }
            
            .sidebar-links li {
                margin-right: 0.5rem;
                margin-bottom: 0.5rem;
            }
            
            .sidebar-links a {
                padding: 0.5rem 1rem;
                border-left: none;
                border-radius: var(--border-radius);
            }
            
            .sidebar-links a.active {
                border-left: none;
            }
            
            .main-content {
                padding: 1.5rem;
            }
            
            .dashboard-widgets, .job-cards {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .header-container {
                flex-wrap: wrap;
            }
            
            .nav-links {
                order: 3;
                width: 100%;
                margin-top: 1rem;
                justify-content: space-between;
            }
            
            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .action-buttons {
                width: 100%;
            }
            
            .btn {
                flex: 1;
                text-align: center;
                padding: 0.75rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container header-container">
            <a href="index.jsp" class="logo"><i class="fas fa-bolt"></i> QuickHire</a>
            
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="find-jobs.jsp">Find Jobs</a>
                <a href="messages.jsp">Messages</a>
                <a href="about-us.jsp">About Us</a>
            </div>
            
            <div class="user-menu">
                <button class="user-button" id="userMenuButton">
                    <img src="https://ui-avatars.com/api/?name=<%= currentUser.getFirstName() %>+<%= currentUser.getLastName() %>&background=4361ee&color=fff" alt="User Avatar">
                    <span><%= currentUser.getFirstName() %></span>
                    <i class="fas fa-chevron-down"></i>
                </button>
                
                <div class="dropdown-menu" id="userDropdown">
                    <a href="freelancer-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                    <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
                    <a href="my-applications.jsp"><i class="fas fa-file-alt"></i> My Applications</a>
                    <a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a>
                    <hr>
                    <form action="logout" method="post">
                        <button type="submit"><i class="fas fa-sign-out-alt"></i> Log Out</button>
                    </form>
                </div>
            </div>
        </div>
    </header>
    
    <!-- Dashboard -->
    <div class="dashboard">
        <!-- Sidebar -->
        <aside class="sidebar">
            <ul class="sidebar-links">
                <li><a href="freelancer-dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="find-jobs.jsp"><i class="fas fa-search"></i> Find Jobs</a></li>
                <li><a href="my-applications.jsp"><i class="fas fa-file-alt"></i> My Applications</a></li>
                <li><a href="contracts.jsp"><i class="fas fa-file-contract"></i> Contracts</a></li>
                <li><a href="messages.jsp"><i class="fas fa-envelope"></i> Messages</a></li>
                <li><a href="earnings.jsp"><i class="fas fa-dollar-sign"></i> Earnings</a></li>
                <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                <li><a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
            </ul>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <div class="dashboard-header">
                <div class="greeting">
                    <h1>Welcome back, <%= currentUser.getFirstName() %>!</h1>
                    <p>Here's an overview of your freelancing activity</p>
                </div>
                
                <div class="action-buttons">
                    <a href="find-jobs.jsp" class="btn btn-primary"><i class="fas fa-search"></i> Find Jobs</a>
                    <a href="profile.jsp" class="btn btn-outline"><i class="fas fa-user"></i> Update Profile</a>
                </div>
            </div>
            
            <!-- Dashboard Widgets -->
            <div class="dashboard-widgets">
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Applications</h3>
                        <div class="widget-icon bg-primary">
                            <i class="fas fa-file-alt"></i>
                        </div>
                    </div>
                    <div class="widget-value"><%= userApplications.size() %></div>
                    <p class="widget-description">Total job applications</p>
                </div>
                
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Active Contracts</h3>
                        <div class="widget-icon bg-success">
                            <i class="fas fa-file-contract"></i>
                        </div>
                    </div>
                    <div class="widget-value">2</div>
                    <p class="widget-description">Current projects in progress</p>
                </div>
                
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Earnings</h3>
                        <div class="widget-icon bg-warning">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>
                    <div class="widget-value">$3,250</div>
                    <p class="widget-description">Total earnings this month</p>
                </div>
            </div>
            
            <!-- My Applications -->
            <div class="jobs-section">
                <div class="section-header">
                    <h2 class="section-title">Recent Applications</h2>
                    <a href="my-applications.jsp" class="btn btn-outline">View All</a>
                </div>
                
                <div class="job-cards">
                    <% if (userApplications.isEmpty()) { %>
                        <p>You haven't applied to any jobs yet. <a href="find-jobs.jsp">Start applying now</a></p>
                    <% } else { 
                        // Display up to 3 most recent applications
                        int count = 0;
                        for (JobApplication application : userApplications) {
                            if (count++ >= 3) break;
                            
                            // Get job details for this application
                            Job job = jobDAO.findById(application.getJobId()).orElse(null);
                            if (job == null) continue;
                    %>
                    <div class="job-card">
                        <div class="job-card-header">
                            <div>
                                <h3 class="job-title"><%= job.getTitle() %></h3>
                            </div>
                            <span class="job-status <%= application.getStatus().equals("pending") ? "status-pending" : (application.getStatus().equals("accepted") ? "status-accepted" : "status-rejected") %>">
                                <%= application.getStatus().replace("_", " ") %>
                            </span>
                        </div>
                        
                        <div class="job-details">
                            <div class="job-detail">
                                <span class="job-detail-label">Proposed Amount</span>
                                <span class="job-detail-value">$<%= application.getProposedAmount() %></span>
                            </div>
                            <div class="job-detail">
                                <span class="job-detail-label">Job Budget</span>
                                <span class="job-detail-value">$<%= job.getBudget() %> <%= job.getBudgetType() %></span>
                            </div>
                            <div class="job-detail">
                                <span class="job-detail-label">Category</span>
                                <span class="job-detail-value"><%= job.getCategory() %></span>
                            </div>
                            <div class="job-detail">
                                <span class="job-detail-label">Applied On</span>
                                <span class="job-detail-value"><%= java.time.format.DateTimeFormatter.ofPattern("MMM d, yyyy").format(application.getCreatedAt().toLocalDateTime()) %></span>
                            </div>
                        </div>
                        
                        <div class="job-footer">
                            <span class="job-meta">Applied <%= java.time.format.DateTimeFormatter.ofPattern("MMM d, yyyy").format(application.getCreatedAt().toLocalDateTime()) %></span>
                            <a href="job-detail.jsp?id=<%= job.getId() %>" class="btn btn-outline">View Job</a>
                        </div>
                    </div>
                    <% }
                    } %>
                </div>
            </div>
            
            <!-- Recommended Jobs -->
            <div class="jobs-section">
                <div class="section-header">
                    <h2 class="section-title">Recommended Jobs</h2>
                    <a href="find-jobs.jsp" class="btn btn-outline">View All Jobs</a>
                </div>
                
                <div class="job-cards">
                    <% if (openJobs.isEmpty()) { %>
                        <p>No open jobs available at the moment. Check back later!</p>
                    <% } else { 
                        // Display up to 3 open jobs as recommendations
                        int count = 0;
                        for (Job job : openJobs) {
                            if (count++ >= 3) break;
                    %>
                    <div class="job-card">
                        <div class="job-card-header">
                            <div>
                                <h3 class="job-title"><%= job.getTitle() %></h3>
                            </div>
                            <span class="job-status status-open">Open</span>
                        </div>
                        
                        <div class="job-details">
                            <div class="job-detail">
                                <span class="job-detail-label">Budget</span>
                                <span class="job-detail-value">$<%= job.getBudget() %> <%= job.getBudgetType() %></span>
                            </div>
                            <div class="job-detail">
                                <span class="job-detail-label">Duration</span>
                                <span class="job-detail-value"><%= job.getDuration() %></span>
                            </div>
                            <div class="job-detail">
                                <span class="job-detail-label">Category</span>
                                <span class="job-detail-value"><%= job.getCategory() %></span>
                            </div>
                            <div class="job-detail">
                                <span class="job-detail-label">Experience</span>
                                <span class="job-detail-value"><%= job.getExperienceLevel() %></span>
                            </div>
                        </div>
                        
                        <div class="job-description">
                            <%= job.getDescription() %>
                        </div>
                        
                        <div class="job-footer">
                            <span class="job-meta">Posted <%= java.time.format.DateTimeFormatter.ofPattern("MMM d, yyyy").format(job.getCreatedAt().toLocalDateTime()) %></span>
                            <a href="job-detail.jsp?id=<%= job.getId() %>" class="btn btn-outline">Apply Now</a>
                        </div>
                    </div>
                    <% }
                    } %>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        // User dropdown menu
        const userMenuButton = document.getElementById('userMenuButton');
        const userDropdown = document.getElementById('userDropdown');
        
        userMenuButton.addEventListener('click', function() {
            userDropdown.classList.toggle('show');
        });
        
        // Close dropdown when clicking outside
        window.addEventListener('click', function(event) {
            if (!userMenuButton.contains(event.target) && !userDropdown.contains(event.target)) {
                userDropdown.classList.remove('show');
            }
        });
        
        console.log("Freelancer dashboard loaded successfully");
    </script>
</body>
</html>