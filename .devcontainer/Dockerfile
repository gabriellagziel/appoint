# Use an official lightweight base image
FROM ubuntu:22.04

# Copy pre-downloaded SDK archives into the container
COPY sdk_archives /tmp/sdk_archives

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter 3.32.0 and Dart 3.4.0 from local archives
RUN tar xf /tmp/sdk_archives/flutter_linux_3.32.0-stable.tar.xz -C /usr/local \
    && unzip -q /tmp/sdk_archives/dartsdk-linux-x64-release.zip -d /usr/lib \
    && mv /usr/lib/dart-sdk /usr/lib/dart \
    && rm -rf /tmp/sdk_archives

# Expose environment variables for both build and runtime
ENV FLUTTER_HOME=/usr/local/flutter
ENV DART_HOME=/usr/lib/dart
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$DART_HOME/bin:${PATH}"
RUN ln -s $FLUTTER_HOME/bin/flutter /usr/local/bin/flutter \
    && ln -s $DART_HOME/bin/dart      /usr/local/bin/dart

# Verify installations at build time
RUN which flutter && flutter --version && which dart && dart --version

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
