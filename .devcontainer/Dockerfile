# Use an official lightweight base image
FROM ubuntu:22.04

# Copy pre-downloaded SDK archives into the container
COPY sdk_archives /tmp/sdk_archives

# Install dependencies and set up Dart APT repo
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    gnupg \
    curl \
    unzip \
    git \
    xz-utils \
    zip \
  && curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart-archive-keyring.gpg \
  && printf "deb [signed-by=/usr/share/keyrings/dart-archive-keyring.gpg] https://storage.googleapis.com/dart-archive/channels/stable/release/3.4.0/sdk/ stable main" > /etc/apt/sources.list.d/dart_stable.list \
  && apt-get update \
  && apt-get install -y dart=3.4.0-1 \
  && rm -rf /var/lib/apt/lists/*

# Install Flutter 3.32.0 from local archive
RUN tar xf /tmp/sdk_archives/flutter_linux_3.32.0-stable.tar.xz -C /usr/local \
    && rm -rf /tmp/sdk_archives

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
RUN flutter pub get && dart pub get

# Copy app sources after caching dependencies
COPY . .

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
