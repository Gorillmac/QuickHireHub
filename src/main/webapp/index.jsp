<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickhire.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickHire - Connect with Top Freelancers</title>
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
        
        /* Hero section */
        .hero {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: white;
            padding: 5rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        
        .hero::after {
            content: '';
            position: absolute;
            bottom: -50px;
            left: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        
        .hero-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
            position: relative;
            z-index: 2;
        }
        
        .hero-content h1 {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1.5rem;
        }
        
        .hero-content p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .cta-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 1rem;
        }
        
        .btn-light {
            background-color: white;
            color: var(--primary);
        }
        
        .btn-light:hover {
            background-color: var(--light);
            transform: translateY(-3px);
        }
        
        .btn-outline-light {
            background-color: transparent;
            border: 2px solid white;
            color: white;
        }
        
        .btn-outline-light:hover {
            background-color: rgba(255, 255, 255, 0.1);
            transform: translateY(-3px);
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            transform: translateY(-3px);
        }
        
        .btn-outline {
            background-color: transparent;
            border: 2px solid var(--primary);
            color: var(--primary);
        }
        
        .btn-outline:hover {
            background-color: var(--primary);
            color: white;
            transform: translateY(-3px);
        }
        
        .hero-image {
            position: relative;
        }
        
        .hero-image img {
            width: 100%;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            margin-top: 2rem;
        }
        
        .stat-item {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            border-radius: var(--border-radius);
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }
        
        /* Features section */
        .features {
            padding: 5rem 0;
            background-color: var(--light);
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }
        
        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 1rem;
        }
        
        .section-subtitle {
            font-size: 1.2rem;
            color: var(--gray);
            max-width: 700px;
            margin: 0 auto;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .feature-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 2rem;
            transition: var(--transition);
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
        }
        
        .feature-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-radius: 12px;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark);
        }
        
        .feature-description {
            color: var(--gray);
            margin-bottom: 1.5rem;
        }
        
        .feature-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary);
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .feature-link:hover {
            color: var(--primary-dark);
            gap: 0.75rem;
        }
        
        /* How it works */
        .how-it-works {
            padding: 5rem 0;
        }
        
        .steps-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .step-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 2rem;
            position: relative;
            text-align: center;
            transition: var(--transition);
        }
        
        .step-card:hover {
            transform: translateY(-10px);
        }
        
        .step-number {
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            width: 40px;
            height: 40px;
            background-color: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.2rem;
        }
        
        .step-icon {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }
        
        .step-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark);
        }
        
        .step-description {
            color: var(--gray);
        }
        
        /* Categories */
        .categories {
            padding: 5rem 0;
            background-color: var(--light);
        }
        
        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 3rem;
        }
        
        .category-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
            transition: var(--transition);
        }
        
        .category-card:hover {
            transform: translateY(-5px);
        }
        
        .category-image {
            height: 150px;
            background-size: cover;
            background-position: center;
        }
        
        .category-content {
            padding: 1.5rem;
        }
        
        .category-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark);
        }
        
        .category-count {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        /* CTA section */
        .cta-section {
            background: linear-gradient(135deg, #f72585 0%, #7209b7 100%);
            color: white;
            padding: 5rem 0;
            text-align: center;
        }
        
        .cta-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .cta-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }
        
        .cta-subtitle {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        /* Footer */
        footer {
            background-color: white;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
            padding: 4rem 0 2rem;
        }
        
        .footer-grid {
            display: grid;
            grid-template-columns: 2fr repeat(3, 1fr);
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .footer-brand {
            display: flex;
            flex-direction: column;
        }
        
        .footer-logo {
            display: flex;
            align-items: center;
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--primary);
            margin-bottom: 1rem;
            gap: 0.5rem;
        }
        
        .footer-description {
            color: var(--gray);
            margin-bottom: 1.5rem;
        }
        
        .social-links {
            display: flex;
            gap: 1rem;
        }
        
        .social-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-radius: 50%;
            transition: var(--transition);
            text-decoration: none;
        }
        
        .social-link:hover {
            background-color: var(--primary);
            color: white;
            transform: translateY(-3px);
        }
        
        .footer-heading {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 1.5rem;
        }
        
        .footer-links {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }
        
        .footer-link {
            color: var(--gray);
            text-decoration: none;
            transition: var(--transition);
        }
        
        .footer-link:hover {
            color: var(--primary);
            padding-left: 5px;
        }
        
        .footer-bottom {
            padding-top: 2rem;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: var(--gray);
            font-size: 0.9rem;
        }
        
        .footer-bottom-links a {
            color: var(--gray);
            text-decoration: none;
            margin-left: 1.5rem;
            transition: var(--transition);
        }
        
        .footer-bottom-links a:hover {
            color: var(--primary);
        }
        
        /* Responsive Design */
        @media (max-width: 1100px) {
            .hero-content h1 {
                font-size: 2.5rem;
            }
            
            .footer-grid {
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
            }
        }
        
        @media (max-width: 900px) {
            .hero-container {
                grid-template-columns: 1fr;
                text-align: center;
                gap: 2rem;
            }
            
            .cta-buttons {
                justify-content: center;
            }
            
            .stats-container {
                grid-template-columns: 1fr 1fr 1fr;
            }
            
            .hero-image {
                order: -1;
                max-width: 500px;
                margin: 0 auto;
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
                justify-content: center;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .footer-bottom {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .footer-bottom-links {
                margin-top: 1rem;
            }
            
            .footer-bottom-links a {
                margin: 0 0.5rem;
            }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("user");
    %>
    
    <!-- Header -->
    <header>
        <div class="container header-container">
            <a href="index.jsp" class="logo"><i class="fas fa-bolt"></i> QuickHire</a>
            
            <div class="nav-links">
                <a href="index.jsp" class="active">Home</a>
                <a href="find-jobs.jsp">Find Jobs</a>
                <a href="find-talent.jsp">Find Talent</a>
                <a href="about-us.jsp">About Us</a>
                <a href="contact.jsp">Contact</a>
            </div>
            
            <% if (currentUser != null) { %>
                <!-- User is logged in -->
                <div class="user-menu">
                    <button class="user-button" id="userMenuButton">
                        <img src="https://ui-avatars.com/api/?name=<%= currentUser.getFirstName() %>+<%= currentUser.getLastName() %>&background=4361ee&color=fff" alt="User Avatar">
                        <span><%= currentUser.getFirstName() %></span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    
                    <div class="dropdown-menu" id="userDropdown">
                        <% if (currentUser.isFreelancer()) { %>
                            <a href="freelancer-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                            <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
                            <a href="my-applications.jsp"><i class="fas fa-file-alt"></i> My Applications</a>
                        <% } else { %>
                            <a href="client-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                            <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
                            <a href="my-jobs.jsp"><i class="fas fa-briefcase"></i> My Jobs</a>
                        <% } %>
                        <a href="messages.jsp"><i class="fas fa-envelope"></i> Messages</a>
                        <a href="settings.jsp"><i class="fas fa-cog"></i> Settings</a>
                        <hr>
                        <form action="logout" method="post">
                            <button type="submit"><i class="fas fa-sign-out-alt"></i> Log Out</button>
                        </form>
                    </div>
                </div>
            <% } else { %>
                <!-- User is not logged in -->
                <div class="nav-links">
                    <a href="login.jsp">Log In</a>
                    <a href="register.jsp">Sign Up</a>
                </div>
            <% } %>
        </div>
    </header>
    
    <!-- Hero Section -->
    <section class="hero">
        <div class="container hero-container">
            <div class="hero-content">
                <h1>Connect with the best freelance talent</h1>
                <p>QuickHire makes it easy to find and hire top freelancers for any project. Post a job or browse profiles to get started.</p>
                
                <div class="cta-buttons">
                    <a href="register.jsp?userType=client" class="btn btn-light">Post a Job</a>
                    <a href="register.jsp?userType=freelancer" class="btn btn-outline-light">Find Work</a>
                </div>
                
                <div class="stats-container">
                    <div class="stat-item">
                        <div class="stat-number">10K+</div>
                        <div class="stat-label">Active Freelancers</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">5K+</div>
                        <div class="stat-label">Open Jobs</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">95%</div>
                        <div class="stat-label">Satisfaction Rate</div>
                    </div>
                </div>
            </div>
            
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1471&q=80" alt="Team collaborating on a project">
            </div>
        </div>
    </section>
    
    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Why Choose QuickHire?</h2>
                <p class="section-subtitle">Our platform provides everything you need to connect with talent and complete your projects successfully.</p>
            </div>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <h3 class="feature-title">Verified Talent</h3>
                    <p class="feature-description">Our rigorous verification process ensures you're working with qualified professionals who have the skills they claim.</p>
                    <a href="about-us.jsp" class="feature-link">Learn More <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3 class="feature-title">Secure Payments</h3>
                    <p class="feature-description">Our escrow system protects both parties, releasing payment only when work is completed to satisfaction.</p>
                    <a href="how-it-works.jsp" class="feature-link">Learn More <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3 class="feature-title">Seamless Communication</h3>
                    <p class="feature-description">Our integrated messaging system makes collaboration easy with real-time updates and file sharing.</p>
                    <a href="features.jsp" class="feature-link">Learn More <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-tasks"></i>
                    </div>
                    <h3 class="feature-title">Project Management</h3>
                    <p class="feature-description">Track progress, manage milestones, and stay organized with our intuitive project tools.</p>
                    <a href="features.jsp" class="feature-link">Learn More <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3 class="feature-title">Ratings & Reviews</h3>
                    <p class="feature-description">Make informed decisions based on detailed feedback from previous clients and freelancers.</p>
                    <a href="how-it-works.jsp" class="feature-link">Learn More <i class="fas fa-arrow-right"></i></a>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3 class="feature-title">24/7 Support</h3>
                    <p class="feature-description">Our dedicated team is always available to help resolve any issues that may arise during your project.</p>
                    <a href="contact.jsp" class="feature-link">Learn More <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- How It Works -->
    <section class="how-it-works">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">How QuickHire Works</h2>
                <p class="section-subtitle">Getting started is simple. Follow these steps to post a job or find work on our platform.</p>
            </div>
            
            <div class="steps-container">
                <div class="step-card">
                    <div class="step-number">1</div>
                    <div class="step-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h3 class="step-title">Create an Account</h3>
                    <p class="step-description">Sign up as a client or freelancer to access our platform's features.</p>
                </div>
                
                <div class="step-card">
                    <div class="step-number">2</div>
                    <div class="step-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                    <h3 class="step-title">Complete Your Profile</h3>
                    <p class="step-description">Add your skills, experience, and portfolio to stand out.</p>
                </div>
                
                <div class="step-card">
                    <div class="step-number">3</div>
                    <div class="step-icon">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <h3 class="step-title">Post or Find Jobs</h3>
                    <p class="step-description">Create detailed job listings or browse available opportunities.</p>
                </div>
                
                <div class="step-card">
                    <div class="step-number">4</div>
                    <div class="step-icon">
                        <i class="fas fa-handshake"></i>
                    </div>
                    <h3 class="step-title">Collaborate & Complete</h3>
                    <p class="step-description">Work together efficiently and get paid securely through our platform.</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Categories -->
    <section class="categories">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Popular Categories</h2>
                <p class="section-subtitle">Explore top categories to find the perfect freelancer or project for your skills.</p>
            </div>
            
            <div class="categories-grid">
                <div class="category-card">
                    <div class="category-image" style="background-image: url('https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1472&q=80');"></div>
                    <div class="category-content">
                        <h3 class="category-title">Web Development</h3>
                        <p class="category-count">1,250+ jobs available</p>
                        <a href="find-jobs.jsp?category=web-development" class="btn btn-outline">Browse Jobs</a>
                    </div>
                </div>
                
                <div class="category-card">
                    <div class="category-image" style="background-image: url('https://images.unsplash.com/photo-1561070791-2526d30994b5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1528&q=80');"></div>
                    <div class="category-content">
                        <h3 class="category-title">Graphic Design</h3>
                        <p class="category-count">940+ jobs available</p>
                        <a href="find-jobs.jsp?category=graphic-design" class="btn btn-outline">Browse Jobs</a>
                    </div>
                </div>
                
                <div class="category-card">
                    <div class="category-image" style="background-image: url('https://images.unsplash.com/photo-1533750516457-a7f992034fec?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1506&q=80');"></div>
                    <div class="category-content">
                        <h3 class="category-title">Digital Marketing</h3>
                        <p class="category-count">820+ jobs available</p>
                        <a href="find-jobs.jsp?category=digital-marketing" class="btn btn-outline">Browse Jobs</a>
                    </div>
                </div>
                
                <div class="category-card">
                    <div class="category-image" style="background-image: url('https://images.unsplash.com/photo-1580927752452-89d86da3fa0a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80');"></div>
                    <div class="category-content">
                        <h3 class="category-title">Content Writing</h3>
                        <p class="category-count">760+ jobs available</p>
                        <a href="find-jobs.jsp?category=content-writing" class="btn btn-outline">Browse Jobs</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container cta-container">
            <h2 class="cta-title">Ready to get started?</h2>
            <p class="cta-subtitle">Join thousands of freelancers and clients who trust QuickHire for their projects.</p>
            <div class="cta-buttons">
                <a href="register.jsp" class="btn btn-light">Create Account</a>
                <a href="how-it-works.jsp" class="btn btn-outline-light">Learn More</a>
            </div>
        </div>
    </section>
    
    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-grid">
                <div class="footer-brand">
                    <div class="footer-logo">
                        <i class="fas fa-bolt"></i>
                        <span>QuickHire</span>
                    </div>
                    <p class="footer-description">
                        QuickHire connects businesses with the best freelance talent for any project, budget, or timeline.
                    </p>
                    <div class="social-links">
                        <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
                
                <div class="footer-links-column">
                    <h3 class="footer-heading">For Clients</h3>
                    <div class="footer-links">
                        <a href="find-talent.jsp" class="footer-link">Find Talent</a>
                        <a href="post-job.jsp" class="footer-link">Post a Job</a>
                        <a href="client-how-it-works.jsp" class="footer-link">How It Works</a>
                        <a href="client-success-stories.jsp" class="footer-link">Success Stories</a>
                        <a href="pricing.jsp" class="footer-link">Pricing</a>
                    </div>
                </div>
                
                <div class="footer-links-column">
                    <h3 class="footer-heading">For Freelancers</h3>
                    <div class="footer-links">
                        <a href="find-jobs.jsp" class="footer-link">Find Jobs</a>
                        <a href="create-profile.jsp" class="footer-link">Create Profile</a>
                        <a href="freelancer-how-it-works.jsp" class="footer-link">How It Works</a>
                        <a href="freelancer-success-stories.jsp" class="footer-link">Success Stories</a>
                        <a href="resources.jsp" class="footer-link">Resources</a>
                    </div>
                </div>
                
                <div class="footer-links-column">
                    <h3 class="footer-heading">Company</h3>
                    <div class="footer-links">
                        <a href="about-us.jsp" class="footer-link">About Us</a>
                        <a href="careers.jsp" class="footer-link">Careers</a>
                        <a href="blog.jsp" class="footer-link">Blog</a>
                        <a href="press.jsp" class="footer-link">Press</a>
                        <a href="contact.jsp" class="footer-link">Contact Us</a>
                    </div>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 QuickHire Inc. All rights reserved.</p>
                
                <div class="footer-bottom-links">
                    <a href="terms.jsp">Terms of Service</a>
                    <a href="privacy.jsp">Privacy Policy</a>
                    <a href="cookies.jsp">Cookie Policy</a>
                    <a href="accessibility.jsp">Accessibility</a>
                </div>
            </div>
        </div>
    </footer>
    
    <script>
        // User dropdown menu
        const userMenuButton = document.getElementById('userMenuButton');
        if (userMenuButton) {
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
        }
    </script>
</body>
</html>