/**
 * QuickHire Server
 * 
 * Main server file for the QuickHire platform.
 * This handles static file serving and API endpoints.
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const querystring = require('querystring');

// Port configuration
const PORT = process.env.PORT || 5000;

// Base directory for static files
const STATIC_DIR = path.join(__dirname, 'src', 'main', 'webapp');

// MIME types for different file extensions
const MIME_TYPES = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.txt': 'text/plain',
};

// In-memory storage for demo data
const users = [
  {
    id: "12345",
    username: "test_user",
    email: "test@example.com",
    password: "password123",
    fullName: "Test User",
    userType: "client", // or 'freelancer'
    company: "Test Company",
    location: "Cape Town, South Africa",
    profileImage: "https://randomuser.me/api/portraits/men/32.jpg"
  }
];

// Create HTTP server
const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url);
  const pathname = parsedUrl.pathname;
  
  // Handle API endpoints
  if (pathname === '/api/login' && req.method === 'POST') {
    let body = '';
    
    req.on('data', chunk => {
      body += chunk.toString();
    });
    
    req.on('end', () => {
      try {
        const data = JSON.parse(body);
        const { email, password } = data;
        
        // Very basic authentication demo
        const user = users.find(u => u.email === email);
        
        if (user) {
          res.writeHead(200, { 'Content-Type': 'application/json' });
          // Don't send password to client
          const { password, ...userWithoutPassword } = user;
          res.end(JSON.stringify({ 
            success: true, 
            message: 'Login successful',
            user: userWithoutPassword
          }));
        } else {
          res.writeHead(401, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ success: false, message: 'Invalid credentials' }));
        }
      } catch (error) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ success: false, message: 'Invalid request' }));
      }
    });
    
    return;
  }
  
  // Serve static files
  let filePath = pathname;
  
  // Default to index.html if root path
  if (pathname === '/') {
    filePath = '/index.html';
  }
  
  // Construct full file path
  filePath = path.join(STATIC_DIR, filePath);
  
  // Get file extension
  const extname = path.extname(filePath);
  const contentType = MIME_TYPES[extname] || 'application/octet-stream';
  
  // Read and serve the file
  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        // File not found - try to serve test-dashboard.html
        if (pathname !== '/test-dashboard.html') {
          console.log(`File not found: ${filePath}, redirecting to test-dashboard.html`);
          fs.readFile(path.join(STATIC_DIR, 'test-dashboard.html'), (err, content) => {
            if (err) {
              // Even test-dashboard.html not found
              res.writeHead(404);
              res.end('404 Not Found');
            } else {
              res.writeHead(200, { 'Content-Type': 'text/html' });
              res.end(content, 'utf-8');
            }
          });
        } else {
          res.writeHead(404);
          res.end('404 Not Found');
        }
      } else {
        // Server error
        res.writeHead(500);
        res.end(`Server Error: ${err.code}`);
      }
    } else {
      // Success - serve the file
      console.log(`Serving file: ${filePath}`);
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(content, 'utf-8');
    }
  });
});

// Start the server
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Open your browser and navigate to http://localhost:${PORT}/test-dashboard.html`);
  console.log('Press Ctrl+C to stop the server.');
});