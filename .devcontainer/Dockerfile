FROM ubuntu:22.04

# Install dependencies for Dart installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip ca-certificates xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Download and install Dart SDK 3.4.0
RUN wget -O /tmp/dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/3.4.0/sdk/dartsdk-linux-x64-release.zip && \
    unzip /tmp/dart-sdk.zip -d /usr/local && \
    mv /usr/local/dart-sdk /usr/local/dart && \
    rm /tmp/dart-sdk.zip

# Set PATH for Dart
ENV PATH="/usr/local/dart/bin:${PATH}"

# Verify installation
RUN dart --version

