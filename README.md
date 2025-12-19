Flutter Docker Image (Multi-Arch)
====================================

[![CI](https://github.com/opsdev-ws/flutter-docker-image/actions/workflows/build-push.yml/badge.svg?branch=main "CI")](https://github.com/opsdev-ws/flutter-docker-image/actions?query=workflow%3A%22Build+and+Push+Flutter+Image%22+branch%3Amain)

**Multi-architecture Flutter Docker image supporting ARM64 and AMD64**

[GitHub Container Registry](https://github.com/orgs/opsdev-ws/packages?repo_name=flutter-docker-image)

Based on [`ghcr.io/cirruslabs/android-sdk` Docker image][2].

> **Note**: This is a fork of [instrumentisto/flutter-docker-image][90] optimized for:
> - **ARM64 support** (linux/arm64, linux/amd64)
> - **Web + Android builds** (Linux desktop toolchain removed)
> - **Non-root user compatibility** (UID 1000)
> - **Lighter image size** (removed unnecessary build tools)


## Supported Platforms

- **linux/amd64** (Intel/AMD 64-bit)
- **linux/arm64** (ARM 64-bit - Apple Silicon, AWS Graviton, etc.)


## Supported Tags

- `3.38.5`, `latest` - Flutter 3.38.5 with Android SDK 36


## Supported Toolchains

- ✅ **Android** - Full Android SDK for mobile app builds
- ✅ **Web** - Web development support
- ❌ **Linux Desktop** - Removed to reduce image size (not needed for web/mobile)


## What is [Flutter]?

[Flutter] is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase.

This image contains the necessary toolkit for building [Flutter] applications for **Android** and **Web** platforms.

> [flutter.dev](https://flutter.dev)

![Flutter Logo](https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png)


## How to Use This Image

### Pull the Image

```bash
# Pull latest version
docker pull ghcr.io/opsdev-ws/flutter:latest

# Pull specific version
docker pull ghcr.io/opsdev-ws/flutter:3.38.5
```

### Run Flutter Commands

Mount your project directory and run the necessary `flutter` command:

```bash
docker run --rm -v /my/flutter/project:/app -w /app ghcr.io/opsdev-ws/flutter:3.38.5 \
    flutter doctor
```

### Build a Flutter Web App

```bash
docker run --rm -v $(pwd):/app -w /app ghcr.io/opsdev-ws/flutter:3.38.5 \
    flutter build web --dart-define BASE_URL=/api
```

### Build a Flutter Android App

```bash
docker run --rm -v $(pwd):/app -w /app ghcr.io/opsdev-ws/flutter:3.38.5 \
    flutter build apk --release
```


## Non-Root Usage

**This image is designed for non-root usage!** Run as user `1000:1000`:

```bash
docker run --rm --user 1000:1000 \
           -v /my/flutter/project:/app -w /app ghcr.io/opsdev-ws/flutter:3.38.5 \
    flutter doctor
```

**Key Features for Non-Root:**
- Git repository permissions configured for all users
- Flutter cache directories writable by UID 1000
- No permission errors when running `flutter doctor`


## Multi-Architecture Support

This image is built for multiple architectures:

```bash
# Verify multi-arch manifest
docker manifest inspect ghcr.io/opsdev-ws/flutter:3.38.5
```

**Automatic Platform Selection:**
Docker automatically pulls the correct architecture for your system:
- Apple Silicon Macs → `linux/arm64`
- Intel/AMD systems → `linux/amd64`
- AWS Graviton → `linux/arm64`
- GitLab ARM64 runners → `linux/arm64`


## Using in CI/CD

### GitLab CI Example

```yaml
test:
  stage: test
  image: ghcr.io/opsdev-ws/flutter:3.38.5
  before_script:
    - flutter pub get
  script:
    - flutter analyze
    - flutter test
  tags:
    - docker  # Works on both x86_64 and ARM64 runners
```

### GitHub Actions Example

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/opsdev-ws/flutter:3.38.5
    steps:
      - uses: actions/checkout@v4
      - run: flutter pub get
      - run: flutter test
```


## Image Details

### Included Tools

- **Flutter SDK** (installed via git clone for multi-arch support)
- **Dart SDK** (automatically downloaded for target architecture)
- **Android SDK** (API level 36)
- **Git** (for Flutter repository management)

### What's Different from instrumentisto/flutter?

| Feature | opsdev-ws/flutter | instrumentisto/flutter |
|---------|-------------------|------------------------|
| ARM64 Support | ✅ Yes | ❌ No |
| AMD64 Support | ✅ Yes | ✅ Yes |
| Linux Desktop Toolchain | ❌ Removed | ✅ Included |
| Non-root Compatible | ✅ Fully tested | ⚠️ Partial |
| Installation Method | Git clone | Tarball download |
| Image Size | Smaller | Larger |


## Building Locally

```bash
# Build for your current architecture
docker build -t flutter:local .

# Build multi-arch (requires Docker Buildx)
docker buildx build --platform linux/amd64,linux/arm64 -t flutter:multi .
```


## License

[Flutter] is licensed under [BSD 3-Clause "New" or "Revised" license][92].

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

This repository is a fork of [instrumentisto/flutter-docker-image][90] and maintains compatibility with its licensing terms.


## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue][80].


## Credits

This project is a fork of [instrumentisto/flutter-docker-image][90], modified to add ARM64 support and optimize for web/Android builds.

Special thanks to the original [instrumentisto][95] team for creating the base Flutter Docker image.


[Android SDK]: https://developer.android.com/studio
[Flutter]: https://flutter.dev

[2]: https://github.com/cirruslabs/docker-images-android/pkgs/container/android-sdk

[80]: https://github.com/opsdev-ws/flutter-docker-image/issues
[90]: https://github.com/instrumentisto/flutter-docker-image
[92]: https://github.com/flutter/flutter/blob/master/LICENSE
[95]: https://github.com/instrumentisto
