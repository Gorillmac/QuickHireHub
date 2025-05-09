<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            --success: #4caf50;
            --gray: #6c757d;
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
            background-color: #f8f9fa;
        }
        
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
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
            font-size: 1.8rem;
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
            list-style: none;
        }
        
        .nav-links li {
            margin-left: 2rem;
        }
        
        .nav-links a {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: var(--transition);
            padding: 0.5rem 0;
            position: relative;
        }
        
        .nav-links a:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 0;
            background-color: var(--primary);
            transition: var(--transition);
        }
        
        .nav-links a:hover {
            color: var(--primary);
        }
        
        .nav-links a:hover:after {
            width: 100%;
        }
        
        .auth-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            display: inline-block;
            padding: 0.6rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
            border: 2px solid var(--primary);
        }
        
        .btn-outline {
            background-color: transparent;
            color: var(--primary);
            border: 2px solid var(--primary);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        
        .btn-outline:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--dark);
        }
        
        /* Hero Section */
        .hero {
            padding-top: 6rem;
            padding-bottom: 4rem;
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
        }
        
        .hero-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
            padding: 2rem 0;
        }
        
        .hero-content h1 {
            font-size: 3rem;
            line-height: 1.2;
            margin-bottom: 1.5rem;
            color: var(--dark);
        }
        
        .hero-content p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            color: var(--gray);
        }
        
        .hero-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .hero-stats {
            display: flex;
            justify-content: space-between;
            margin-top: 3rem;
            text-align: center;
        }
        
        .stat-item h3 {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        
        .stat-item p {
            font-size: 1rem;
            color: var(--gray);
        }
        
        .hero-image {
            position: relative;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .hero-img {
            max-width: 100%;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        
        /* Features Section */
        .features {
            padding: 5rem 0;
            background-color: white;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .section-title h2 {
            font-size: 2.5rem;
            color: var(--dark);
            margin-bottom: 1rem;
        }
        
        .section-title p {
            font-size: 1.2rem;
            color: var(--gray);
            max-width: 700px;
            margin: 0 auto;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
        }
        
        .feature-card {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
        }
        
        .feature-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background-color: rgba(67, 97, 238, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            font-size: 1.8rem;
            color: var(--primary);
        }
        
        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--dark);
        }
        
        .feature-card p {
            color: var(--gray);
        }
        
        /* How It Works Section */
        .how-it-works {
            padding: 5rem 0;
            background-color: #f8f9fa;
        }
        
        .steps {
            display: flex;
            justify-content: space-between;
            margin-top: 3rem;
            position: relative;
        }
        
        .steps:before {
            content: '';
            position: absolute;
            top: 3.5rem;
            left: 10%;
            width: 80%;
            height: 2px;
            background-color: #e0e0e0;
            z-index: 1;
        }
        
        .step {
            text-align: center;
            position: relative;
            z-index: 2;
            width: 22%;
        }
        
        .step-number {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background-color: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 1.8rem;
            font-weight: 700;
        }
        
        .step h3 {
            font-size: 1.3rem;
            margin-bottom: 1rem;
            color: var(--dark);
        }
        
        .step p {
            color: var(--gray);
            font-size: 0.95rem;
        }
        
        /* CTA Section */
        .cta {
            padding: 5rem 0;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            text-align: center;
        }
        
        .cta h2 {
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
        }
        
        .cta p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 1rem;
        }
        
        .btn-light {
            background-color: white;
            color: var(--primary);
            border: 2px solid white;
        }
        
        .btn-light:hover {
            background-color: transparent;
            color: white;
        }
        
        .btn-outline-light {
            background-color: transparent;
            color: white;
            border: 2px solid white;
        }
        
        .btn-outline-light:hover {
            background-color: white;
            color: var(--primary);
        }
        
        /* Footer */
        footer {
            background-color: var(--dark);
            color: white;
            padding: 4rem 0 2rem;
        }
        
        .footer-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .footer-about h3 {
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .footer-about h3 i {
            margin-right: 0.5rem;
        }
        
        .footer-about p {
            margin-bottom: 1.5rem;
            color: #adb5bd;
        }
        
        .social-links {
            display: flex;
            gap: 1rem;
        }
        
        .social-link {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            transition: var(--transition);
            text-decoration: none;
        }
        
        .social-link:hover {
            background-color: var(--primary);
        }
        
        .footer-links h4 {
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            position: relative;
            padding-bottom: 0.5rem;
        }
        
        .footer-links h4:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 2px;
            background-color: var(--primary);
        }
        
        .footer-links ul {
            list-style: none;
        }
        
        .footer-links li {
            margin-bottom: 0.8rem;
        }
        
        .footer-links a {
            color: #adb5bd;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .footer-links a:hover {
            color: var(--primary);
            padding-left: 5px;
        }
        
        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 2rem;
            text-align: center;
            color: #adb5bd;
        }
        
        .footer-bottom p {
            font-size: 0.9rem;
        }
        
        /* Responsive Design */
        @media (max-width: 992px) {
            .hero-container, .features-grid, .footer-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            .hero-image {
                grid-row: 1;
            }
            
            .hero-content {
                grid-row: 2;
            }
            
            .steps {
                flex-wrap: wrap;
            }
            
            .step {
                width: 45%;
                margin-bottom: 2rem;
            }
            
            .steps:before {
                display: none;
            }
        }
        
        @media (max-width: 768px) {
            .nav-links, .auth-buttons {
                display: none;
            }
            
            .mobile-menu-btn {
                display: block;
            }
            
            .hero-container, .features-grid, .footer-grid {
                grid-template-columns: 1fr;
            }
            
            .hero-stats {
                flex-wrap: wrap;
            }
            
            .stat-item {
                width: 48%;
                margin-bottom: 1.5rem;
            }
            
            .step {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container header-container">
            <a href="#" class="logo"><i class="fas fa-bolt"></i> QuickHire</a>
            
            <ul class="nav-links">
                <li><a href="#">Home</a></li>
                <li><a href="#">Find Jobs</a></li>
                <li><a href="#">Find Talent</a></li>
                <li><a href="#">How It Works</a></li>
                <li><a href="#">About Us</a></li>
            </ul>
            
            <div class="auth-buttons">
                <a href="login.jsp" class="btn btn-outline">Log In</a>
                <a href="register.jsp" class="btn btn-primary">Sign Up</a>
            </div>
            
            <button class="mobile-menu-btn">
                <i class="fas fa-bars"></i>
            </button>
        </div>
    </header>
    
    <!-- Hero Section -->
    <section class="hero">
        <div class="container hero-container">
            <div class="hero-content">
                <h1>Find the Perfect Freelance Match</h1>
                <p>QuickHire connects businesses with skilled freelancers. Post a job or find your next gig today!</p>
                
                <div class="hero-buttons">
                    <a href="register.jsp" class="btn btn-primary">Get Started</a>
                    <a href="#how-it-works" class="btn btn-outline">Learn More</a>
                </div>
                
                <div class="hero-stats">
                    <div class="stat-item">
                        <h3>10k+</h3>
                        <p>Active Freelancers</p>
                    </div>
                    <div class="stat-item">
                        <h3>5k+</h3>
                        <p>Companies</p>
                    </div>
                    <div class="stat-item">
                        <h3>20k+</h3>
                        <p>Completed Jobs</p>
                    </div>
                </div>
            </div>
            
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80" alt="Freelance Team Working" class="hero-img">
            </div>
        </div>
    </section>
    
    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <div class="section-title">
                <h2>Why Choose QuickHire?</h2>
                <p>We make hiring freelancers and finding work simple, efficient, and secure.</p>
            </div>
            
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <h3>Verified Talent</h3>
                    <p>All freelancers are vetted and verified to ensure you get quality work every time.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Secure Payments</h3>
                    <p>Our escrow system ensures that payments are only released when you're satisfied with the work.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3>Easy Communication</h3>
                    <p>Built-in messaging system to discuss project details seamlessly.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <h3>No Hidden Fees</h3>
                    <p>Transparent pricing and payment structure with no surprise charges.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-globe"></i>
                    </div>
                    <h3>Global Talent Pool</h3>
                    <p>Access to freelancers from around the world with diverse skills and experience.</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>Rating System</h3>
                    <p>Find top-rated freelancers based on client reviews and performance history.</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- How It Works Section -->
    <section class="how-it-works" id="how-it-works">
        <div class="container">
            <div class="section-title">
                <h2>How It Works</h2>
                <p>Getting started with QuickHire is easy. Here's how our platform connects talent with opportunities.</p>
            </div>
            
            <div class="steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <h3>Create Account</h3>
                    <p>Sign up as a company or freelancer and complete your profile to get started.</p>
                </div>
                
                <div class="step">
                    <div class="step-number">2</div>
                    <h3>Post Job / Find Work</h3>
                    <p>Companies post jobs, freelancers browse and apply to relevant opportunities.</p>
                </div>
                
                <div class="step">
                    <div class="step-number">3</div>
                    <h3>Collaborate</h3>
                    <p>Discuss project details, timeline, and payment terms before starting work.</p>
                </div>
                
                <div class="step">
                    <div class="step-number">4</div>
                    <h3>Complete & Review</h3>
                    <p>Finalize the project, release payment, and leave feedback for future users.</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- CTA Section -->
    <section class="cta">
        <div class="container">
            <h2>Ready to Get Started?</h2>
            <p>Join thousands of companies and freelancers already using QuickHire to grow their business and career.</p>
            
            <div class="cta-buttons">
                <a href="register.jsp" class="btn btn-light">Sign Up Now</a>
                <a href="login.jsp" class="btn btn-outline-light">Log In</a>
            </div>
        </div>
    </section>
    
    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-grid">
                <div class="footer-about">
                    <h3><i class="fas fa-bolt"></i> QuickHire</h3>
                    <p>The leading platform for connecting skilled freelancers with businesses looking for top talent. Our mission is to make freelancing simple, secure, and successful for everyone.</p>
                    
                    <div class="social-links">
                        <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
                
                <div class="footer-links">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="#">Home</a></li>
                        <li><a href="#">Find Jobs</a></li>
                        <li><a href="#">Find Talent</a></li>
                        <li><a href="#">How It Works</a></li>
                        <li><a href="#">About Us</a></li>
                    </ul>
                </div>
                
                <div class="footer-links">
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Blog</a></li>
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Testimonials</a></li>
                        <li><a href="#">Contact Us</a></li>
                    </ul>
                </div>
                
                <div class="footer-links">
                    <h4>Legal</h4>
                    <ul>
                        <li><a href="#">Terms of Service</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Cookie Policy</a></li>
                        <li><a href="#">Dispute Resolution</a></li>
                        <li><a href="#">Security</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; <%= new java.util.Date().getYear() + 1900 %> QuickHire Inc. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <script>
        // Mobile menu toggle
        document.querySelector('.mobile-menu-btn').addEventListener('click', function() {
            const navLinks = document.querySelector('.nav-links');
            const authButtons = document.querySelector('.auth-buttons');
            
            navLinks.style.display = navLinks.style.display === 'flex' ? 'none' : 'flex';
            authButtons.style.display = authButtons.style.display === 'flex' ? 'none' : 'flex';
            
            if (navLinks.style.display === 'flex') {
                navLinks.style.flexDirection = 'column';
                navLinks.style.position = 'absolute';
                navLinks.style.top = '70px';
                navLinks.style.left = '0';
                navLinks.style.width = '100%';
                navLinks.style.backgroundColor = 'white';
                navLinks.style.padding = '1rem';
                navLinks.style.boxShadow = '0 10px 10px rgba(0, 0, 0, 0.1)';
                
                document.querySelectorAll('.nav-links li').forEach(item => {
                    item.style.margin = '1rem 0';
                });
                
                authButtons.style.flexDirection = 'column';
                authButtons.style.position = 'absolute';
                authButtons.style.top = navLinks.offsetHeight + 70 + 'px';
                authButtons.style.left = '0';
                authButtons.style.width = '100%';
                authButtons.style.backgroundColor = 'white';
                authButtons.style.padding = '1rem';
                authButtons.style.boxShadow = '0 10px 10px rgba(0, 0, 0, 0.1)';
                
                document.querySelectorAll('.auth-buttons a').forEach(item => {
                    item.style.width = '100%';
                    item.style.marginBottom = '0.5rem';
                });
            }
        });
        
        console.log("QuickHire homepage loaded successfully");
    </script>
</body>
</html>
