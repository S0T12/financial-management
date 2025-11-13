#!/bin/bash

################################################################################
# Quick Build Script - For Rebuilding After Initial Setup
# Usage: ./quick_build.sh
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Flutter not found in PATH!${NC}"
    echo "Please run ./build_android.sh first to install Flutter"
    exit 1
fi

cd "$PROJECT_DIR"

print_header "Quick Rebuild"

print_info "Cleaning previous build..."
flutter clean

print_info "Getting dependencies..."
flutter pub get

print_info "Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

print_info "Building APK..."
flutter build apk --release --split-per-abi

print_header "Build Complete"

APK_DIR="$PROJECT_DIR/build/app/outputs/flutter-apk"

print_success "APK files:"
ls -lh "$APK_DIR"/*.apk

echo ""
print_info "Location: $APK_DIR"
print_success "Done! 🎉"
