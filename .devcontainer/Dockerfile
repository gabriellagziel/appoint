# Use an official lightweight base image
FROM ubuntu:22.04

# Copy pre-downloaded Flutter archive into the container
COPY sdk_archives /tmp/sdk_archives

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter 3.32.0 from the local archive
RUN tar xf /tmp/sdk_archives/flutter_linux_3.32.0-stable.tar.xz -C /usr/local \
    && rm -rf /tmp/sdk_archives

# Install Dart 3.4.0 directly
RUN curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/3.4.0/sdk/dartsdk-linux-x64-release.zip \
        -o dartsdk.zip \
    && unzip -q dartsdk.zip -d /usr/lib \
    && mv /usr/lib/dart-sdk /usr/lib/dart \
    && rm dartsdk.zip

# Symlink flutter and dart into /usr/local/bin for easy access
RUN ln -s /usr/local/flutter/bin/flutter /usr/local/bin/flutter \
 && ln -s /usr/lib/dart/bin/dart /usr/local/bin/dart

# Expose environment variables for both build and runtime
ENV FLUTTER_HOME=/usr/local/flutter
ENV DART_HOME=/usr/lib/dart
ENV PATH="$FLUTTER_HOME/bin:$DART_HOME/bin:${PATH}"
RUN ln -s $FLUTTER_HOME/bin/flutter /usr/local/bin/flutter \
    && ln -s $DART_HOME/bin/dart      /usr/local/bin/dart
# Persist SDK paths for all shells
RUN printf 'PATH="/usr/local/flutter/bin:$DART_HOME/bin:/usr/local/bin:${PATH}"\n' \
     >> /etc/environment

# Verify installations at build time
RUN which flutter && flutter --version && which dart && dart --version
RUN dart --version

# Stage 1 – Cache Dependencies
WORKDIR /workspace
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get && dart pub get

# Copy app sources after caching dependencies
COPY . .

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
