#!/bin/bash

# SpiderMonkey Run Script
# Build and run SpiderMonkey examples

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_status "SpiderMonkey Build and Run Script"
print_status "================================="
echo

# Check if we're in the right directory
if [ ! -f "CMakeLists.txt" ] || [ ! -d "examples" ]; then
    print_error "Please run this script from the SpiderMonkey root directory"
    exit 1
fi

# Build the project
print_status "Building SpiderMonkey examples..."
./build.sh --clean --verbose

if [ $? -ne 0 ]; then
    print_error "Build failed!"
    exit 1
fi

print_success "Build completed successfully!"
echo

# Check if executables exist
BUILD_DIR="build"
BIN_DIR="$BUILD_DIR/bin"

if [ ! -d "$BIN_DIR" ]; then
    print_error "Binary directory not found: $BIN_DIR"
    exit 1
fi

# Find and run executables
print_status "Running SpiderMonkey examples..."
echo

# List of expected executables
EXPECTED_EXECUTABLES=("basic_js" "advanced_js" "interactive_js")
FOUND_EXECUTABLES=()

# Check which executables exist
for exe_name in "${EXPECTED_EXECUTABLES[@]}"; do
    exe_path="$BIN_DIR/$exe_name"
    if [ -x "$exe_path" ]; then
        FOUND_EXECUTABLES+=("$exe_path")
    fi
done

if [ ${#FOUND_EXECUTABLES[@]} -eq 0 ]; then
    print_warning "No executables found in $BIN_DIR"
    exit 1
fi

for exe in "${FOUND_EXECUTABLES[@]}"; do
    exe_name=$(basename "$exe")
    print_status "Running $exe_name:"
    echo "----------------------------------------"
    
    if "$exe"; then
        print_success "$exe_name completed successfully"
    else
        print_warning "$exe_name failed with exit code $?"
    fi
    
    echo "----------------------------------------"
    echo
done

print_success "All examples completed!"
print_status "Executables are available in: $BIN_DIR"
echo

print_status "Available executables:"
for exe_name in "${EXPECTED_EXECUTABLES[@]}"; do
    exe_path="$BIN_DIR/$exe_name"
    if [ -x "$exe_path" ]; then
        echo "  - $exe_name"
    fi
done
