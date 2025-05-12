# QuickHire - Freelance Platform

A dynamic web platform designed to streamline freelance job matching, specifically tailored for the South African market, connecting companies and freelancers through an advanced multi-tier web application.

## Project Overview

QuickHire is a comprehensive freelance job matching platform that allows:
- Companies to post jobs and hire qualified freelancers
- Freelancers to find relevant projects and apply for positions
- Smart matching between job requirements and freelancer skills
- Secure messaging and collaboration
- Rating and review system for both parties

## Tech Stack

- Frontend: HTML5, CSS3, JavaScript
- Backend: Node.js and Java Enterprise Edition (JEE)
- Database: PostgreSQL (configured, fallback to in-memory storage)
- Build Tool: Maven for Java components

## Running the Project Locally

### Quick Start (Node.js server only)

1. Make sure Node.js is installed
2. Open a terminal/command prompt
3. Navigate to the project directory
4. Run the simplified local server:
   ```
   node local-server.js
   ```
5. Open your browser and go to: http://localhost:5000/test-dashboard.html

### VS Code Setup

For detailed instructions on setting up the project in Visual Studio Code, see [VS Code Setup Guide](vs-code-setup.md).

## Project Structure

```
QuickHire/
├── src/
│   └── main/
│       ├── java/        # Java backend code
│       └── webapp/      # Frontend assets
│           ├── css/     # Stylesheets
│           ├── js/      # JavaScript files
│           └── *.html   # HTML pages
├── server.js           # Production Node.js server
├── local-server.js     # Simplified server for local development
└── run.sh              # Startup script
```

## Key Features

### UI Components
- Modern dashboard with gradient styling and animations
- Responsive design for all device sizes
- Interactive job cards with hover effects
- Advanced form inputs with floating labels
- Custom notification system with icons
- Tabbed navigation with smooth transitions

### Backend Systems
- User authentication and authorization
- Job posting and application management
- Search and filter functionality
- Real-time messaging
- Profile management

## Demo Pages

- **Client Dashboard:** `/client-dashboard-dynamic.html`
- **Freelancer Dashboard:** `/freelancer-dashboard-dynamic.html`
- **Test Dashboard:** `/test-dashboard.html` (contains all UI components)
- **Login Page:** `/login.html`

## Development Notes

- The Java servlets currently have compilation issues that need to be resolved
- The Node.js server uses in-memory storage when database connections are unavailable
- For frontend development, use the test-dashboard.html page which contains all styled UI components

## Visually Improved Elements

The latest update focused on UI enhancements including:
- Gradient buttons with hover animations
- Modern form inputs with floating labels
- Enhanced job cards with subtle animations
- Improved notification system with titles and icons
- Styled tabs with interactive elements
- Enhanced widgets with visual effects