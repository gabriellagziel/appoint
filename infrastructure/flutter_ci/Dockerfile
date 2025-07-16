FROM ubuntu:22.04

# Install base tools
RUN apt-get update && apt-get install -y \
    curl unzip git xz-utils zip libglu1-mesa openjdk-17-jdk nodejs npm jq

# Install Flutter
ARG FLUTTER_VERSION=3.32.5
RUN git clone https://github.com/flutter/flutter.git /opt/flutter && \
    cd /opt/flutter && \
    git checkout $FLUTTER_VERSION && \
    /opt/flutter/bin/flutter --version

# Add to PATH
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable Web and run doctor
RUN flutter config --enable-web && flutter doctor

# Install Firebase CLI (optional)
RUN npm install -g firebase-tools

WORKDIR /app