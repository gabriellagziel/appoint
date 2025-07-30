# Use an official lightweight base image
FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    gnupg \
    curl \
    unzip \
    git \
    xz-utils \
    zip \
  && rm -rf /var/lib/apt/lists/*

# Copy pre-downloaded SDK archives
COPY .devcontainer/sdk_archives/flutter_linux_3.32.0-stable.tar.xz /tmp/
COPY .devcontainer/sdk_archives/dartsdk-linux-x64-release.zip  /tmp/

# Unpack Flutter
RUN tar xf /tmp/flutter_linux_3.32.0-stable.tar.xz -C /usr/local \
    && rm /tmp/flutter_linux_3.32.0-stable.tar.xz

# Unpack Dart
RUN unzip -q /tmp/dartsdk-linux-x64-release.zip -d /usr/lib \
    && mv /usr/lib/dart-sdk /usr/lib/dart \
    && rm /tmp/dartsdk-linux-x64-release.zip


# Install Firebase CLI
RUN curl -fsSL https://firebase.tools/bin/linux/v17/firebase-linux.zip -o firebase.zip \
    && unzip firebase.zip -d /usr/local/lib/firebase \
    && rm firebase.zip \
    && ln -s /usr/local/lib/firebase/bin/firebase /usr/local/bin/firebase

# Symlink flutter and dart into /usr/local/bin for easy access
RUN ln -s /usr/local/flutter/bin/flutter /usr/local/bin/flutter \
 && ln -s /usr/lib/dart/bin/dart /usr/local/bin/dart

# Expose environment variables for both build and runtime
ENV FLUTTER_HOME=/usr/local/flutter
ENV DART_HOME=/usr/lib/dart
ENV PATH="/usr/local/bin:/usr/lib/dart/bin:/usr/local/flutter/bin:${PATH}"
RUN ln -s $FLUTTER_HOME/bin/flutter /usr/local/bin/flutter \
    && ln -s $DART_HOME/bin/dart /usr/local/bin/dart
# Persist SDK paths for all shells
RUN printf 'export PATH="/usr/local/bin:/usr/lib/dart/bin:$PATH"\n' \
     >> /etc/profile.d/sdk-and-cli-paths.sh \
  && chmod +x /etc/profile.d/sdk-and-cli-paths.sh

# Verify installations at build time
RUN which flutter && flutter --version && which dart && dart --version && which firebase && firebase --version

# Stage 1 – Cache Dependencies
WORKDIR /workspace
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get && dart pub get \
    && tar czf /tmp/pub_cache.tar.gz ~/.pub-cache

# Copy app sources after caching dependencies
COPY . .

# Restore cached dependencies for subsequent steps
RUN mkdir -p ~/.pub-cache \
    && tar xzf /tmp/pub_cache.tar.gz -C ~

# Ensure Flutter & Dart are always on PATH
RUN printf 'export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:/usr/local/bin:$PATH"\n' \
    > /etc/profile.d/sdk-path.sh \
 && chmod +x /etc/profile.d/sdk-path.sh

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
