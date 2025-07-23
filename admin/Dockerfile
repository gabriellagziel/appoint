FROM nginx:alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Copy static files
COPY public /var/www/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 8080
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/admin || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]