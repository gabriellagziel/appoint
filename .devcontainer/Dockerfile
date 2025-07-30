# Use an official lightweight base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter 3.32.0 and Dart 3.4.0
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.0-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz -C /usr/local \
    && rm flutter.tar.xz \
    && curl -L https://storage.googleapis.com/dart-archive/channels/stable/release/3.4.0/sdk/dartsdk-linux-x64-release.zip -o dart.zip \
    && unzip dart.zip -d /usr/lib/dart \
    && rm dart.zip

# Symlink flutter and dart into /usr/local/bin for easy access
RUN ln -s /usr/local/flutter/bin/flutter /usr/local/bin/flutter \
    && ln -s /usr/lib/dart/dart-sdk/bin/dart /usr/local/bin/dart \
    && rm -f /etc/profile.d/sdk-path.sh

# Expose environment variables for both build and runtime
ENV FLUTTER_HOME=/usr/local/flutter
ENV DART_HOME=/usr/lib/dart/dart-sdk
ENV PATH="$FLUTTER_HOME/bin:$DART_HOME/bin:${PATH}"

# Verify installations at build time
RUN which flutter && flutter --version && which dart && dart --version

# Force every shell to pick up the SDK path
COPY devcontainer/bashrc_append.sh /etc/bash.bashrc.d/99-sdk-path.sh

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
