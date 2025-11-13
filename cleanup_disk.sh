#!/bin/bash

# Disk Space Cleanup Script for Flutter Build
# This script safely cleans up temporary files and caches

set -e

echo "========================================"
echo "Checking Disk Space"
echo "========================================"
df -h

echo ""
echo "========================================"
echo "Cleaning Up"
echo "========================================"

# Clean Gradle caches (can be re-downloaded)
echo "ℹ Cleaning Gradle caches..."
if [ -d "$HOME/.gradle/caches" ]; then
    du -sh "$HOME/.gradle/caches" 2>/dev/null || true
    rm -rf "$HOME/.gradle/caches"
    echo "✓ Gradle caches cleaned"
fi

# Clean Gradle daemon files
echo "ℹ Cleaning Gradle daemon..."
if [ -d "$HOME/.gradle/daemon" ]; then
    du -sh "$HOME/.gradle/daemon" 2>/dev/null || true
    rm -rf "$HOME/.gradle/daemon"
    echo "✓ Gradle daemon cleaned"
fi

# Clean Flutter build cache
echo "ℹ Cleaning Flutter build cache..."
if [ -d "android/.gradle" ]; then
    du -sh android/.gradle 2>/dev/null || true
    rm -rf android/.gradle
    echo "✓ Android Gradle cache cleaned"
fi

if [ -d "build" ]; then
    du -sh build 2>/dev/null || true
    rm -rf build
    echo "✓ Build directory cleaned"
fi

# Clean Flutter SDK caches
echo "ℹ Cleaning Flutter SDK caches..."
if [ -d "$HOME/flutter/bin/cache" ]; then
    du -sh "$HOME/flutter/bin/cache" 2>/dev/null || true
    rm -rf "$HOME/flutter/bin/cache"
    echo "✓ Flutter cache cleaned"
fi

# Clean Android SDK temp files
echo "ℹ Cleaning Android SDK temp..."
if [ -d "/opt/android-sdk/temp" ]; then
    du -sh "/opt/android-sdk/temp" 2>/dev/null || true
    rm -rf "/opt/android-sdk/temp"
    echo "✓ Android temp cleaned"
fi

# Clean APT cache (if running as root)
if [ "$EUID" -eq 0 ]; then
    echo "ℹ Cleaning APT cache..."
    apt-get clean 2>/dev/null || true
    echo "✓ APT cache cleaned"
fi

# Clean old log files
echo "ℹ Cleaning old logs..."
find /tmp -type f -name "*.log" -mtime +7 -delete 2>/dev/null || true
find /var/log -type f -name "*.gz" -delete 2>/dev/null || true
echo "✓ Old logs cleaned"

# Clean temporary files
echo "ℹ Cleaning temp files..."
rm -rf /tmp/flutter* 2>/dev/null || true
rm -rf /tmp/gradle* 2>/dev/null || true
echo "✓ Temp files cleaned"

echo ""
echo "========================================"
echo "Disk Space After Cleanup"
echo "========================================"
df -h

echo ""
echo "✓ Cleanup complete!"
echo ""
echo "You can now retry the build with: ./build_android.sh"
