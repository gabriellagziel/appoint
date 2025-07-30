# Multi-stage Dockerfile for Business Static Site
# Optimized for production deployment with health checks

# Stage 1: Build Stage (Node.js for build tools)
FROM node:22-alpine AS builder
WORKDIR /app

# Install build dependencies if needed
RUN apk add --no-cache \
    curl \
    git

# Copy package files
COPY package*.json ./

# Install dependencies (if any)
RUN npm ci --only=production && npm cache clean --force

# Copy source files
COPY public/ ./public/
COPY *.conf ./

# Build the application (prepare static files)
RUN npm run export

# Stage 2: Development (optional, for development mode)
FROM node:22-alpine AS development
WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache curl

# Copy package files and install all dependencies
COPY package*.json ./
RUN npm ci

# Copy source files
COPY . .

# Build for development
RUN npm run export

ENV NODE_ENV=development
EXPOSE 8081

# Use serve for development
CMD ["npm", "run", "serve"]

# Stage 3: Production Runtime (Nginx)
FROM nginx:1.25-alpine AS production

# Install dependencies for health checks and monitoring
RUN apk add --no-cache \
    curl \
    tzdata \
    tini \
    && rm -rf /var/cache/apk/*

# Create non-root user for better security
RUN addgroup -g 1001 -S business && \
    adduser -S business -u 1001 -G business

# Copy built static files from builder stage
COPY --from=builder --chown=business:business /app/out /var/www/html

# Copy nginx configuration
COPY --chown=business:business nginx.conf /etc/nginx/nginx.conf

# Create health check endpoint
RUN echo '<!DOCTYPE html><html><head><title>Health Check</title></head><body><h1>OK</h1><p>Business service is healthy</p><script>window.healthStatus = "healthy";</script></body></html>' > /var/www/html/health.html

# Create logs directory and set permissions
RUN mkdir -p /var/log/nginx /var/cache/nginx /var/run \
    && chown -R business:business /var/www/html /var/log/nginx /var/cache/nginx /var/run \
    && chmod -R 755 /var/www/html

# Set environment variables
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx
ENV NGINX_PORT=8081

# Expose port
EXPOSE 8081

# Health check - test both main page and health endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8081/health.html && curl -f http://localhost:8081/ || exit 1

# Use tini for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]

# Start nginx
CMD ["nginx", "-g", "daemon off;"]