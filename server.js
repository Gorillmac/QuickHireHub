const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const { exec } = require('child_process');
const crypto = require('crypto');

const server = http.createServer((req, res) => {
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
            
            req.on('end', () => {
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
                        
                        // Normally, here we would validate the data further and save it to the database
                        // For now, we'll simulate a successful registration
                        
                        // Determine which dashboard to redirect to based on user type
                        const redirectUrl = userData.userType === 'freelancer' ? 'freelancer-dashboard.html' : 'client-dashboard.html';
                        
                        // Generate a random UUID for the new user
                        const userId = crypto.randomUUID();
                        
                        console.log(`[${new Date().toISOString()}] Created new user with ID: ${userId}`);
                        
                        // Set up user configuration with South African settings
                        const userConfig = {
                            currency: 'ZAR',
                            locale: 'en-ZA',
                            country: 'South Africa',
                            timezone: 'Africa/Johannesburg'
                        };
                        
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
                        
                        // Normally, here we would validate credentials against the database
                        // For now, we'll simulate a successful login
                        
                        // Determine user type for redirection (in a real app, this would come from the database)
                        // For demo purposes, we'll redirect to freelancer dashboard for emails starting with 'f' and client dashboard otherwise
                        const userType = userData.email.startsWith('f') ? 'freelancer' : 'client';
                        const redirectUrl = userType === 'freelancer' ? 'freelancer-dashboard.html' : 'client-dashboard.html';
                        
                        // Generate a user ID (in a real app, this would come from the database)
                        const userId = crypto.randomUUID();
                        
                        console.log(`[${new Date().toISOString()}] User logged in with ID: ${userId}`);
                        
                        // Set up user configuration with South African settings
                        const userConfig = {
                            currency: 'ZAR',
                            locale: 'en-ZA',
                            country: 'South Africa',
                            timezone: 'Africa/Johannesburg'
                        };
                        
                        console.log(`[${new Date().toISOString()}] User configuration: ${JSON.stringify(userConfig)}`);
                        
                        res.writeHead(200, { 'Content-Type': 'application/json' });
                        const response = {
                            success: 'Login successful! Redirecting to dashboard...',
                            redirect: redirectUrl,
                            userId: userId,
                            userConfig: userConfig
                        };
                        res.end(JSON.stringify(response));
                        
                        console.log(`[${new Date().toISOString()}] Login successful for ${userData.email}`);
                        console.log(`Redirecting to: ${redirectUrl}`);
                    }
                } catch (error) {
                    console.error(`[${new Date().toISOString()}] Error processing request:`, error);
                    res.writeHead(500, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ error: 'Request failed. Please try again later.' }));
                }
            });
            
            return;
        }
        
        // GET requests for auth pages should serve the HTML
        if (reqUrl.pathname === '/register') filePath = path.join(__dirname, 'src/main/webapp', 'register.html');
        if (reqUrl.pathname === '/login') filePath = path.join(__dirname, 'src/main/webapp', 'login.html');
    }
    
    // Check if file exists
    fs.stat(filePath, (err, stats) => {
        if (err) {
            if (err.code === 'ENOENT') {
                // File not found - check if it's a directory request
                if (filePath.endsWith('/')) {
                    filePath = path.join(filePath, 'index.html');
                    fs.stat(filePath, (err, stats) => {
                        if (err) {
                            res.writeHead(404, { 'Content-Type': 'text/html' });
                            res.end('404 Not Found');
                            return;
                        }
                        serveFile(filePath, res);
                    });
                    return;
                }
                
                res.writeHead(404, { 'Content-Type': 'text/html' });
                res.end('404 Not Found');
                return;
            }
            
            res.writeHead(500, { 'Content-Type': 'text/html' });
            res.end('500 Internal Server Error');
            return;
        }
        
        if (stats.isDirectory()) {
            filePath = path.join(filePath, 'index.html');
            fs.stat(filePath, (err, stats) => {
                if (err) {
                    res.writeHead(404, { 'Content-Type': 'text/html' });
                    res.end('404 Not Found');
                    return;
                }
                serveFile(filePath, res);
            });
            return;
        }
        
        serveFile(filePath, res);
    });
});

function serveFile(filePath, res) {
    const extname = path.extname(filePath);
    let contentType = 'text/html';
    
    switch (extname) {
        case '.js':
            contentType = 'text/javascript';
            break;
        case '.css':
            contentType = 'text/css';
            break;
        case '.json':
            contentType = 'application/json';
            break;
        case '.png':
            contentType = 'image/png';
            break;
        case '.jpg':
            contentType = 'image/jpg';
            break;
        case '.svg':
            contentType = 'image/svg+xml';
            break;
    }
    
    fs.readFile(filePath, (err, content) => {
        if (err) {
            res.writeHead(500, { 'Content-Type': 'text/html' });
            res.end('500 Internal Server Error');
            return;
        }
        
        res.writeHead(200, { 'Content-Type': contentType });
        res.end(content, 'utf-8');
    });
}

const PORT = 5000;
server.listen(PORT, () => {
    console.log(`Server running at http://0.0.0.0:${PORT}/`);
    console.log(`Available pages:`);
    console.log(`- Homepage: http://localhost:${PORT}/index.html`);
    console.log(`- Login: http://localhost:${PORT}/login.html`);
    console.log(`- Register: http://localhost:${PORT}/register.html`);
    console.log(`- Client Dashboard: http://localhost:${PORT}/client-dashboard.html`);
    console.log(`- Freelancer Dashboard: http://localhost:${PORT}/freelancer-dashboard.html`);
});