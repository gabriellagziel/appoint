FROM ghcr.io/cirruslabs/flutter:3.8.1
ENV PATH="$PATH:/flutter/bin"
WORKDIR /app
COPY . /app

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    zip \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    libwebkit2gtk-4.0-dev \
    libappindicator3-dev \
    librsvg2-dev \
    libgirepository1.0-dev \
    libblkid-dev \
    liblzma-dev \
    libsecret-1-dev \
    libjsoncpp-dev \
    libnotify-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Java (OpenJDK 17)
RUN apt-get update && apt-get install -y openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Firebase CLI
RUN npm install -g firebase-tools

# Install DigitalOcean CLI
RUN wget -q https://github.com/digitalocean/doctl/releases/latest/download/doctl-1.108.0-linux-amd64.tar.gz -O /tmp/doctl.tar.gz \
    && tar -xzf /tmp/doctl.tar.gz -C /tmp/ \
    && mv /tmp/doctl /usr/local/bin/ \
    && rm /tmp/doctl.tar.gz

# Install Fastlane
RUN apt-get update && apt-get install -y ruby-full \
    && gem install fastlane \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Verify Flutter installation
RUN flutter --version
RUN dart --version

# Set the default command
CMD ["/bin/bash"]