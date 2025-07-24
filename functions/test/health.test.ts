import request from 'supertest';
import app from '../src/server';
import { HealthStatus } from '../src/health';

describe('Health Check Endpoints', () => {
  describe('GET /health', () => {
    it('should return healthy status with all required fields', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      const body: HealthStatus = response.body;

      expect(body).toHaveProperty('status', 'healthy');
      expect(body).toHaveProperty('timestamp');
      expect(body).toHaveProperty('service', 'app-oint-functions');
      expect(body).toHaveProperty('version');
      expect(body).toHaveProperty('uptime');
      expect(body).toHaveProperty('environment');

      // Validate timestamp format
      expect(new Date(body.timestamp)).toBeInstanceOf(Date);
      expect(body.timestamp).toMatch(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$/);

      // Validate uptime is a number
      expect(typeof body.uptime).toBe('number');
      expect(body.uptime).toBeGreaterThanOrEqual(0);

      // Validate version format
      expect(typeof body.version).toBe('string');
      expect(body.version).toMatch(/^\d+\.\d+\.\d+$/);

      // Validate environment
      expect(typeof body.environment).toBe('string');
    });

    it('should include dependencies in non-test environment', async () => {
      const originalEnv = process.env.NODE_ENV;
      process.env.NODE_ENV = 'development';

      const response = await request(app)
        .get('/health')
        .expect(200);

      const body: HealthStatus = response.body;

      expect(body).toHaveProperty('dependencies');
      expect(body.dependencies).toHaveProperty('database');
      expect(body.dependencies).toHaveProperty('redis');
      expect(body.dependencies).toHaveProperty('firebase');

      // Restore original environment
      process.env.NODE_ENV = originalEnv;
    });

    it('should have correct content-type header', async () => {
      await request(app)
        .get('/health')
        .expect(200)
        .expect('Content-Type', /json/);
    });
  });

  describe('GET /api/health', () => {
    it('should work as an alias to /health', async () => {
      const response = await request(app)
        .get('/api/health')
        .expect(200);

      const body: HealthStatus = response.body;

      expect(body).toHaveProperty('status', 'healthy');
      expect(body).toHaveProperty('service', 'app-oint-functions');
    });
  });

  describe('GET /ping', () => {
    it('should return simple OK response', async () => {
      const response = await request(app)
        .get('/ping')
        .expect(200);

      expect(response.text).toBe('OK');
    });

    it('should have text content-type', async () => {
      await request(app)
        .get('/ping')
        .expect(200)
        .expect('Content-Type', /text/);
    });
  });

  describe('GET /api/status', () => {
    it('should return API status information', async () => {
      const response = await request(app)
        .get('/api/status')
        .expect(200);

      expect(response.body).toHaveProperty('message', 'App-Oint Functions API is running');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('version');

      // Validate timestamp format
      expect(new Date(response.body.timestamp)).toBeInstanceOf(Date);
    });
  });

  describe('Error handling', () => {
    it('should return 404 for non-existent routes', async () => {
      const response = await request(app)
        .get('/non-existent-route')
        .expect(404);

      expect(response.body).toHaveProperty('error', 'Not Found');
      expect(response.body).toHaveProperty('message');
      expect(response.body).toHaveProperty('timestamp');
    });

    it('should handle HEAD requests to health endpoints', async () => {
      await request(app)
        .head('/health')
        .expect(200);

      await request(app)
        .head('/ping')
        .expect(200);
    });
  });

  describe('CORS headers', () => {
    it('should include CORS headers in health check response', async () => {
      await request(app)
        .get('/health')
        .expect(200)
        .expect('Access-Control-Allow-Origin', '*');
    });

    it('should handle preflight OPTIONS requests', async () => {
      await request(app)
        .options('/health')
        .expect(204);
    });
  });
});