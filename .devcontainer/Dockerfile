FROM ubuntu:22.04

ARG FLUTTER_VERSION=3.32.0
ARG DART_VERSION=3.4.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget unzip xz-utils ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
RUN wget -O /tmp/flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz && \
    tar -xJf /tmp/flutter.tar.xz -C /usr/local && \
    rm /tmp/flutter.tar.xz

# Install Dart SDK
RUN wget -O /tmp/dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip && \
    unzip /tmp/dart-sdk.zip -d /usr/lib && \
    mv /usr/lib/dart-sdk /usr/lib/dart && \
    rm /tmp/dart-sdk.zip

ENV FLUTTER_HOME=/usr/local/flutter
ENV DART_HOME=/usr/lib/dart
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$DART_HOME/bin:${PATH}"

RUN flutter --version && dart --version

