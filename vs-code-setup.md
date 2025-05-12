# QuickHire VS Code Setup Guide

This guide will help you set up and run the QuickHire project in Visual Studio Code.

## Prerequisites

1. [Visual Studio Code](https://code.visualstudio.com/download)
2. [Node.js](https://nodejs.org/) (LTS version recommended)
3. [Git](https://git-scm.com/downloads) (optional, for version control)

## VS Code Extensions

Install these extensions to enhance your development experience:

1. **Live Server** - For static file hosting
   - Search for "Live Server" by Ritwick Dey in the VS Code extensions marketplace

2. **JavaScript (ES6) code snippets**
   - Helpful for JavaScript development

3. **Prettier - Code formatter**
   - For consistent code formatting

## Project Setup

### Option 1: Download the Project Files

1. Download all project files from Replit
2. Extract the ZIP to a folder on your computer
3. Open the folder in VS Code (File > Open Folder)

### Option 2: Clone the Repository (if using Git)

```bash
git clone [repository-url]
cd quickhire
```

## Installing Dependencies

Open a terminal in VS Code (Terminal > New Terminal) and run:

```bash
npm install http-server express body-parser cors mysql2 pg
```

## Running the Project

### Method 1: Running the Node.js Server

1. Open a terminal in VS Code
2. Run the server:
   ```bash
   node server.js
   ```
3. The server should start and display "Server is running on port 5000"
4. Open your browser and go to: `http://localhost:5000`

### Method 2: Using Live Server for Frontend Only

To view and test just the frontend (without Node.js server functionality):

1. Right-click on `src/main/webapp/test-dashboard.html` in VS Code
2. Select "Open with Live Server"
3. Your browser will open displaying the dashboard

## Folder Structure

- `src/main/webapp/` - Contains all frontend files
  - `*.html` - HTML pages
  - `css/` - CSS stylesheets
  - `js/` - JavaScript files
- `server.js` - Main Node.js server file

## Troubleshooting

### Port Already in Use

If you see an error like "Port 5000 is already in use":

1. Open `server.js`
2. Change the port number (e.g., from 5000 to 3000)
3. Save and restart the server

### Database Connection Issues

The project is set up to use in-memory storage when a database is not available.
If you want to connect to a real database:

1. Install MySQL or PostgreSQL locally
2. Update the database connection string in `server.js`

## Additional Resources

- [Node.js Documentation](https://nodejs.org/en/docs/)
- [VS Code Documentation](https://code.visualstudio.com/docs)
- [Express.js Documentation](https://expressjs.com/)

## Testing the UI

1. Access the test dashboard: `http://localhost:5000/test-dashboard.html`
2. This page demonstrates all UI enhancements including:
   - Gradient buttons with hover animations
   - Modern form inputs with floating labels
   - Notification system with icons
   - Enhanced job cards and widgets
   - Tabbed navigation with animations