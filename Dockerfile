# https://github.com/cirruslabs/docker-images-android/pkgs/container/android-sdk
# https://github.com/cirruslabs/docker-images-android/blob/master/sdk/36/Dockerfile
ARG android_sdk_ver=36
FROM ghcr.io/cirruslabs/android-sdk:${android_sdk_ver}

ARG flutter_ver=3.38.5
ARG build_rev=0


# Install Flutter
ENV FLUTTER_HOME=/usr/local/flutter \
    FLUTTER_VERSION=${flutter_ver} \
    PATH=$PATH:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends --no-install-suggests \
            ca-certificates \
            git \
 && update-ca-certificates \
    \
 # Install Flutter via git clone (works on both x64 and arm64)
 && git clone --depth 1 --branch ${flutter_ver} https://github.com/flutter/flutter.git /usr/local/flutter \
 && git config --global --add safe.directory /usr/local/flutter \
 && git config --system --add safe.directory /usr/local/flutter \
 && flutter config --enable-android \
                   --enable-web \
                   --no-enable-linux-desktop \
                   --no-enable-ios \
 && flutter precache --universal --android --web --no-ios \
 && (yes | flutter doctor --android-licenses) \
 && flutter --version \
    \
 # Normalize all file ownership to root (UID 0) for compatibility with rootless containers
 # This fixes UID mapping issues in rootless Podman/Docker
 && chown -R 0:0 /usr/local/flutter \
 && chmod -R a+w /usr/local/flutter/bin/cache \
 && chmod -R a+w /usr/local/flutter/packages/flutter_tools/.dart_tool \
    \
 && rm -rf /var/lib/apt/lists/* \
           /tmp/*
