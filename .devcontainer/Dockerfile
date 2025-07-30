FROM ubuntu:22.04

ARG DART_VERSION=3.4.0
ARG FLUTTER_VERSION=3.32.0

# Install dependencies for Dart & Flutter installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip ca-certificates xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Download and install Dart SDK
RUN wget -O /tmp/dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip && \
    unzip /tmp/dart-sdk.zip -d /usr/local && \
    mv /usr/local/dart-sdk /usr/local/dart && \
    rm /tmp/dart-sdk.zip

# Download and install Flutter SDK
RUN wget -O /tmp/flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    tar xf /tmp/flutter.tar.xz -C /usr/local && \
    rm /tmp/flutter.tar.xz

# Set PATH for Flutter and Dart
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Verify installation
RUN flutter --version && dart --version

