#!/bin/bash

# SpiderMonkey CMake Build Script
# Complete build system for SpiderMonkey with JavaScript execution examples

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
BUILD_TYPE="Release"
BUILD_DIR="build"
CLEAN_BUILD=false
BUILD_EXAMPLES=true
BUILD_TESTS=false
INSTALL_SPIDERMONKEY=false
RUN_EXAMPLES=true
VERBOSE=false
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# SpiderMonkey specific options
ENABLE_DEBUG=false
ENABLE_PROFILING=false
ENABLE_TRACE_LOGGING=false
ENABLE_INTL=true
ENABLE_BIGINT=true
ENABLE_WASM=true
STRICT_MODE=false
OPTIMIZE_SIZE=false

# Example options
BUILD_BASIC_EXAMPLE=true
BUILD_ADVANCED_EXAMPLE=true
BUILD_INTERACTIVE_EXAMPLE=true

# Functions
print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_usage() {
    cat << EOF
SpiderMonkey CMake Build Script

Usage: $0 [OPTIONS]

Build Options:
    -h, --help              Show this help message
    -t, --type TYPE         Build type: Debug, Release, RelWithDebInfo, MinSizeRel (default: Release)
    -d, --build-dir DIR     Build directory (default: build)
    -c, --clean             Clean build (remove build directory first)
    -v, --verbose           Verbose build output
    -j, --jobs N            Number of parallel jobs (default: auto-detected)

Example Options:
    -e, --examples          Build examples (default: enabled)
    -E, --no-examples       Don't build examples
    --basic                 Build basic C example (default: enabled)
    --no-basic              Don't build basic C example
    --advanced              Build advanced C++ example (default: enabled)
    --no-advanced           Don't build advanced C++ example
    --interactive           Build interactive shell (default: enabled)
    --no-interactive        Don't build interactive shell

SpiderMonkey Options:
    --debug                 Enable SpiderMonkey debug mode
    --profiling             Enable profiling support
    --trace-logging         Enable trace logging
    --no-intl               Disable Internationalization API
    --no-bigint             Disable BigInt support
    --no-wasm               Disable WebAssembly support
    --strict                Enable strict compilation warnings
    --optimize-size         Optimize for size instead of speed

Other Options:
    -T, --tests             Build tests
    -i, --install           Enable installation
    -r, --run               Run examples after build (default: enabled)
    -R, --no-run            Don't run examples after build

Examples:
    $0                      # Basic release build with all examples
    $0 -t Debug --debug     # Debug build with SpiderMonkey debug mode
    $0 -c --advanced --interactive  # Clean build with only advanced examples
    $0 --strict --optimize-size     # Strict build optimized for size

Build Types:
    Debug           - No optimization, debug symbols
    Release         - Full optimization, no debug symbols
    RelWithDebInfo  - Optimization with debug symbols
    MinSizeRel      - Optimize for size

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_usage; exit 0 ;;
        -t|--type) BUILD_TYPE="$2"; shift 2 ;;
        -d|--build-dir) BUILD_DIR="$2"; shift 2 ;;
        -c|--clean) CLEAN_BUILD=true; shift ;;
        -e|--examples) BUILD_EXAMPLES=true; shift ;;
        -E|--no-examples) BUILD_EXAMPLES=false; shift ;;
        --basic) BUILD_BASIC_EXAMPLE=true; shift ;;
        --no-basic) BUILD_BASIC_EXAMPLE=false; shift ;;
        --advanced) BUILD_ADVANCED_EXAMPLE=true; shift ;;
        --no-advanced) BUILD_ADVANCED_EXAMPLE=false; shift ;;
        --interactive) BUILD_INTERACTIVE_EXAMPLE=true; shift ;;
        --no-interactive) BUILD_INTERACTIVE_EXAMPLE=false; shift ;;
        --debug) ENABLE_DEBUG=true; shift ;;
        --profiling) ENABLE_PROFILING=true; shift ;;
        --trace-logging) ENABLE_TRACE_LOGGING=true; shift ;;
        --no-intl) ENABLE_INTL=false; shift ;;
        --no-bigint) ENABLE_BIGINT=false; shift ;;
        --no-wasm) ENABLE_WASM=false; shift ;;
        --strict) STRICT_MODE=true; shift ;;
        --optimize-size) OPTIMIZE_SIZE=true; shift ;;
        -T|--tests) BUILD_TESTS=true; shift ;;
        -i|--install) INSTALL_SPIDERMONKEY=true; shift ;;
        -r|--run) RUN_EXAMPLES=true; shift ;;
        -R|--no-run) RUN_EXAMPLES=false; shift ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -j|--jobs) JOBS="$2"; shift 2 ;;
        *) print_error "Unknown option: $1"; show_usage; exit 1 ;;
    esac
done

# Validate build type
case $BUILD_TYPE in
    Debug|Release|RelWithDebInfo|MinSizeRel) ;;
    *) print_error "Invalid build type: $BUILD_TYPE"; exit 1 ;;
esac

# Print configuration
print_status "SpiderMonkey Build Configuration:"
echo "  Build Type:        $BUILD_TYPE"
echo "  Build Directory:   $BUILD_DIR"
echo "  Clean Build:       $CLEAN_BUILD"
echo "  Build Examples:    $BUILD_EXAMPLES"
echo "  Build Tests:       $BUILD_TESTS"
echo "  Install:           $INSTALL_SPIDERMONKEY"
echo "  Run Examples:      $RUN_EXAMPLES"
echo "  Parallel Jobs:     $JOBS"
echo "  Verbose:           $VERBOSE"
echo
echo "SpiderMonkey Options:"
echo "  Debug Mode:        $ENABLE_DEBUG"
echo "  Profiling:         $ENABLE_PROFILING"
echo "  Trace Logging:     $ENABLE_TRACE_LOGGING"
echo "  Intl API:          $ENABLE_INTL"
echo "  BigInt:            $ENABLE_BIGINT"
echo "  WebAssembly:       $ENABLE_WASM"
echo "  Strict Mode:       $STRICT_MODE"
echo "  Optimize Size:     $OPTIMIZE_SIZE"
echo
echo "Example Options:"
echo "  Basic Example:     $BUILD_BASIC_EXAMPLE"
echo "  Advanced Example:  $BUILD_ADVANCED_EXAMPLE"
echo "  Interactive Shell: $BUILD_INTERACTIVE_EXAMPLE"
echo

# Check requirements
print_status "Checking requirements..."

if ! command -v cmake &> /dev/null; then
    print_error "CMake not found. Please install CMake 3.20+"
    exit 1
fi

CMAKE_VERSION=$(cmake --version | head -n1 | cut -d' ' -f3)
print_success "Found CMake $CMAKE_VERSION"

if ! command -v pkg-config &> /dev/null; then
    print_error "pkg-config not found. Please install pkg-config"
    exit 1
fi

# Check for SpiderMonkey (optional - this project provides SpiderMonkey headers)
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

if pkg-config --exists mozjs-128; then
    MOZJS_VERSION=$(pkg-config --modversion mozjs-128)
    print_success "Found system SpiderMonkey $MOZJS_VERSION (will be used for linking)"
else
    print_warning "System SpiderMonkey not found - examples will use headers only"
    print_warning "For full functionality, install SpiderMonkey:"
    print_warning "  macOS: brew install spidermonkey"
    print_warning "  Ubuntu: apt install libmozjs-128-dev"
fi

# Clean build if requested
if [ "$CLEAN_BUILD" = true ]; then
    if [ -d "$BUILD_DIR" ]; then
        print_status "Cleaning build directory: $BUILD_DIR"
        rm -rf "$BUILD_DIR"
        print_success "Build directory cleaned"
    fi
fi

# Create build directory
print_status "Creating build directory: $BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Configure
print_status "Configuring project..."
cd "$BUILD_DIR"

CMAKE_ARGS=(
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
    -DSPIDERMONKEY_BUILD_EXAMPLES="$BUILD_EXAMPLES"
    -DSPIDERMONKEY_BUILD_TESTS="$BUILD_TESTS"
    -DSPIDERMONKEY_INSTALL="$INSTALL_SPIDERMONKEY"
    -DSPIDERMONKEY_ENABLE_DEBUG="$ENABLE_DEBUG"
    -DSPIDERMONKEY_ENABLE_PROFILING="$ENABLE_PROFILING"
    -DSPIDERMONKEY_ENABLE_TRACE_LOGGING="$ENABLE_TRACE_LOGGING"
    -DSPIDERMONKEY_ENABLE_INTL="$ENABLE_INTL"
    -DSPIDERMONKEY_ENABLE_BIGINT="$ENABLE_BIGINT"
    -DSPIDERMONKEY_ENABLE_WASM="$ENABLE_WASM"
    -DSPIDERMONKEY_STRICT_MODE="$STRICT_MODE"
    -DSPIDERMONKEY_OPTIMIZE_SIZE="$OPTIMIZE_SIZE"
    -DSPIDERMONKEY_BUILD_BASIC_EXAMPLE="$BUILD_BASIC_EXAMPLE"
    -DSPIDERMONKEY_BUILD_ADVANCED_EXAMPLE="$BUILD_ADVANCED_EXAMPLE"
    -DSPIDERMONKEY_BUILD_INTERACTIVE_EXAMPLE="$BUILD_INTERACTIVE_EXAMPLE"
)

if [ "$VERBOSE" = true ]; then
    cmake "${CMAKE_ARGS[@]}" ..
else
    cmake "${CMAKE_ARGS[@]}" .. > cmake_config.log 2>&1
fi

if [ $? -eq 0 ]; then
    print_success "Configuration completed successfully"
else
    print_error "Configuration failed"
    if [ "$VERBOSE" = false ]; then
        print_error "Check cmake_config.log for details"
        echo "Last few lines:"
        tail -10 cmake_config.log
    fi
    exit 1
fi

# Build
print_status "Building project with $JOBS parallel jobs..."

if [ "$VERBOSE" = true ]; then
    cmake --build . --parallel "$JOBS"
else
    cmake --build . --parallel "$JOBS" > build.log 2>&1
fi

if [ $? -eq 0 ]; then
    print_success "Build completed successfully"
else
    print_error "Build failed"
    if [ "$VERBOSE" = false ]; then
        print_error "Check build.log for details"
        echo "Last few lines:"
        tail -10 build.log
    fi
    exit 1
fi

# Show build results
print_status "Build Results:"
if [ "$BUILD_EXAMPLES" = true ]; then
    echo "  Examples:"
    find . -name "*_js" -type f -executable 2>/dev/null | while read -r example; do
        echo "    $example"
    done
fi

# Run examples
if [ "$BUILD_EXAMPLES" = true ] && [ "$RUN_EXAMPLES" = true ]; then
    echo
    print_status "Running examples..."
    
    for example in $(find . -name "*_js" -type f -executable 2>/dev/null | sort); do
        if [ -x "$example" ]; then
            echo
            print_status "Running $(basename "$example"):"
            echo "----------------------------------------"
            if "$example"; then
                print_success "$(basename "$example") completed successfully"
            else
                print_warning "$(basename "$example") failed"
            fi
            echo "----------------------------------------"
        fi
    done
fi

# Install if requested
if [ "$INSTALL_SPIDERMONKEY" = true ]; then
    echo
    print_status "Installing SpiderMonkey..."
    if cmake --build . --target install; then
        print_success "Installation completed"
    else
        print_warning "Installation failed"
    fi
fi

cd ..

print_success "Build script completed successfully!"
print_status "Build artifacts are in: $BUILD_DIR"

echo
print_status "Next steps:"
if [ "$BUILD_EXAMPLES" = true ]; then
    echo "  - Run examples: cd $BUILD_DIR && ./bin/basic_js"
    echo "  - Run advanced: cd $BUILD_DIR && ./bin/advanced_js"
fi
echo "  - Use in project: add_subdirectory(spidermonkey)"
echo "  - Link target: target_link_libraries(your_target SpiderMonkey::spidermonkey)"
echo "  - Clean: rm -rf $BUILD_DIR"
