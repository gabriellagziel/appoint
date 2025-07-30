# Use an official lightweight base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    xz-utils \
    zip \
    apt-transport-https \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter 3.32.0
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.0-stable.tar.xz \
    -o flutter.tar.xz \
  && tar xf flutter.tar.xz -C /usr/local \
  && rm flutter.tar.xz

# Install Dart 3.4.0
RUN curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/3.4.0/sdk/dartsdk-linux-x64-release.zip \
    -o dartsdk.zip \
  && unzip -q dartsdk.zip -d /usr/lib \
  && mv /usr/lib/dart-sdk /usr/lib/dart \
  && rm dartsdk.zip

# Expose environment variables for both build and runtime
ENV FLUTTER_HOME=/usr/local/flutter
ENV DART_HOME=/usr/lib/dart
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$DART_HOME/bin:${PATH}"

# Symlink into /usr/local/bin for all shells
RUN ln -s $FLUTTER_HOME/bin/flutter   /usr/local/bin/flutter \
 && ln -s $DART_HOME/bin/dart         /usr/local/bin/dart

# Verify installations at build time
RUN which flutter && flutter --version \
 && which dart    && dart --version

# Force every bash shell to pick up the SDK path
COPY devcontainer/bashrc_append.sh /etc/bash.bashrc.d/99-sdk-path.sh

# Ensure the script is executable (if your build context preserves permissions, you can omit this)
RUN chmod +x /etc/bash.bashrc.d/99-sdk-path.sh

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
