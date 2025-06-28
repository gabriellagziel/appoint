FROM ubuntu:22.04

ARG DART_VERSION=3.4.0

# Install dependencies for Dart installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip ca-certificates xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Download and install Dart SDK
RUN wget -O /tmp/dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip && \
    unzip /tmp/dart-sdk.zip -d /usr/lib && \
    mv /usr/lib/dart-sdk /usr/lib/dart && \
    rm /tmp/dart-sdk.zip

# Set up Dart environment
ENV DART_HOME=/usr/lib/dart
ENV PATH="${DART_HOME}/bin:${PATH}"

# Verify installation at build time
RUN which dart && dart --version

