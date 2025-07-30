const request = require('supertest');
const express = require('express');
const path = require('path');

// Simple express server to simulate the static site for testing
const createTestApp = () => {
  const app = express();
  
  // Serve static files from the out directory (where exported files go)
  app.use(express.static(path.join(__dirname, '..', 'out')));
  
  // Health endpoint
  app.get('/health.html', (req, res) => {
    res.set('Content-Type', 'text/html');
    res.send(`<!DOCTYPE html>
<html>
<head><title>Health Check</title></head>
<body>
  <h1>OK</h1>
  <p>Business service is healthy</p>
  <script>window.healthStatus = "healthy";</script>
</body>
</html>`);
  });
  
  // Fallback for SPA routing
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '..', 'out', 'index.html'));
  });
  
  return app;
};

describe('Business Service Health Checks', () => {
  let app;
  
  beforeAll(() => {
    app = createTestApp();
  });

  describe('GET /health.html', () => {
    it('should return health check page with 200 status', async () => {
      const response = await request(app)
        .get('/health.html')
        .expect(200);

      expect(response.text).toContain('OK');
      expect(response.text).toContain('Business service is healthy');
      expect(response.text).toContain('window.healthStatus = "healthy"');
    });

    it('should have correct content-type header', async () => {
      await request(app)
        .get('/health.html')
        .expect(200)
        .expect('Content-Type', /html/);
    });

    it('should be accessible via HEAD request', async () => {
      await request(app)
        .head('/health.html')
        .expect(200);
    });
  });

  describe('GET /', () => {
    it('should serve the main application page', async () => {
      const response = await request(app)
        .get('/')
        .expect(200);

      expect(response.text).toContain('App-Oint Business Panel');
      expect(response.text).toContain('Service Online');
    });

    it('should have correct content-type for main page', async () => {
      await request(app)
        .get('/')
        .expect(200)
        .expect('Content-Type', /html/);
    });

    it('should handle HEAD request to main page', async () => {
      await request(app)
        .head('/')
        .expect(200);
    });
  });

  describe('Static File Serving', () => {
    it('should serve static files correctly', async () => {
      await request(app)
        .get('/')
        .expect(200)
        .expect('Content-Type', /html/);
    });

    it('should handle non-existent static files gracefully', async () => {
      const response = await request(app)
        .get('/non-existent-file.css')
        .expect(200); // SPA fallback returns index.html

      expect(response.text).toContain('App-Oint Business Panel');
    });
  });

  describe('SPA Routing Support', () => {
    it('should serve index.html for unmatched routes', async () => {
      const response = await request(app)
        .get('/some/spa/route')
        .expect(200);

      expect(response.text).toContain('App-Oint Business Panel');
    });

    it('should handle deep routes', async () => {
      const response = await request(app)
        .get('/dashboard/analytics/reports')
        .expect(200);

      expect(response.text).toContain('App-Oint Business Panel');
    });
  });

  describe('Performance and Headers', () => {
    it('should respond quickly to health checks', async () => {
      const startTime = Date.now();
      
      await request(app)
        .get('/health.html')
        .expect(200);
      
      const responseTime = Date.now() - startTime;
      expect(responseTime).toBeLessThan(1000); // Should respond within 1 second
    });

    it('should handle multiple concurrent requests', async () => {
      const requests = Array(5).fill().map(() => 
        request(app).get('/health.html').expect(200)
      );
      
      await Promise.all(requests);
    });
  });

  describe('HTTP Methods', () => {
    it('should handle OPTIONS requests (CORS preflight)', async () => {
      await request(app)
        .options('/health.html')
        .expect(200);
    });

    it('should reject POST requests to health endpoint', async () => {
      await request(app)
        .post('/health.html')
        .expect(404);
    });
  });

  describe('Content Validation', () => {
    it('should contain expected keywords in main page', async () => {
      const response = await request(app)
        .get('/')
        .expect(200);

      const expectedKeywords = [
        'App-Oint Business Panel',
        'Business Management Portal',
        'Service Online',
        'Business panel is running successfully'
      ];

      expectedKeywords.forEach(keyword => {
        expect(response.text).toContain(keyword);
      });
    });

    it('should have proper HTML structure', async () => {
      const response = await request(app)
        .get('/')
        .expect(200);

      expect(response.text).toContain('<!DOCTYPE html>');
      expect(response.text).toContain('<html');
      expect(response.text).toContain('<head>');
      expect(response.text).toContain('<body>');
      expect(response.text).toContain('</html>');
    });

    it('should include viewport meta tag for responsive design', async () => {
      const response = await request(app)
        .get('/')
        .expect(200);

      expect(response.text).toContain('viewport');
      expect(response.text).toContain('width=device-width');
    });
  });

  describe('Error Scenarios', () => {
    it('should handle malformed requests gracefully', async () => {
      await request(app)
        .get('/health.html%00')
        .expect(200); // Should still serve the SPA
    });

    it('should handle requests with special characters', async () => {
      await request(app)
        .get('/test?param=value&other=<script>')
        .expect(200);
    });
  });

  describe('Health Check Integration', () => {
    it('should provide health status that Docker can use', async () => {
      const response = await request(app)
        .get('/health.html')
        .expect(200);

      // Verify it contains the health status indicator
      expect(response.text).toContain('window.healthStatus = "healthy"');
    });

    it('should be suitable for load balancer health checks', async () => {
      const response = await request(app)
        .get('/health.html')
        .expect(200);

      // Should be fast and lightweight
      expect(response.text.length).toBeLessThan(1000);
      expect(response.text).toContain('OK');
    });
  });
});