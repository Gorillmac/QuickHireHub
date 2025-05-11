const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const { exec } = require('child_process');
const crypto = require('crypto');
const mysql = require('mysql2/promise');

// Database connection
let db = null;

// In-memory storage as fallback when database is not available
const memStorage = {
    users: new Map(), // Map of user ID to user object
    usersByEmail: new Map(), // Map of email to user ID
    jobs: new Map(), // Map of job ID to job object
    
    // User methods
    saveUser: function(user) {
        this.users.set(user.id, user);
        this.usersByEmail.set(user.email, user.id);
        return user;
    },
    getUserById: function(id) {
        return this.users.get(id);
    },
    getUserByEmail: function(email) {
        const userId = this.usersByEmail.get(email);
        if (userId) {
            return this.users.get(userId);
        }
        return null;
    },
    authenticateUser: function(email, password) {
        const user = this.getUserByEmail(email);
        if (user && user.password === password) {
            return user;
        }
        return null;
    },
    
    // Job methods
    saveJob: function(job) {
        this.jobs.set(job.id, job);
        return job;
    },
    getJobById: function(id) {
        return this.jobs.get(id);
    },
    getAllJobs: function() {
        return Array.from(this.jobs.values());
    },
    getJobsByClient: function(clientId) {
        return Array.from(this.jobs.values())
            .filter(job => job.client_id === clientId);
    },
    searchJobs: function(keywords) {
        const lowerKeywords = keywords.toLowerCase();
        return Array.from(this.jobs.values())
            .filter(job => 
                job.title.toLowerCase().includes(lowerKeywords) || 
                job.description.toLowerCase().includes(lowerKeywords) ||
                job.skills.some(skill => skill.toLowerCase().includes(lowerKeywords))
            );
    }
};

async function initDatabase() {
    try {
        // Try to use the PostgreSQL database connection string first (as it's already set up)
        // Fall back to explicit MySQL parameters if needed
        if (process.env.DATABASE_URL) {
            console.log('Using PostgreSQL database via DATABASE_URL');
            // We're using the MySQL client, so we can't use PostgreSQL
            console.log('But we need to use MySQL client - will use memory storage instead');
            db = null;
            return;
        }
        
        // Try MySQL connection
        db = await mysql.createConnection({
            host: process.env.MYSQL_HOST || 'localhost',
            user: process.env.MYSQL_USER || 'root',
            password: process.env.MYSQL_PASSWORD || '',
            database: process.env.MYSQL_DATABASE || 'quickhire'
        });
        
        console.log('MySQL connection established');
        
        // Create tables if they don't exist
        await db.execute(`
            CREATE TABLE IF NOT EXISTS users (
                id VARCHAR(36) PRIMARY KEY,
                first_name VARCHAR(100) NOT NULL,
                last_name VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL UNIQUE,
                password VARCHAR(100) NOT NULL,
                user_type ENUM('FREELANCER', 'CLIENT') NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                currency VARCHAR(3) DEFAULT 'ZAR',
                locale VARCHAR(10) DEFAULT 'en-ZA',
                country VARCHAR(50) DEFAULT 'South Africa',
                timezone VARCHAR(50) DEFAULT 'Africa/Johannesburg'
            )
        `);
        
        // Create jobs table
        await db.execute(`
            CREATE TABLE IF NOT EXISTS jobs (
                id VARCHAR(36) PRIMARY KEY,
                client_id VARCHAR(36) NOT NULL,
                title VARCHAR(200) NOT NULL,
                description TEXT NOT NULL,
                budget DECIMAL(10,2) NOT NULL,
                currency VARCHAR(3) DEFAULT 'ZAR',
                skills TEXT NOT NULL,
                status ENUM('OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELED') DEFAULT 'OPEN',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                deadline DATE,
                location VARCHAR(100) DEFAULT 'Remote',
                FOREIGN KEY (client_id) REFERENCES users(id)
            )
        `);
        
        console.log('Database tables created successfully');
    } catch (error) {
        console.error('Database initialization error:', error);
        console.log('Using in-memory storage instead');
        db = null;
    }
}

// Initialize database
initDatabase();

const server = http.createServer(async (req, res) => {
    const reqUrl = url.parse(req.url);
    let filePath = path.join(__dirname, 'src/main/webapp', reqUrl.pathname === '/' ? 'index.html' : reqUrl.pathname);
    
    // Map endpoint paths to their servlet classes
    if (reqUrl.pathname === '/register' || reqUrl.pathname === '/login' || reqUrl.pathname === '/logout') {
        // Special handling for authentication endpoints
        const servletClass = 
            reqUrl.pathname === '/register' ? 'RegisterServlet' :
            reqUrl.pathname === '/login' ? 'LoginServlet' : 'LogoutServlet';
        
        console.log(`[${new Date().toISOString()}] ${req.method} ${reqUrl.pathname} -> ${servletClass}`);
        
        // Set CORS headers
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
        
        // Handle different HTTP methods
        // Handle OPTIONS request for CORS preflight
        if (req.method === 'OPTIONS') {
            res.writeHead(204);
            res.end();
            return;
        }
        
        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => {
                body += chunk.toString();
            });
            
            req.on('end', async () => {
                try {
                    // Parse the form data - try both JSON and URL encoded formats
                    let userData = {};
                    
                    try {
                        // First try parsing as JSON
                        try {
                            userData = JSON.parse(body);
                        } catch (e) {
                            // Check if it's multipart form data
                            if (body.includes('Content-Disposition: form-data')) {
                                const boundaryMatch = req.headers['content-type'] ? req.headers['content-type'].match(/boundary=([^;]+)/) : null;
                                
                                if (boundaryMatch) {
                                    const boundary = boundaryMatch[1];
                                    const parts = body.split('--' + boundary);
                                    
                                    // Initialize userData object
                                    userData = {};
                                    
                                    // Process each part
                                    for (const part of parts) {
                                        const nameMatch = part.match(/name="([^"]+)"/);
                                        if (nameMatch) {
                                            const name = nameMatch[1];
                                            // Extract the value (everything after the double newline)
                                            const value = part.split(/\r\n\r\n|\n\n/)[1]?.trim();
                                            if (value) {
                                                userData[name] = value;
                                            }
                                        }
                                    }
                                }
                            } else {
                                // If it's not multipart, try URL encoded format
                                const formData = new URLSearchParams(body);
                                
                                // Determine which endpoint we're handling
                                if (reqUrl.pathname === '/register') {
                                    userData = {
                                        firstName: formData.get('firstName'),
                                        lastName: formData.get('lastName'),
                                        email: formData.get('email'),
                                        password: formData.get('password'),
                                        userType: formData.get('userType')
                                    };
                                } else if (reqUrl.pathname === '/login') {
                                    userData = {
                                        email: formData.get('email'),
                                        password: formData.get('password'),
                                        rememberMe: formData.get('rememberMe') === 'on'
                                    };
                                }
                            }
                        }
                    } catch (parseError) {
                        console.error(`[${new Date().toISOString()}] Error parsing request data:`, parseError);
                        userData = {};
                    }
                    
                    // Log the captured data
                    console.log(`[${new Date().toISOString()}] Form submission to ${reqUrl.pathname}:`, body);
                    console.log(`[${new Date().toISOString()}] Parsed user data:`, userData);
                    
                    // Handle different endpoints
                    if (reqUrl.pathname === '/register') {
                        // Check if all required fields are present for registration
                        if (!userData.firstName || !userData.lastName || !userData.email || !userData.password || !userData.userType) {
                            res.writeHead(400, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify({ error: 'All fields are required' }));
                            return;
                        }
                        
                        // Further validate the data
                        // For a real application, we'd add more validation and password hashing
                        
                        // Determine which dashboard to redirect to based on user type
                        const redirectUrl = userData.userType === 'freelancer' ? 'freelancer-dashboard-dynamic.html' : 'client-dashboard-dynamic.html';
                        
                        // Generate a random UUID for the new user
                        const userId = crypto.randomUUID();
                        
                        // Set up user configuration with South African settings
                        const userConfig = {
                            currency: 'ZAR',
                            locale: 'en-ZA',
                            country: 'South Africa',
                            timezone: 'Africa/Johannesburg'
                        };
                        
                        try {
                            // Save the user to the database
                            if (db) {
                                // Convert user type to uppercase for the database
                                const userType = userData.userType.toUpperCase();
                                
                                // Insert the user into the database
                                await db.execute(
                                    `INSERT INTO users (id, first_name, last_name, email, password, user_type, currency, locale, country, timezone) 
                                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                                    [
                                        userId, 
                                        userData.firstName, 
                                        userData.lastName, 
                                        userData.email, 
                                        userData.password, // In a real app, this would be hashed
                                        userType,
                                        userConfig.currency,
                                        userConfig.locale,
                                        userConfig.country,
                                        userConfig.timezone
                                    ]
                                );
                                
                                console.log(`[${new Date().toISOString()}] Saved user ${userId} to database`);
                            } else {
                                console.log(`[${new Date().toISOString()}] Database not connected, saving user ${userId} to memory storage`);
                                
                                // Check if user email already exists in memory storage
                                if (memStorage.getUserByEmail(userData.email)) {
                                    console.log(`[${new Date().toISOString()}] Email ${userData.email} already exists in memory storage`);
                                    res.writeHead(400, { 'Content-Type': 'application/json' });
                                    res.end(JSON.stringify({ error: 'Email already exists. Please use a different email address.' }));
                                    return;
                                }
                                
                                // Save to in-memory storage instead
                                const user = {
                                    id: userId,
                                    first_name: userData.firstName,
                                    last_name: userData.lastName,
                                    email: userData.email,
                                    password: userData.password,
                                    user_type: userData.userType.toUpperCase(),
                                    created_at: new Date(),
                                    updated_at: new Date(),
                                    currency: userConfig.currency,
                                    locale: userConfig.locale,
                                    country: userConfig.country,
                                    timezone: userConfig.timezone
                                };
                                
                                memStorage.saveUser(user);
                                console.log(`[${new Date().toISOString()}] User saved to memory storage`);
                            }
                        } catch (dbError) {
                            console.error(`[${new Date().toISOString()}] Database error:`, dbError);
                            // If it's a duplicate email error, return a specific message
                            if (dbError.code === 'ER_DUP_ENTRY') {
                                res.writeHead(400, { 'Content-Type': 'application/json' });
                                res.end(JSON.stringify({ error: 'Email already exists. Please use a different email address.' }));
                                return;
                            }
                        }
                        
                        console.log(`[${new Date().toISOString()}] Created new user with ID: ${userId}`);
                        console.log(`[${new Date().toISOString()}] User configuration: ${JSON.stringify(userConfig)}`);
                        
                        res.writeHead(200, { 'Content-Type': 'application/json' });
                        const response = {
                            success: 'Registration successful! Redirecting to dashboard...',
                            redirect: redirectUrl,
                            userId: userId,
                            userConfig: userConfig
                        };
                        res.end(JSON.stringify(response));
                        
                        console.log(`[${new Date().toISOString()}] Registration successful for ${userData.email}`);
                        console.log(`Redirecting to: ${redirectUrl}`);
                    } 
                    else if (reqUrl.pathname === '/login') {
                        // Check if all required fields are present for login
                        if (!userData.email || !userData.password) {
                            res.writeHead(400, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify({ error: 'Email and password are required' }));
                            return;
                        }
                        
                        try {
                            // Authenticate user against database
                            if (db) {
                                // Query the database for the user with matching email and password
                                const [rows] = await db.execute(
                                    'SELECT * FROM users WHERE email = ? AND password = ?',
                                    [userData.email, userData.password]
                                );
                                
                                if (rows.length === 0) {
                                    // No user found with these credentials
                                    res.writeHead(401, { 'Content-Type': 'application/json' });
                                    res.end(JSON.stringify({ error: 'Invalid email or password' }));
                                    return;
                                }
                                
                                // User found, get their details
                                const user = rows[0];
                                const userId = user.id;
                                const userType = user.user_type.toLowerCase();
                                const redirectUrl = userType === 'freelancer' ? 'freelancer-dashboard-dynamic.html' : 'client-dashboard-dynamic.html';
                                
                                // Set up user configuration from database
                                const userConfig = {
                                    currency: user.currency || 'ZAR',
                                    locale: user.locale || 'en-ZA',
                                    country: user.country || 'South Africa',
                                    timezone: user.timezone || 'Africa/Johannesburg'
                                };
                                
                                console.log(`[${new Date().toISOString()}] User logged in with ID: ${userId}`);
                                console.log(`[${new Date().toISOString()}] User configuration: ${JSON.stringify(userConfig)}`);
                                
                                res.writeHead(200, { 'Content-Type': 'application/json' });
                                const response = {
                                    success: 'Login successful! Redirecting to dashboard...',
                                    redirect: redirectUrl,
                                    userId: userId,
                                    userConfig: userConfig,
                                    firstName: user.first_name,
                                    lastName: user.last_name,
                                    user: {
                                        id: userId,
                                        first_name: user.first_name,
                                        last_name: user.last_name,
                                        email: user.email,
                                        user_type: user.user_type,
                                        currency: user.currency || 'ZAR',
                                        locale: user.locale || 'en-ZA'
                                    }
                                };
                                
                                res.end(JSON.stringify(response));
                                console.log(`[${new Date().toISOString()}] Login successful for ${userData.email}`);
                                console.log(`Redirecting to: ${redirectUrl}`);
                                return;
                            } else {
                                console.log(`[${new Date().toISOString()}] Database not connected, checking memory storage`);
                                
                                // Try authenticating against in-memory storage
                                const user = memStorage.authenticateUser(userData.email, userData.password);
                                
                                if (user) {
                                    console.log(`[${new Date().toISOString()}] User found in memory storage`);
                                    
                                    // User found in memory, get their details
                                    const userId = user.id;
                                    const userType = user.user_type.toLowerCase();
                                    const redirectUrl = userType === 'freelancer' ? 'freelancer-dashboard-dynamic.html' : 'client-dashboard-dynamic.html';
                                    
                                    // Set up user configuration from memory
                                    const userConfig = {
                                        currency: user.currency || 'ZAR',
                                        locale: user.locale || 'en-ZA',
                                        country: user.country || 'South Africa',
                                        timezone: user.timezone || 'Africa/Johannesburg'
                                    };
                                    
                                    console.log(`[${new Date().toISOString()}] User logged in with ID: ${userId} (memory storage)`);
                                    
                                    res.writeHead(200, { 'Content-Type': 'application/json' });
                                    const response = {
                                        success: 'Login successful! Redirecting to dashboard...',
                                        redirect: redirectUrl,
                                        userId: userId,
                                        userConfig: userConfig,
                                        firstName: user.first_name,
                                        lastName: user.last_name
                                    };
                                    
                                    res.end(JSON.stringify(response));
                                    console.log(`[${new Date().toISOString()}] Login successful for ${userData.email} (memory storage)`);
                                    console.log(`Redirecting to: ${redirectUrl}`);
                                    return;
                                }
                                
                                console.log(`[${new Date().toISOString()}] User not found in memory storage, using basic fallback logic`);
                                
                                // Absolute fallback if memory storage has no user
                                // Determine user type for redirection based on email
                                const userType = userData.email.startsWith('f') ? 'freelancer' : 'client';
                                const redirectUrl = userType === 'freelancer' ? 'freelancer-dashboard-dynamic.html' : 'client-dashboard-dynamic.html';
                                
                                // Generate a user ID 
                                const userId = crypto.randomUUID();
                                
                                // Set up user configuration with South African settings
                                const userConfig = {
                                    currency: 'ZAR',
                                    locale: 'en-ZA',
                                    country: 'South Africa',
                                    timezone: 'Africa/Johannesburg'
                                };
                                
                                console.log(`[${new Date().toISOString()}] User logged in with ID: ${userId} (fallback mode)`);
                                
                                res.writeHead(200, { 'Content-Type': 'application/json' });
                                const response = {
                                    success: 'Login successful! Redirecting to dashboard...',
                                    redirect: redirectUrl,
                                    userId: userId,
                                    userConfig: userConfig,
                                    user: {
                                        id: userId,
                                        first_name: userData.email.split('@')[0], // Extract name from email as fallback
                                        last_name: '',
                                        email: userData.email,
                                        user_type: userType,
                                        currency: userConfig.currency,
                                        locale: userConfig.locale
                                    }
                                };
                                
                                res.end(JSON.stringify(response));
                                console.log(`[${new Date().toISOString()}] Login successful for ${userData.email} (fallback mode)`);
                                console.log(`Redirecting to: ${redirectUrl}`);
                                return;
                            }
                        } catch (dbError) {
                            console.error(`[${new Date().toISOString()}] Database error during login:`, dbError);
                            res.writeHead(500, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify({ error: 'Login failed. Please try again later.' }));
                            return;
                        }
                    }
                    
                } catch (error) {
                    console.error(`[${new Date().toISOString()}] Error processing ${reqUrl.pathname}:`, error);
                    res.writeHead(500, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'An error occurred. Please try again later.' }));
                }
            });
        } else {
            // Handle GET requests to auth endpoints (show the appropriate pages)
            serveFile(filePath, res);
        }
    } else if (reqUrl.pathname.startsWith('/users/') ||
               reqUrl.pathname.startsWith('/applications/') ||
               reqUrl.pathname.startsWith('/messages/') ||
               reqUrl.pathname.startsWith('/reviews/') ||
               reqUrl.pathname.startsWith('/reports/')) {
        
        // Extract the servlet class from the path
        const parts = reqUrl.pathname.split('/');
        const resource = parts[1]; // 'users', 'jobs', etc.
        const servletClass = resource.charAt(0).toUpperCase() + resource.slice(1, -1) + 'Servlet'; // 'UserServlet', 'JobServlet', etc.
        
        console.log(`[${new Date().toISOString()}] ${req.method} ${reqUrl.pathname} -> ${servletClass}`);
        
        // Set CORS headers
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
        
        // Handle OPTIONS request for CORS preflight
        if (req.method === 'OPTIONS') {
            res.writeHead(204);
            res.end();
            return;
        }
        
        // For now, serve JSON data
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ message: `Handling ${req.method} request to ${reqUrl.pathname}` }));
        
    } else if (reqUrl.pathname === '/jobs' || reqUrl.pathname.startsWith('/jobs/')) {
        // Jobs API handling
        
        // Extract the parts from the path
        const parts = reqUrl.pathname.split('/');
        
        // Set CORS headers
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
        
        // Handle OPTIONS request for CORS preflight
        if (req.method === 'OPTIONS') {
            res.writeHead(204);
            res.end();
            return;
        }
        
        // Handle jobs API
        // For GET jobs requests
        if (req.method === 'GET') {
            // Get single job
            if (parts.length >= 3 && parts[2] && parts[2] !== '') {
                const jobId = parts[2];
                
                try {
                    if (db) {
                        // Query from database
                        const [rows] = await db.execute(
                            'SELECT * FROM jobs WHERE id = ?',
                            [jobId]
                        );
                        
                        if (rows.length === 0) {
                            res.writeHead(404, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify({ error: 'Job not found' }));
                            return;
                        }
                        
                        const job = rows[0];
                        res.writeHead(200, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify(job));
                        
                    } else {
                        // Get from memory storage
                        const job = memStorage.getJobById(jobId);
                        
                        if (!job) {
                            res.writeHead(404, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify({ error: 'Job not found' }));
                            return;
                        }
                        
                        res.writeHead(200, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify(job));
                    }
                } catch (error) {
                    console.error(`[${new Date().toISOString()}] Error fetching job:`, error);
                    res.writeHead(500, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'Failed to fetch job details' }));
                }
            } 
            // Get all jobs or search
            else {
                // Check for search query
                const queryParams = {};
                if (reqUrl.search) {
                    const searchParams = new URLSearchParams(reqUrl.search.substring(1));
                    for (const [key, value] of searchParams.entries()) {
                        queryParams[key] = value;
                    }
                }
                
                try {
                    if (db) {
                        let query = 'SELECT * FROM jobs';
                        const params = [];
                        
                        // Add search condition if provided
                        if (queryParams.search) {
                            query += ' WHERE title LIKE ? OR description LIKE ? OR skills LIKE ?';
                            const searchPattern = `%${queryParams.search}%`;
                            params.push(searchPattern, searchPattern, searchPattern);
                        }
                        
                        // Add client filter if provided
                        if (queryParams.client_id) {
                            query += params.length ? ' AND' : ' WHERE';
                            query += ' client_id = ?';
                            params.push(queryParams.client_id);
                        }
                        
                        // Add status filter if provided
                        if (queryParams.status) {
                            query += params.length ? ' AND' : ' WHERE';
                            query += ' status = ?';
                            params.push(queryParams.status.toUpperCase());
                        }
                        
                        // Order by
                        query += ' ORDER BY created_at DESC';
                        
                        // Execute query
                        const [rows] = await db.execute(query, params);
                        
                        res.writeHead(200, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify(rows));
                        
                    } else {
                        // Get from memory storage
                        let jobs = memStorage.getAllJobs();
                        
                        // Apply filters
                        if (queryParams.client_id) {
                            jobs = jobs.filter(job => job.client_id === queryParams.client_id);
                        }
                        
                        if (queryParams.status) {
                            jobs = jobs.filter(job => job.status === queryParams.status.toUpperCase());
                        }
                        
                        if (queryParams.search) {
                            jobs = memStorage.searchJobs(queryParams.search);
                        }
                        
                        // Sort by created_at descending
                        jobs.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
                        
                        res.writeHead(200, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify(jobs));
                    }
                } catch (error) {
                    console.error(`[${new Date().toISOString()}] Error fetching jobs:`, error);
                    res.writeHead(500, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'Failed to fetch jobs' }));
                }
            }
        }
        // For POST jobs (create new job)
        else if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => {
                body += chunk.toString();
            });
            
            req.on('end', async () => {
                try {
                    const jobData = JSON.parse(body);
                    
                    // Validate required fields
                    if (!jobData.title || !jobData.description || !jobData.budget || !jobData.client_id || !jobData.skills) {
                        res.writeHead(400, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify({ 
                            error: 'Missing required fields', 
                            required: ['title', 'description', 'budget', 'client_id', 'skills'] 
                        }));
                        return;
                    }
                    
                    // Generate ID for the job
                    const jobId = crypto.randomUUID();
                    
                    // Format the skills array into a string if necessary
                    const skillsString = Array.isArray(jobData.skills) 
                        ? jobData.skills.join(',') 
                        : jobData.skills;
                    
                    try {
                        if (db) {
                            // Save to database
                            await db.execute(
                                `INSERT INTO jobs (
                                    id, client_id, title, description, budget, currency, 
                                    skills, status, deadline, location
                                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                                [
                                    jobId,
                                    jobData.client_id,
                                    jobData.title,
                                    jobData.description,
                                    jobData.budget,
                                    jobData.currency || 'ZAR',
                                    skillsString,
                                    jobData.status || 'OPEN',
                                    jobData.deadline || null,
                                    jobData.location || 'Remote'
                                ]
                            );
                            
                            // Fetch the created job
                            const [rows] = await db.execute(
                                'SELECT * FROM jobs WHERE id = ?',
                                [jobId]
                            );
                            
                            const job = rows[0];
                            res.writeHead(201, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify(job));
                            
                        } else {
                            // Prepare job object for memory storage
                            const job = {
                                id: jobId,
                                client_id: jobData.client_id,
                                title: jobData.title,
                                description: jobData.description,
                                budget: parseFloat(jobData.budget),
                                currency: jobData.currency || 'ZAR',
                                skills: Array.isArray(jobData.skills) ? jobData.skills : jobData.skills.split(','),
                                status: jobData.status || 'OPEN',
                                created_at: new Date(),
                                updated_at: new Date(),
                                deadline: jobData.deadline || null,
                                location: jobData.location || 'Remote'
                            };
                            
                            // Save to memory storage
                            memStorage.saveJob(job);
                            
                            res.writeHead(201, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify(job));
                        }
                    } catch (dbError) {
                        console.error(`[${new Date().toISOString()}] Database error creating job:`, dbError);
                        res.writeHead(500, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify({ error: 'Failed to create job' }));
                    }
                } catch (parseError) {
                    console.error(`[${new Date().toISOString()}] Error parsing job data:`, parseError);
                    res.writeHead(400, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'Invalid job data format' }));
                }
            });
            return;
        }
        // For PUT (update job)
        else if (req.method === 'PUT' && parts.length >= 3 && parts[2] && parts[2] !== '') {
            const jobId = parts[2];
            
            let body = '';
            req.on('data', chunk => {
                body += chunk.toString();
            });
            
            req.on('end', async () => {
                try {
                    const jobData = JSON.parse(body);
                    
                    try {
                        if (db) {
                            // Check if job exists
                            const [checkRows] = await db.execute(
                                'SELECT * FROM jobs WHERE id = ?',
                                [jobId]
                            );
                            
                            if (checkRows.length === 0) {
                                res.writeHead(404, { 'Content-Type': 'application/json' });
                                res.end(JSON.stringify({ error: 'Job not found' }));
                                return;
                            }
                            
                            // Build the update query dynamically based on provided fields
                            let updateQuery = 'UPDATE jobs SET ';
                            const updateValues = [];
                            
                            if (jobData.title) {
                                updateQuery += 'title = ?, ';
                                updateValues.push(jobData.title);
                            }
                            
                            if (jobData.description) {
                                updateQuery += 'description = ?, ';
                                updateValues.push(jobData.description);
                            }
                            
                            if (jobData.budget) {
                                updateQuery += 'budget = ?, ';
                                updateValues.push(jobData.budget);
                            }
                            
                            if (jobData.currency) {
                                updateQuery += 'currency = ?, ';
                                updateValues.push(jobData.currency);
                            }
                            
                            if (jobData.skills) {
                                const skillsString = Array.isArray(jobData.skills) 
                                    ? jobData.skills.join(',') 
                                    : jobData.skills;
                                updateQuery += 'skills = ?, ';
                                updateValues.push(skillsString);
                            }
                            
                            if (jobData.status) {
                                updateQuery += 'status = ?, ';
                                updateValues.push(jobData.status);
                            }
                            
                            if (jobData.deadline) {
                                updateQuery += 'deadline = ?, ';
                                updateValues.push(jobData.deadline);
                            }
                            
                            if (jobData.location) {
                                updateQuery += 'location = ?, ';
                                updateValues.push(jobData.location);
                            }
                            
                            // Always update the updated_at timestamp
                            updateQuery += 'updated_at = NOW() ';
                            
                            // Add the WHERE clause
                            updateQuery += 'WHERE id = ?';
                            updateValues.push(jobId);
                            
                            // Execute the update
                            await db.execute(updateQuery, updateValues);
                            
                            // Fetch updated job
                            const [rows] = await db.execute(
                                'SELECT * FROM jobs WHERE id = ?',
                                [jobId]
                            );
                            
                            const job = rows[0];
                            res.writeHead(200, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify(job));
                            
                        } else {
                            // Update in memory storage
                            const job = memStorage.getJobById(jobId);
                            
                            if (!job) {
                                res.writeHead(404, { 'Content-Type': 'application/json' });
                                res.end(JSON.stringify({ error: 'Job not found' }));
                                return;
                            }
                            
                            // Update fields
                            if (jobData.title) job.title = jobData.title;
                            if (jobData.description) job.description = jobData.description;
                            if (jobData.budget) job.budget = parseFloat(jobData.budget);
                            if (jobData.currency) job.currency = jobData.currency;
                            if (jobData.skills) {
                                job.skills = Array.isArray(jobData.skills) 
                                    ? jobData.skills 
                                    : jobData.skills.split(',');
                            }
                            if (jobData.status) job.status = jobData.status;
                            if (jobData.deadline) job.deadline = jobData.deadline;
                            if (jobData.location) job.location = jobData.location;
                            
                            // Update timestamp
                            job.updated_at = new Date();
                            
                            // Save updated job
                            memStorage.saveJob(job);
                            
                            res.writeHead(200, { 'Content-Type': 'application/json' });
                            res.end(JSON.stringify(job));
                        }
                    } catch (dbError) {
                        console.error(`[${new Date().toISOString()}] Error updating job:`, dbError);
                        res.writeHead(500, { 'Content-Type': 'application/json' });
                        res.end(JSON.stringify({ error: 'Failed to update job' }));
                    }
                } catch (parseError) {
                    console.error(`[${new Date().toISOString()}] Error parsing job update data:`, parseError);
                    res.writeHead(400, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'Invalid job data format' }));
                }
            });
            return;
        }
        else {
            res.writeHead(405, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Method not allowed' }));
        }
    } else {
        // Serve static files
        serveFile(filePath, res);
    }
});

function serveFile(filePath, res) {
    const extname = path.extname(filePath);
    const contentType = {
        '.html': 'text/html',
        '.js': 'text/javascript',
        '.css': 'text/css',
        '.json': 'application/json',
        '.png': 'image/png',
        '.jpg': 'image/jpg',
        '.gif': 'image/gif',
        '.svg': 'image/svg+xml',
        '.wav': 'audio/wav',
        '.mp4': 'video/mp4',
        '.woff': 'application/font-woff',
        '.ttf': 'application/font-ttf',
        '.eot': 'application/vnd.ms-fontobject',
        '.otf': 'application/font-otf',
        '.wasm': 'application/wasm'
    }[extname] || 'text/plain';
    
    console.log(`[${new Date().toISOString()}] Serving file: ${filePath}`);
    
    fs.readFile(filePath, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                // File not found - try serving index.html from the requested directory
                const indexPath = path.join(filePath, 'index.html');
                
                fs.readFile(indexPath, (indexError, indexContent) => {
                    if (indexError) {
                        // Can't find index.html either - serve the 404 page
                        fs.readFile(path.join(__dirname, 'src/main/webapp', '404.html'), (notFoundError, notFoundContent) => {
                            if (notFoundError) {
                                // Can't even find 404.html - send a plain text 404 response
                                res.writeHead(404, { 'Content-Type': 'text/plain' });
                                res.end('404 - Page Not Found');
                            } else {
                                res.writeHead(404, { 'Content-Type': 'text/html' });
                                res.end(notFoundContent, 'utf-8');
                            }
                        });
                    } else {
                        // Found index.html in the requested directory
                        res.writeHead(200, { 'Content-Type': 'text/html' });
                        res.end(indexContent, 'utf-8');
                    }
                });
            } else {
                // Server error
                res.writeHead(500, { 'Content-Type': 'text/plain' });
                res.end(`Server Error: ${error.code}`);
            }
        } else {
            // File found, serve it
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
}

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
    console.log(`[${new Date().toISOString()}] Server is running on port ${PORT}`);
    console.log('Press Ctrl+C to stop the server.');
});