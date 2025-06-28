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
    && unzip /tmp/sdk_archives/dartsdk-linux-x64-release.zip -d /usr/lib/dart \
    && rm -rf /tmp/sdk_archives

# Symlink flutter and dart into /usr/local/bin for easy access
RUN ln -s /usr/local/flutter/bin/flutter /usr/local/bin/flutter \
 && ln -s /usr/local/flutter/bin/cache/dart-sdk/bin/dart /usr/local/bin/dart

# Expose environment variables for both build and runtime
ENV FLUTTER_HOME=/usr/local/flutter
ENV DART_HOME=/usr/lib/dart
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$DART_HOME/bin:${PATH}"

# Verify installations at build time
RUN which flutter && flutter --version && which dart && dart --version

# Ensure Flutter & Dart are always on PATH
RUN printf 'export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:/usr/local/bin:$PATH"\n' \
    > /etc/profile.d/sdk-path.sh \
 && chmod +x /etc/profile.d/sdk-path.sh

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
