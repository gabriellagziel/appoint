// Jest setup file for business service tests

// Set test environment variables
process.env.NODE_ENV = 'test';
process.env.PORT = '8081';

// Mock console methods to reduce test noise (optional)
global.console = {
  ...console,
  // Uncomment to suppress logs during tests
  // log: jest.fn(),
  // info: jest.fn(),
  // warn: jest.fn(),
  // error: jest.fn(),
};

// Setup global test utilities
global.testUtils = {
  delay: (ms) => new Promise(resolve => setTimeout(resolve, ms))
};

// Mock any external services if needed
jest.setTimeout(10000);

// Ensure the out directory exists for tests
const fs = require('fs');
const path = require('path');

const outDir = path.join(__dirname, '..', 'out');
if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

// Create a test index.html file if it doesn't exist
const indexPath = path.join(outDir, 'index.html');
if (!fs.existsSync(indexPath)) {
  const indexContent = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>App-Oint Business Panel</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            max-width: 600px;
        }
        h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }
        .status {
            background: rgba(255,255,255,0.2);
            padding: 20px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        .status-ok {
            color: #4ade80;
            font-weight: bold;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏢 App-Oint Business Panel</h1>
        <p>Welcome to the App-Oint Business Management Portal</p>
        <div class="status">
            <div class="status-ok">✅ Service Online</div>
            <p>Business panel is running successfully</p>
        </div>
    </div>
</body>
</html>`;
  
  fs.writeFileSync(indexPath, indexContent);
}