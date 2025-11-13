#!/bin/bash

################################################################################
# Build Instructions for Debian Trixie
################################################################################

echo "========================================="
echo "Financial Management App - Build Setup"
echo "========================================="
echo ""
echo "This script will build an Android APK for your Debian system."
echo ""
echo "REQUIREMENTS:"
echo "  - Debian 13 (Trixie)"
echo "  - Internet connection"
echo "  - ~2GB free disk space"
echo "  - 10-30 minutes (first build)"
echo ""
echo "WHAT WILL BE INSTALLED:"
echo "  ✓ Flutter SDK (~1GB)"
echo "  ✓ Android SDK (~500MB)"
echo "  ✓ Java Development Kit"
echo "  ✓ Build tools (git, cmake, etc.)"
echo ""
echo "========================================="
echo ""
read -p "Continue with installation? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 1
fi

echo ""
echo "Starting build process..."
echo ""

# Run the main build script
./build_android.sh

echo ""
echo "========================================="
echo "Build complete!"
echo "========================================="
