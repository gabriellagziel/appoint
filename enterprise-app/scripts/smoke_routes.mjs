#!/usr/bin/env node

import { spawn } from 'child_process';
import http from 'http';

const BASE_URL = 'http://localhost:5000';
const REQUIRED_ROUTES = [
  '/',
  '/register',
  '/login',
  '/docs',
  '/confirm',
  '/unauthorized',
  '/pending'
];

let devServer = null;

function startDevServer() {
  return new Promise((resolve, reject) => {
    console.log('Starting development server...');
    
    devServer = spawn('npm', ['run', 'dev:5000'], {
      stdio: 'pipe',
      shell: true
    });

    devServer.stdout.on('data', (data) => {
      const output = data.toString();
      console.log(output);
      
      if (output.includes('Ready') || output.includes('Local:')) {
        console.log('Development server started successfully');
        setTimeout(resolve, 2000); // Give it a moment to fully start
      }
    });

    devServer.stderr.on('data', (data) => {
      console.error('Dev server error:', data.toString());
    });

    // Timeout after 30 seconds
    setTimeout(() => {
      reject(new Error('Dev server startup timeout'));
    }, 30000);
  });
}

function makeRequest(url) {
  return new Promise((resolve, reject) => {
    const req = http.get(url, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          headers: res.headers,
          data: data
        });
      });
    });

    req.on('error', (err) => {
      reject(err);
    });

    req.setTimeout(10000, () => {
      req.destroy();
      reject(new Error('Request timeout'));
    });
  });
}

async function testRoutes() {
  console.log('\n🧪 Testing routes...\n');
  
  const results = [];
  
  for (const route of REQUIRED_ROUTES) {
    const url = `${BASE_URL}${route}`;
    console.log(`Testing ${route}...`);
    
    try {
      const response = await makeRequest(url);
      const success = response.statusCode === 200;
      
      console.log(`  ${success ? '✅' : '❌'} ${route} - ${response.statusCode}`);
      
      results.push({
        route,
        statusCode: response.statusCode,
        success
      });
    } catch (error) {
      console.log(`  ❌ ${route} - Error: ${error.message}`);
      results.push({
        route,
        statusCode: 0,
        success: false,
        error: error.message
      });
    }
  }
  
  return results;
}

function stopDevServer() {
  if (devServer) {
    console.log('\n🛑 Stopping development server...');
    devServer.kill('SIGTERM');
  }
}

async function main() {
  try {
    await startDevServer();
    
    const results = await testRoutes();
    
    console.log('\n📊 Test Results:');
    console.log('================');
    
    const passed = results.filter(r => r.success).length;
    const total = results.length;
    
    results.forEach(result => {
      const icon = result.success ? '✅' : '❌';
      console.log(`${icon} ${result.route}: ${result.statusCode}${result.error ? ` (${result.error})` : ''}`);
    });
    
    console.log(`\n${passed}/${total} routes passed`);
    
    if (passed === total) {
      console.log('🎉 All routes are working correctly!');
      process.exit(0);
    } else {
      console.log('❌ Some routes failed. Please check the implementation.');
      process.exit(1);
    }
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    process.exit(1);
  } finally {
    stopDevServer();
  }
}

// Handle process termination
process.on('SIGINT', () => {
  console.log('\n🛑 Received SIGINT, cleaning up...');
  stopDevServer();
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n🛑 Received SIGTERM, cleaning up...');
  stopDevServer();
  process.exit(0);
});

main();
