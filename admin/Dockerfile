FROM ghcr.io/cirruslabs/flutter:3.24.5

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy pubspec files first for better caching
COPY pubspec.yaml pubspec.lock ./

# Get Flutter dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build Flutter web app
RUN flutter build web --release --base-href="/admin/"

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built files to nginx directory
RUN cp -r build/web/* /var/www/html/

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/admin/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]