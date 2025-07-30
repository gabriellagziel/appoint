# Multi-stage Dockerfile for Functions/API Service
# Based on Node.js 22 Alpine for optimal size and security

# Stage 1: Dependencies
FROM node:22-alpine AS deps
WORKDIR /app

# Install dependencies needed for native modules
RUN apk add --no-cache \
    libc6-compat \
    python3 \
    make \
    g++

# Copy package files
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Stage 2: Builder
FROM node:22-alpine AS builder
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache \
    libc6-compat \
    python3 \
    make \
    g++

# Copy package files and install all dependencies
COPY package*.json ./
COPY tsconfig.json ./
RUN npm ci

# Copy source code
COPY src/ ./src/
COPY index.js ./
COPY jest.config.js ./

# Build TypeScript
RUN npm run build

# Stage 3: Development (optional, for development mode)
FROM node:22-alpine AS development
WORKDIR /app

# Install runtime and build dependencies
RUN apk add --no-cache \
    libc6-compat \
    curl \
    python3 \
    make \
    g++

# Copy package files and install all dependencies (including dev)
COPY package*.json ./
COPY tsconfig.json ./
RUN npm ci

# Copy source code
COPY . .

# Build for development
RUN npm run build

ENV NODE_ENV=development
EXPOSE 8080

CMD ["npm", "run", "dev"]

# Stage 4: Production Runtime
FROM node:22-alpine AS production

# Install runtime dependencies
RUN apk add --no-cache \
    curl \
    tzdata \
    fontconfig \
    ttf-dejavu \
    dumb-init \
    && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S functions -u 1001 -G nodejs

WORKDIR /app

# Copy production dependencies
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package*.json ./

# Copy built application
COPY --from=builder --chown=functions:nodejs /app/dist ./dist
COPY --from=builder --chown=functions:nodejs /app/index.js ./

# Copy configuration files
COPY --chown=functions:nodejs tsconfig.json ./

# Create logs directory
RUN mkdir -p logs && chown functions:nodejs logs

# Switch to non-root user
USER functions

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080
ENV HOSTNAME=0.0.0.0
ENV NODE_OPTIONS="--max-old-space-size=1024"

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/ping || exit 1

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "index.js"]