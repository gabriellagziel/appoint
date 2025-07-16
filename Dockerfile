# Flutter CI Environment for App-Oint
# Optimized for DigitalOcean App Platform and GitHub Actions

FROM ubuntu:22.04

# Set environment variables
ENV FLUTTER_VERSION=3.32.5
ENV DART_VERSION=3.5.4
ENV JAVA_VERSION=17
ENV NODE_VERSION=18
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Java JDK 17
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs

# Install Firebase Tools globally
RUN npm install -g firebase-tools

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /opt/flutter \
    && cd /opt/flutter \
    && git checkout $FLUTTER_VERSION

# Add Flutter to PATH
ENV PATH=$PATH:/opt/flutter/bin

# Pre-download Flutter dependencies
RUN flutter precache

# Install Flutter dependencies
RUN flutter doctor

# Create a non-root user
RUN useradd -m -s /bin/bash flutter
RUN chown -R flutter:flutter /opt/flutter

# Set up workspace
WORKDIR /workspace
RUN chown -R flutter:flutter /workspace

# Switch to non-root user
USER flutter

# Verify installations
RUN flutter --version
RUN dart --version
RUN java -version
RUN node --version
RUN npm --version
RUN firebase --version

# Set up Flutter cache directories
RUN mkdir -p /home/flutter/.pub-cache
RUN mkdir -p /home/flutter/.dart_tool

# Expose common ports
EXPOSE 8080 3000 5000

# Default command
CMD ["flutter", "doctor"]