#!/bin/bash

################################################################################
# Flutter Build Script for Debian GNU/Linux 13 (Trixie)
# Financial Management App - Android APK Builder
#
# This script will:
# 1. Check system requirements
# 2. Install necessary dependencies
# 3. Install Flutter SDK
# 4. Install Android SDK and build tools
# 5. Generate code files
# 6. Build release APK
#
# Usage: ./build_android.sh
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FLUTTER_VERSION="3.24.5"
ANDROID_SDK_VERSION="11076708"
ANDROID_BUILD_TOOLS_VERSION="34.0.0"
ANDROID_PLATFORM_VERSION="34"

# Paths
HOME_DIR="$HOME"
FLUTTER_DIR="$HOME_DIR/flutter"
ANDROID_SDK_DIR="$HOME_DIR/android-sdk"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        print_success "$1 is installed"
        return 0
    else
        print_warning "$1 is not installed"
        return 1
    fi
}

################################################################################
# System Check
################################################################################

print_header "Checking System Requirements"

# Check OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    print_info "OS: $PRETTY_NAME"
else
    print_error "Cannot detect OS version"
    exit 1
fi

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run this script as root"
    exit 1
fi

################################################################################
# Install System Dependencies
################################################################################

print_header "Installing System Dependencies"

print_info "Updating package lists..."
sudo apt-get update

print_info "Installing required packages..."
sudo apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev

print_success "System dependencies installed"

################################################################################
# Install Flutter SDK
################################################################################

print_header "Setting Up Flutter SDK"

if [ -d "$FLUTTER_DIR" ]; then
    print_info "Flutter directory exists, checking version..."
    cd "$FLUTTER_DIR"
    CURRENT_VERSION=$(git describe --tags 2>/dev/null || echo "unknown")
    print_info "Current Flutter version: $CURRENT_VERSION"
    
    print_info "Updating Flutter..."
    git fetch --tags
    git checkout stable
    git pull
else
    print_info "Downloading Flutter SDK..."
    cd "$HOME_DIR"
    git clone https://github.com/flutter/flutter.git -b stable
fi

# Add Flutter to PATH for this session
export PATH="$FLUTTER_DIR/bin:$PATH"

print_success "Flutter SDK installed at $FLUTTER_DIR"

################################################################################
# Configure Flutter
################################################################################

print_header "Configuring Flutter"

# Disable analytics
flutter config --no-analytics

# Accept licenses
print_info "Accepting Android licenses..."
yes | flutter doctor --android-licenses 2>/dev/null || true

# Run flutter doctor
print_info "Running Flutter Doctor..."
flutter doctor -v

################################################################################
# Install Android SDK
################################################################################

print_header "Setting Up Android SDK"

if [ ! -d "$ANDROID_SDK_DIR" ]; then
    print_info "Creating Android SDK directory..."
    mkdir -p "$ANDROID_SDK_DIR"
    
    print_info "Downloading Android Command Line Tools..."
    cd "$ANDROID_SDK_DIR"
    wget "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip" -O cmdline-tools.zip
    
    print_info "Extracting Android Command Line Tools..."
    unzip -q cmdline-tools.zip
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/bin cmdline-tools/latest/
    mv cmdline-tools/lib cmdline-tools/latest/
    rm cmdline-tools.zip
    
    print_success "Android Command Line Tools installed"
else
    print_info "Android SDK directory exists"
fi

# Set Android SDK environment variables
export ANDROID_HOME="$ANDROID_SDK_DIR"
export ANDROID_SDK_ROOT="$ANDROID_SDK_DIR"
export PATH="$ANDROID_SDK_DIR/cmdline-tools/latest/bin:$ANDROID_SDK_DIR/platform-tools:$PATH"

# Install required Android SDK components
print_info "Installing Android SDK components..."
yes | sdkmanager --sdk_root="$ANDROID_SDK_DIR" "platform-tools" "platforms;android-${ANDROID_PLATFORM_VERSION}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" 2>/dev/null || true

print_success "Android SDK configured"

################################################################################
# Configure Environment
################################################################################

print_header "Configuring Environment Variables"

# Create/update shell profile
SHELL_PROFILE="$HOME/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
    SHELL_PROFILE="$HOME/.zshrc"
fi

# Add Flutter to PATH permanently
if ! grep -q "flutter/bin" "$SHELL_PROFILE"; then
    print_info "Adding Flutter to PATH in $SHELL_PROFILE..."
    cat >> "$SHELL_PROFILE" << EOF

# Flutter SDK
export PATH="\$HOME/flutter/bin:\$PATH"

# Android SDK
export ANDROID_HOME="\$HOME/android-sdk"
export ANDROID_SDK_ROOT="\$HOME/android-sdk"
export PATH="\$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:\$ANDROID_SDK_ROOT/platform-tools:\$PATH"
EOF
    print_success "Environment variables added to $SHELL_PROFILE"
else
    print_info "Flutter already in PATH"
fi

################################################################################
# Prepare Project
################################################################################

print_header "Preparing Flutter Project"

cd "$PROJECT_DIR"

print_info "Cleaning previous builds..."
flutter clean

print_info "Getting Flutter dependencies..."
flutter pub get

print_info "Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

print_success "Project prepared"

################################################################################
# Build APK
################################################################################

print_header "Building Android APK"

print_info "Building release APK..."
print_info "This may take several minutes..."

flutter build apk --release --split-per-abi

print_success "APK build complete!"

################################################################################
# Output Results
################################################################################

print_header "Build Results"

APK_DIR="$PROJECT_DIR/build/app/outputs/flutter-apk"

if [ -d "$APK_DIR" ]; then
    print_success "APK files generated:"
    echo ""
    
    ls -lh "$APK_DIR"/*.apk 2>/dev/null | while read -r line; do
        echo "  $line"
    done
    
    echo ""
    print_info "APK Location: $APK_DIR"
    echo ""
    
    # Show file sizes
    print_info "APK File Sizes:"
    for apk in "$APK_DIR"/*.apk; do
        if [ -f "$apk" ]; then
            SIZE=$(du -h "$apk" | cut -f1)
            FILENAME=$(basename "$apk")
            echo "  - $FILENAME: $SIZE"
        fi
    done
    
    echo ""
    print_info "Install APK on device with:"
    echo "  adb install $APK_DIR/app-release.apk"
    echo ""
    print_info "Or install specific ABI:"
    echo "  adb install $APK_DIR/app-armeabi-v7a-release.apk  (32-bit ARM)"
    echo "  adb install $APK_DIR/app-arm64-v8a-release.apk    (64-bit ARM)"
    echo "  adb install $APK_DIR/app-x86_64-release.apk       (64-bit x86)"
else
    print_error "APK directory not found!"
    exit 1
fi

################################################################################
# Summary
################################################################################

print_header "Build Summary"

echo ""
print_success "✓ System dependencies installed"
print_success "✓ Flutter SDK installed"
print_success "✓ Android SDK configured"
print_success "✓ Project dependencies resolved"
print_success "✓ Code generation complete"
print_success "✓ APK built successfully"
echo ""

print_info "To run Flutter Doctor, use:"
echo "  flutter doctor -v"
echo ""

print_info "To rebuild the app, use:"
echo "  flutter build apk --release"
echo ""

print_success "Build completed successfully! 🎉"
echo ""

################################################################################
# Create APK Info File
################################################################################

INFO_FILE="$APK_DIR/BUILD_INFO.txt"
cat > "$INFO_FILE" << EOF
Financial Management App - Build Information
=============================================

Build Date: $(date)
Flutter Version: $(flutter --version | head -n 1)
Dart Version: $(dart --version)
OS: $PRETTY_NAME

APK Files:
$(ls -lh "$APK_DIR"/*.apk)

Installation Instructions:
--------------------------
1. Enable "Install from Unknown Sources" on your Android device
2. Transfer the APK file to your device
3. Open the APK file on your device to install

Or use ADB:
  adb install app-arm64-v8a-release.apk

Choose the correct ABI for your device:
- app-armeabi-v7a-release.apk: 32-bit ARM devices (older phones)
- app-arm64-v8a-release.apk: 64-bit ARM devices (most modern phones)
- app-x86_64-release.apk: 64-bit Intel/AMD devices (emulators)
EOF

print_success "Build info saved to: $INFO_FILE"
