<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickHire - Connect with Top Freelancers</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <main>
        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <div class="hero-content">
                    <h1>Connect with Top Freelancers and Find Work Opportunities</h1>
                    <p>QuickHire connects businesses with talented freelance professionals. Post a job or find your next gig today!</p>
                    <div class="cta-buttons">
                        <a href="<c:url value='/register.jsp'/>" class="btn btn-primary">Get Started</a>
                        <a href="<c:url value='/jobs'/>" class="btn btn-secondary">Browse Jobs</a>
                    </div>
                </div>
                <div class="hero-image">
                    <img src="https://pixabay.com/get/g080299da35836bcbb761cdb7dc217e5a1f60c3cde92c5d9519b14699d1399a7220463e3407eb5cfe400ddce86f53b66085c69bb568f768075a681219074131c1_1280.jpg" alt="Freelancer working">
                </div>
            </div>
        </section>
        
        <!-- How It Works -->
        <section class="how-it-works">
            <div class="container">
                <h2 class="section-title">How It Works</h2>
                <div class="steps">
                    <div class="step">
                        <div class="step-icon">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <h3>Create an Account</h3>
                        <p>Sign up as a company looking to hire or as a freelancer looking for work.</p>
                    </div>
                    <div class="step">
                        <div class="step-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h3>Post or Find Jobs</h3>
                        <p>Companies post jobs, freelancers find opportunities that match their skills.</p>
                    </div>
                    <div class="step">
                        <div class="step-icon">
                            <i class="fas fa-handshake"></i>
                        </div>
                        <h3>Connect and Collaborate</h3>
                        <p>Apply for jobs, hire talent, and communicate securely on our platform.</p>
                    </div>
                    <div class="step">
                        <div class="step-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <h3>Review and Grow</h3>
                        <p>Build your reputation with reviews and grow your business or career.</p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Featured Jobs -->
        <section class="featured-jobs">
            <div class="container">
                <h2 class="section-title">Featured Job Opportunities</h2>
                <div class="job-cards">
                    <div class="job-card">
                        <div class="job-card-header">
                            <h3>Web Developer</h3>
                            <span class="job-type">Remote</span>
                        </div>
                        <div class="job-card-body">
                            <p class="job-company">Tech Innovations Inc.</p>
                            <p class="job-description">Looking for a skilled web developer to create a responsive e-commerce website.</p>
                            <div class="job-tags">
                                <span>HTML</span>
                                <span>CSS</span>
                                <span>JavaScript</span>
                                <span>React</span>
                            </div>
                        </div>
                        <div class="job-card-footer">
                            <p class="job-budget">$2,000 - $3,000</p>
                            <a href="<c:url value='/jobs'/>" class="btn btn-small">View Details</a>
                        </div>
                    </div>
                    
                    <div class="job-card">
                        <div class="job-card-header">
                            <h3>Graphic Designer</h3>
                            <span class="job-type">Remote</span>
                        </div>
                        <div class="job-card-body">
                            <p class="job-company">Creative Solutions</p>
                            <p class="job-description">Seeking a talented graphic designer to create branding materials and marketing assets.</p>
                            <div class="job-tags">
                                <span>Photoshop</span>
                                <span>Illustrator</span>
                                <span>InDesign</span>
                                <span>Logo Design</span>
                            </div>
                        </div>
                        <div class="job-card-footer">
                            <p class="job-budget">$1,500 - $2,500</p>
                            <a href="<c:url value='/jobs'/>" class="btn btn-small">View Details</a>
                        </div>
                    </div>
                    
                    <div class="job-card">
                        <div class="job-card-header">
                            <h3>Content Writer</h3>
                            <span class="job-type">Remote</span>
                        </div>
                        <div class="job-card-body">
                            <p class="job-company">Digital Media Group</p>
                            <p class="job-description">Looking for a skilled content writer to create engaging blog posts and articles.</p>
                            <div class="job-tags">
                                <span>Blogging</span>
                                <span>SEO</span>
                                <span>Copywriting</span>
                                <span>Research</span>
                            </div>
                        </div>
                        <div class="job-card-footer">
                            <p class="job-budget">$500 - $1,000</p>
                            <a href="<c:url value='/jobs'/>" class="btn btn-small">View Details</a>
                        </div>
                    </div>
                </div>
                <div class="cta-center">
                    <a href="<c:url value='/jobs'/>" class="btn btn-primary">View All Jobs</a>
                </div>
            </div>
        </section>
        
        <!-- Testimonials -->
        <section class="testimonials">
            <div class="container">
                <h2 class="section-title">What Our Users Say</h2>
                <div class="testimonial-slider">
                    <div class="testimonial">
                        <div class="testimonial-content">
                            <p>"QuickHire helped me find talented freelancers for my startup. The process was smooth, and I found the perfect match for my project."</p>
                        </div>
                        <div class="testimonial-author">
                            <img src="https://pixabay.com/get/g11e8369ab8f89e133fc9abef7f9fec1bc223bf36372cf965f47b1bceb2d6ae71abaaeb56da0b9c0cc2421e11a8d1ccf485ac5954e5495b396b69dc748c432fbc_1280.jpg" alt="Company Testimonial">
                            <div>
                                <h4>Sarah Johnson</h4>
                                <p>CEO, TechStart</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="testimonial">
                        <div class="testimonial-content">
                            <p>"As a freelance designer, QuickHire has been instrumental in connecting me with clients who value my work. The platform is easy to use and secure."</p>
                        </div>
                        <div class="testimonial-author">
                            <img src="https://pixabay.com/get/g73599b4e211b14081ce36ab81a4cbca7107fc4a7dc8ae0ee2b44273bfb1fcc788a1d214aa0ce21a727dbcc80cf20d8553a927c56ceb1369a10144f2b2850a0f0_1280.jpg" alt="Freelancer Testimonial">
                            <div>
                                <h4>Michael Chen</h4>
                                <p>Graphic Designer</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Call to Action -->
        <section class="cta-section">
            <div class="container">
                <div class="cta-content">
                    <h2>Ready to Get Started?</h2>
                    <p>Join thousands of companies and freelancers who are already benefiting from QuickHire.</p>
                    <div class="cta-buttons">
                        <a href="<c:url value='/register.jsp'/>" class="btn btn-primary">Sign Up Now</a>
                        <a href="<c:url value='/login.jsp'/>" class="btn btn-secondary">Log In</a>
                    </div>
                </div>
                <div class="cta-image">
                    <img src="https://pixabay.com/get/g1f953f9dae743b44b12b3240dbb8e1ab7dac299d56a22073ae13e722270dddc6b76f94d40e4d05e34a9c85e0469226c0ae13259be9e18b0e210c661513e1d3ae_1280.jpg" alt="Professional Team">
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="js/script.js"></script>
</body>
</html>
