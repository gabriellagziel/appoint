# Multi-stage Dockerfile for Functions/API Service
# Based on Node.js 22 as specified in package.json engines

# Stage 1: Build stage
FROM node:22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    && ln -sf python3 /usr/bin/python

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
COPY tsconfig.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci --only=production=false

# Copy source code
COPY src/ ./src/
COPY *.js ./

# Build TypeScript to JavaScript
RUN npm run build

# Remove dev dependencies and clean cache
RUN npm prune --production && \
    npm cache clean --force

# Stage 2: Production stage
FROM node:22-alpine AS production

# Install runtime dependencies for PDF generation and other features
RUN apk add --no-cache \
    curl \
    tzdata \
    fontconfig \
    ttf-dejavu \
    && rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S appuser -u 1001 -G nodejs

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY --from=builder /app/package*.json ./

# Copy production node_modules from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy built JavaScript files and necessary assets
COPY --from=builder /app/index.js ./
COPY --from=builder /app/dist ./dist

# Copy any additional runtime files if they exist
COPY --chown=appuser:nodejs .eslintrc.js .prettierrc jest.config.js ./

# Change ownership of the app directory
RUN chown -R appuser:nodejs /app

# Switch to non-root user
USER appuser

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080
ENV HOSTNAME=0.0.0.0

# Expose the port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start the application
CMD ["npm", "start"]