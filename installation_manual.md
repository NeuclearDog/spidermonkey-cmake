# SpiderMonkey CMake Integration - Complete Installation Manual

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installation Methods](#installation-methods)
4. [CMake Integration](#cmake-integration)
5. [Code Examples](#code-examples)
6. [Build Configuration](#build-configuration)
7. [System Library Integration](#system-library-integration)
8. [Advanced Usage](#advanced-usage)
9. [Troubleshooting](#troubleshooting)
10. [Platform-Specific Instructions](#platform-specific-instructions)
11. [Best Practices](#best-practices)
12. [API Reference](#api-reference)

---

## Overview

This SpiderMonkey CMake project provides:
- **Complete SpiderMonkey headers** (mozjs-128) for C/C++ integration
- **CMake build system** for easy integration as a subdirectory
- **Working examples** demonstrating proper usage
- **Cross-platform support** (Linux, macOS, Windows)
- **Automatic system library detection** and linking

**Key Features:**
- Header-only distribution for compilation
- CMake target `SpiderMonkey::spidermonkey` for easy linking
- Compatible with system SpiderMonkey libraries
- Modern CMake practices (3.20+)
- C++17 standard compliance

---

## Prerequisites

### Required Software

| Component | Minimum Version | Recommended | Purpose |
|-----------|----------------|-------------|---------|
| CMake | 3.20 | 3.25+ | Build system |
| C++ Compiler | C++17 support | Latest | Compilation |
| C Compiler | C11 support | Latest | C examples |

### Supported Compilers

**Linux:**
- GCC 7.0+ (recommended: GCC 9+)
- Clang 5.0+ (recommended: Clang 10+)

**macOS:**
- Xcode 10+ (Clang)
- GCC via Homebrew

**Windows:**
- Visual Studio 2017+ (MSVC 19.10+)
- MinGW-w64 with GCC 7+
- Clang for Windows

### System Requirements

- **RAM**: Minimum 2GB, recommended 4GB+ for compilation
- **Disk Space**: ~100MB for headers, additional space for builds
- **Network**: Required for downloading system SpiderMonkey library

---

## Installation Methods

### Method 1: Direct Download/Clone

```bash
# Clone the repository
git clone <repository-url> spidermonkey-cmake
cd spidermonkey-cmake

# Verify structure
ls -la
# Should show: CMakeLists.txt, js/, mozilla/, jsapi.h, examples/, etc.
```

### Method 2: Git Submodule (Recommended for Projects)

```bash
# In your project root
git submodule add <repository-url> external/spidermonkey
git submodule update --init --recursive

# Commit the submodule
git add .gitmodules external/spidermonkey
git commit -m "Add SpiderMonkey as submodule"
```

### Method 3: CMake FetchContent

```cmake
include(FetchContent)

FetchContent_Declare(
    spidermonkey
    GIT_REPOSITORY <repository-url>
    GIT_TAG main  # or specific version tag
    GIT_SHALLOW TRUE
)

FetchContent_MakeAvailable(spidermonkey)
```

### Method 4: Manual Download

1. Download and extract the project
2. Place in your project's `external/` or `third_party/` directory
3. Ensure all files are present (check against project structure)

---

## CMake Integration

### Basic Integration

#### Project Structure
```
your-project/
├── CMakeLists.txt              # Main CMake file
├── src/
│   ├── main.cpp               # Your application
│   └── js_engine.cpp          # JavaScript integration
├── include/
│   └── js_engine.h            # Your headers
├── external/                   # Third-party dependencies
│   └── spidermonkey/          # This SpiderMonkey project
├── build/                     # Build directory (created)
└── README.md
```

#### Main CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.20)
project(YourJSProject VERSION 1.0.0 LANGUAGES CXX C)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Add SpiderMonkey subdirectory
add_subdirectory(external/spidermonkey)

# Create your executable
add_executable(your_app
    src/main.cpp
    src/js_engine.cpp
)

# Link against SpiderMonkey
target_link_libraries(your_app PRIVATE SpiderMonkey::spidermonkey)

# Optional: Add include directories for your headers
target_include_directories(your_app PRIVATE include)

# Optional: Set output directory
set_target_properties(your_app PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
```

### Advanced Integration

#### With Custom Build Options
```cmake
# Configure SpiderMonkey build options before adding subdirectory
set(SPIDERMONKEY_BUILD_EXAMPLES OFF CACHE BOOL "Don't build examples")
set(SPIDERMONKEY_BUILD_TESTS OFF CACHE BOOL "Don't build tests")
set(SPIDERMONKEY_INSTALL OFF CACHE BOOL "Don't install SpiderMonkey")

# Add SpiderMonkey
add_subdirectory(external/spidermonkey)

# Create library target
add_library(js_wrapper STATIC
    src/js_wrapper.cpp
    src/js_context.cpp
    src/js_value.cpp
)

target_link_libraries(js_wrapper PUBLIC SpiderMonkey::spidermonkey)
target_include_directories(js_wrapper PUBLIC include)

# Create executable
add_executable(your_app src/main.cpp)
target_link_libraries(your_app PRIVATE js_wrapper)
```

#### Multiple Targets
```cmake
# Add SpiderMonkey once
add_subdirectory(external/spidermonkey)

# Create multiple executables
add_executable(js_repl src/repl.cpp)
add_executable(js_test src/test.cpp)
add_executable(js_benchmark src/benchmark.cpp)

# Link all against SpiderMonkey
target_link_libraries(js_repl PRIVATE SpiderMonkey::spidermonkey)
target_link_libraries(js_test PRIVATE SpiderMonkey::spidermonkey)
target_link_libraries(js_benchmark PRIVATE SpiderMonkey::spidermonkey)
```

---

## Code Examples

### Basic C Integration

#### main.c
```c
#include "jsapi.h"
#include "js/Initialization.h"
#include "js/CompilationAndEvaluation.h"
#include "js/SourceText.h"
#include "js/Exception.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("Initializing SpiderMonkey...\n");
    
    // Initialize the JavaScript engine
    if (!JS_Init()) {
        fprintf(stderr, "Failed to initialize SpiderMonkey\n");
        return 1;
    }
    
    // Create a JavaScript context
    JSContext *cx = JS_NewContext(JS::DefaultHeapMaxBytes);
    if (!cx) {
        fprintf(stderr, "Failed to create JavaScript context\n");
        JS_ShutDown();
        return 1;
    }
    
    printf("SpiderMonkey initialized successfully!\n");
    printf("Context created: %p\n", (void*)cx);
    
    // Note: For actual JavaScript execution, you need the system library
    printf("Headers are available for compilation.\n");
    printf("Install system SpiderMonkey library for full functionality.\n");
    
    // Cleanup
    JS_DestroyContext(cx);
    JS_ShutDown();
    
    printf("SpiderMonkey shut down successfully.\n");
    return 0;
}
```

### Advanced C++ Integration

#### js_engine.h
```cpp
#pragma once

#include "jsapi.h"
#include "js/Initialization.h"
#include "js/CompilationAndEvaluation.h"
#include "js/SourceText.h"
#include "js/Context.h"
#include "js/Value.h"
#include "js/Exception.h"
#include <string>
#include <memory>

class JSEngine {
public:
    JSEngine();
    ~JSEngine();
    
    bool initialize();
    void shutdown();
    
    bool evaluateScript(const std::string& script, std::string& result);
    bool callFunction(const std::string& functionName, 
                     const std::vector<std::string>& args, 
                     std::string& result);
    
    bool isInitialized() const { return initialized_; }
    JSContext* getContext() const { return context_; }

private:
    bool initialized_;
    JSContext* context_;
    JS::PersistentRootedObject global_;
    
    void reportError(JSContext* cx);
};
```

#### js_engine.cpp
```cpp
#include "js_engine.h"
#include <iostream>

JSEngine::JSEngine() : initialized_(false), context_(nullptr) {}

JSEngine::~JSEngine() {
    shutdown();
}

bool JSEngine::initialize() {
    if (initialized_) {
        return true;
    }
    
    // Initialize SpiderMonkey
    if (!JS_Init()) {
        std::cerr << "Failed to initialize SpiderMonkey" << std::endl;
        return false;
    }
    
    // Create context
    context_ = JS_NewContext(JS::DefaultHeapMaxBytes);
    if (!context_) {
        std::cerr << "Failed to create JavaScript context" << std::endl;
        JS_ShutDown();
        return false;
    }
    
    // Note: Full implementation requires system SpiderMonkey library
    // This demonstrates header usage and structure
    
    initialized_ = true;
    return true;
}

void JSEngine::shutdown() {
    if (!initialized_) {
        return;
    }
    
    if (context_) {
        JS_DestroyContext(context_);
        context_ = nullptr;
    }
    
    JS_ShutDown();
    initialized_ = false;
}

bool JSEngine::evaluateScript(const std::string& script, std::string& result) {
    if (!initialized_ || !context_) {
        result = "Engine not initialized";
        return false;
    }
    
    // Note: Actual script evaluation requires system library
    result = "Script evaluation requires system SpiderMonkey library";
    return false;
}

void JSEngine::reportError(JSContext* cx) {
    // Error reporting implementation
    if (JS_IsExceptionPending(cx)) {
        JS_ClearPendingException(cx);
    }
}
```

#### main.cpp
```cpp
#include "js_engine.h"
#include <iostream>
#include <string>

int main() {
    std::cout << "SpiderMonkey C++ Integration Example" << std::endl;
    
    JSEngine engine;
    
    if (!engine.initialize()) {
        std::cerr << "Failed to initialize JavaScript engine" << std::endl;
        return 1;
    }
    
    std::cout << "JavaScript engine initialized successfully!" << std::endl;
    std::cout << "Context: " << engine.getContext() << std::endl;
    
    // Example of header usage
    std::string script = "var x = 2 + 3; x * 4;";
    std::string result;
    
    if (engine.evaluateScript(script, result)) {
        std::cout << "Script result: " << result << std::endl;
    } else {
        std::cout << "Script evaluation info: " << result << std::endl;
    }
    
    std::cout << "Shutting down..." << std::endl;
    return 0;
}
```

---

## Build Configuration

### Build Options

The SpiderMonkey CMake project supports several build options:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `SPIDERMONKEY_BUILD_EXAMPLES` | BOOL | ON | Build integration examples |
| `SPIDERMONKEY_BUILD_TESTS` | BOOL | OFF | Build test programs |
| `SPIDERMONKEY_INSTALL` | BOOL | OFF | Enable installation targets |

#### Setting Build Options

**Via CMake Command Line:**
```bash
cmake -DSPIDERMONKEY_BUILD_EXAMPLES=OFF \
      -DSPIDERMONKEY_BUILD_TESTS=ON \
      -DCMAKE_BUILD_TYPE=Release \
      ..
```

**Via CMake Cache (before add_subdirectory):**
```cmake
set(SPIDERMONKEY_BUILD_EXAMPLES OFF CACHE BOOL "Don't build examples")
set(SPIDERMONKEY_BUILD_TESTS ON CACHE BOOL "Build tests")
add_subdirectory(external/spidermonkey)
```

**Via CMakeCache.txt:**
```
SPIDERMONKEY_BUILD_EXAMPLES:BOOL=OFF
SPIDERMONKEY_BUILD_TESTS:BOOL=ON
SPIDERMONKEY_INSTALL:BOOL=OFF
```

### Build Types

#### Debug Build
```bash
mkdir build-debug && cd build-debug
cmake -DCMAKE_BUILD_TYPE=Debug ..
make -j$(nproc)
```

**Debug Features:**
- Debug symbols included
- Optimizations disabled
- Additional runtime checks
- Verbose error messages

#### Release Build
```bash
mkdir build-release && cd build-release
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
```

**Release Features:**
- Full optimizations enabled
- Debug symbols stripped
- Minimal runtime overhead
- Production-ready binaries

#### RelWithDebInfo Build
```bash
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
```

**Features:**
- Optimizations enabled
- Debug symbols included
- Good for profiling and debugging optimized code

### Custom Build Configurations

#### Cross-Platform Build Script

**build.sh** (Linux/macOS):
```bash
#!/bin/bash

BUILD_TYPE="Release"
CLEAN_BUILD=false
VERBOSE=false
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -j|--jobs)
            JOBS="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -t, --type TYPE     Build type (Debug, Release, etc.)"
            echo "  -c, --clean         Clean build"
            echo "  -v, --verbose       Verbose output"
            echo "  -j, --jobs N        Parallel jobs"
            echo "  -h, --help          Show help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

BUILD_DIR="build-$(echo $BUILD_TYPE | tr '[:upper:]' '[:lower:]')"

if [ "$CLEAN_BUILD" = true ]; then
    echo "Cleaning build directory: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Configuring with CMake..."
CMAKE_ARGS="-DCMAKE_BUILD_TYPE=$BUILD_TYPE"

if [ "$VERBOSE" = true ]; then
    CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_VERBOSE_MAKEFILE=ON"
fi

cmake $CMAKE_ARGS ..

echo "Building with $JOBS parallel jobs..."
if [ "$VERBOSE" = true ]; then
    make -j$JOBS VERBOSE=1
else
    make -j$JOBS
fi

echo "Build completed successfully!"
echo "Binaries are in: $BUILD_DIR/bin/"
```

**build.bat** (Windows):
```batch
@echo off
setlocal enabledelayedexpansion

set BUILD_TYPE=Release
set CLEAN_BUILD=false
set VERBOSE=false
set JOBS=%NUMBER_OF_PROCESSORS%

:parse_args
if "%~1"=="" goto end_parse
if "%~1"=="-t" (
    set BUILD_TYPE=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--type" (
    set BUILD_TYPE=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="-c" (
    set CLEAN_BUILD=true
    shift
    goto parse_args
)
if "%~1"=="--clean" (
    set CLEAN_BUILD=true
    shift
    goto parse_args
)
if "%~1"=="-v" (
    set VERBOSE=true
    shift
    goto parse_args
)
if "%~1"=="--verbose" (
    set VERBOSE=true
    shift
    goto parse_args
)
if "%~1"=="-h" goto show_help
if "%~1"=="--help" goto show_help

echo Unknown option: %~1
exit /b 1

:show_help
echo Usage: %0 [OPTIONS]
echo Options:
echo   -t, --type TYPE     Build type (Debug, Release, etc.)
echo   -c, --clean         Clean build
echo   -v, --verbose       Verbose output
echo   -h, --help          Show help
exit /b 0

:end_parse

set BUILD_DIR=build-%BUILD_TYPE%

if "%CLEAN_BUILD%"=="true" (
    echo Cleaning build directory: %BUILD_DIR%
    rmdir /s /q "%BUILD_DIR%" 2>nul
)

mkdir "%BUILD_DIR%" 2>nul
cd "%BUILD_DIR%"

echo Configuring with CMake...
set CMAKE_ARGS=-DCMAKE_BUILD_TYPE=%BUILD_TYPE%

if "%VERBOSE%"=="true" (
    set CMAKE_ARGS=%CMAKE_ARGS% -DCMAKE_VERBOSE_MAKEFILE=ON
)

cmake %CMAKE_ARGS% ..

echo Building...
if "%VERBOSE%"=="true" (
    cmake --build . --config %BUILD_TYPE% --parallel %JOBS% --verbose
) else (
    cmake --build . --config %BUILD_TYPE% --parallel %JOBS%
)

echo Build completed successfully!
echo Binaries are in: %BUILD_DIR%\bin\
```

---

## System Library Integration

### Installing System SpiderMonkey Library

For full JavaScript execution capabilities, install the system SpiderMonkey library:

#### macOS (Homebrew)
```bash
# Install SpiderMonkey
brew install spidermonkey

# Verify installation
brew list spidermonkey
pkg-config --exists mozjs-128 && echo "Available" || echo "Not found"

# Check version
pkg-config --modversion mozjs-128
```

#### Ubuntu/Debian
```bash
# Update package list
sudo apt update

# Install SpiderMonkey development package
sudo apt install libmozjs-128-dev

# Alternative: specific version
sudo apt install libmozjs-115-dev  # For older version

# Verify installation
pkg-config --exists mozjs-128 && echo "Available" || echo "Not found"
dpkg -l | grep mozjs
```

#### Fedora/CentOS/RHEL
```bash
# Fedora
sudo dnf install mozjs128-devel

# CentOS/RHEL (with EPEL)
sudo yum install epel-release
sudo yum install mozjs128-devel

# Verify installation
pkg-config --exists mozjs-128 && echo "Available" || echo "Not found"
rpm -qa | grep mozjs
```

#### Arch Linux
```bash
# Install SpiderMonkey
sudo pacman -S js128

# Verify installation
pacman -Qs js128
pkg-config --exists mozjs-128 && echo "Available" || echo "Not found"
```

#### Windows (vcpkg)
```powershell
# Install vcpkg if not already installed
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat

# Install SpiderMonkey
.\vcpkg install spidermonkey:x64-windows

# Integrate with Visual Studio
.\vcpkg integrate install
```

### CMake System Library Detection

The SpiderMonkey CMake project automatically detects and links against system libraries:

```cmake
# In SpiderMonkey's CMakeLists.txt (automatic)
find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(MOZJS QUIET mozjs-128)
    if(MOZJS_FOUND)
        message(STATUS "Found system SpiderMonkey: ${MOZJS_VERSION}")
        target_link_libraries(spidermonkey INTERFACE ${MOZJS_LIBRARIES})
        target_include_directories(spidermonkey INTERFACE ${MOZJS_INCLUDE_DIRS})
        target_compile_options(spidermonkey INTERFACE ${MOZJS_CFLAGS_OTHER})
    endif()
endif()
```

### Verifying System Integration

#### Test System Library
```cpp
// test_system_lib.cpp
#include "jsapi.h"
#include "js/Initialization.h"
#include "js/CompilationAndEvaluation.h"
#include "js/SourceText.h"
#include <iostream>

int main() {
    if (!JS_Init()) {
        std::cerr << "Failed to initialize SpiderMonkey" << std::endl;
        return 1;
    }
    
    JSContext* cx = JS_NewContext(JS::DefaultHeapMaxBytes);
    if (!cx) {
        std::cerr << "Failed to create context" << std::endl;
        JS_ShutDown();
        return 1;
    }
    
    // Try to create a global object (requires system library)
    JS::RealmOptions options;
    JS::RootedObject global(cx, JS_NewGlobalObject(cx, &JS::DefaultGlobalClass, 
                                                   nullptr, JS::FireOnNewGlobalHook, 
                                                   options));
    
    if (global) {
        std::cout << "System SpiderMonkey library is working!" << std::endl;
        
        // Try to evaluate simple script
        JSAutoRealm ar(cx, global);
        JS::RootedValue result(cx);
        
        const char* script = "2 + 3 * 4";
        JS::SourceText<mozilla::Utf8Unit> source;
        if (source.init(cx, script, strlen(script), JS::SourceOwnership::Borrowed)) {
            if (JS::Evaluate(cx, source, &result)) {
                if (result.isNumber()) {
                    std::cout << "Script result: " << result.toNumber() << std::endl;
                }
            }
        }
    } else {
        std::cout << "Headers available, but system library needed for full functionality" << std::endl;
    }
    
    JS_DestroyContext(cx);
    JS_ShutDown();
    return 0;
}
```

#### Build and Test
```bash
# Build test
g++ -std=c++17 test_system_lib.cpp -o test_system_lib \
    $(pkg-config --cflags --libs mozjs-128) \
    -I/path/to/spidermonkey/headers

# Run test
./test_system_lib
```

---

## Advanced Usage

### Custom CMake Targets

#### Creating a SpiderMonkey Wrapper Library

```cmake
# Create a wrapper library for easier integration
add_library(js_wrapper STATIC
    src/js_context.cpp
    src/js_value.cpp
    src/js_function.cpp
    src/js_object.cpp
    src/js_array.cpp
    src/js_exception.cpp
)

# Link against SpiderMonkey
target_link_libraries(js_wrapper PUBLIC SpiderMonkey::spidermonkey)

# Set include directories
target_include_directories(js_wrapper 
    PUBLIC 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Set compile features
target_compile_features(js_wrapper PUBLIC cxx_std_17)

# Export the target
install(TARGETS js_wrapper
    EXPORT js_wrapper-targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)
```

#### Multiple Configuration Support

```cmake
# Support for different SpiderMonkey versions
option(USE_MOZJS_128 "Use SpiderMonkey 128" ON)
option(USE_MOZJS_115 "Use SpiderMonkey 115" OFF)

if(USE_MOZJS_128)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(MOZJS REQUIRED mozjs-128)
    set(MOZJS_VERSION "128")
elseif(USE_MOZJS_115)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(MOZJS REQUIRED mozjs-115)
    set(MOZJS_VERSION "115")
endif()

# Configure based on version
target_compile_definitions(spidermonkey INTERFACE 
    MOZJS_VERSION=${MOZJS_VERSION}
)
```

### Integration with Package Managers

#### Conan Integration

**conanfile.txt:**
```ini
[requires]
spidermonkey/128.0@_/_

[generators]
CMakeDeps
CMakeToolchain

[options]
spidermonkey:shared=False
```

**CMakeLists.txt with Conan:**
```cmake
find_package(spidermonkey REQUIRED)

# Add your SpiderMonkey headers
add_subdirectory(external/spidermonkey-cmake)

# Create target that uses both
add_executable(your_app src/main.cpp)
target_link_libraries(your_app PRIVATE 
    SpiderMonkey::spidermonkey  # Headers
    spidermonkey::spidermonkey  # System library via Conan
)
```

#### vcpkg Integration

**vcpkg.json:**
```json
{
    "name": "your-project",
    "version": "1.0.0",
    "dependencies": [
        "spidermonkey"
    ]
}
```

**CMakeLists.txt with vcpkg:**
```cmake
find_package(unofficial-spidermonkey CONFIG REQUIRED)

add_subdirectory(external/spidermonkey-cmake)

add_executable(your_app src/main.cpp)
target_link_libraries(your_app PRIVATE 
    SpiderMonkey::spidermonkey  # Headers
    unofficial::spidermonkey::spidermonkey  # vcpkg library
)
```

### Custom Build Configurations

#### Minimal Headers Only

```cmake
# Disable all extras for minimal integration
set(SPIDERMONKEY_BUILD_EXAMPLES OFF CACHE BOOL "")
set(SPIDERMONKEY_BUILD_TESTS OFF CACHE BOOL "")
set(SPIDERMONKEY_INSTALL OFF CACHE BOOL "")

add_subdirectory(external/spidermonkey)

# Use only headers
add_executable(minimal_app src/main.cpp)
target_link_libraries(minimal_app PRIVATE SpiderMonkey::spidermonkey)
```

#### Development Configuration

```cmake
# Enable everything for development
set(SPIDERMONKEY_BUILD_EXAMPLES ON CACHE BOOL "")
set(SPIDERMONKEY_BUILD_TESTS ON CACHE BOOL "")
set(CMAKE_BUILD_TYPE Debug CACHE STRING "")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "")

add_subdirectory(external/spidermonkey)

# Development target with extra flags
add_executable(dev_app src/main.cpp)
target_link_libraries(dev_app PRIVATE SpiderMonkey::spidermonkey)
target_compile_options(dev_app PRIVATE
    $<$<CXX_COMPILER_ID:GNU,Clang>:-Wall -Wextra -Wpedantic>
    $<$<CXX_COMPILER_ID:MSVC>:/W4>
)
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. CMake Version Too Old

**Error:**
```
CMake Error: CMake 3.19 or higher is required. You are running version 3.16.3
```

**Solution:**
```bash
# Ubuntu/Debian - install newer CMake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main'
sudo apt update
sudo apt install cmake

# macOS - update via Homebrew
brew upgrade cmake

# Or install via pip
pip3 install cmake --upgrade
```

#### 2. Compiler Not Found or Too Old

**Error:**
```
No suitable C++ compiler found
```

**Solution:**
```bash
# Ubuntu/Debian
sudo apt install build-essential g++

# macOS
xcode-select --install

# Check compiler version
g++ --version
clang++ --version
```

#### 3. Headers Not Found

**Error:**
```
fatal error: 'jsapi.h' file not found
```

**Solutions:**

**Check Project Structure:**
```bash
# Verify SpiderMonkey directory structure
ls -la external/spidermonkey/
# Should show: jsapi.h, js/, mozilla/, CMakeLists.txt

# Check if headers are in the right place
find external/spidermonkey -name "jsapi.h"
```

**Fix Include Paths:**
```cmake
# Explicit include directory (if needed)
target_include_directories(your_app PRIVATE 
    external/spidermonkey
)
```

#### 4. Linking Errors

**Error:**
```
undefined reference to `JS_Init'
```

**Solutions:**

**Install System Library:**
```bash
# macOS
brew install spidermonkey

# Ubuntu/Debian
sudo apt install libmozjs-128-dev

# Verify installation
pkg-config --exists mozjs-128 && echo "OK" || echo "Missing"
```

**Check CMake Configuration:**
```cmake
# Debug CMake configuration
message(STATUS "SpiderMonkey target exists: ${TARGET SpiderMonkey::spidermonkey}")

# Manual linking (if automatic detection fails)
find_package(PkgConfig REQUIRED)
pkg_check_modules(MOZJS REQUIRED mozjs-128)
target_link_libraries(your_app PRIVATE ${MOZJS_LIBRARIES})
```

#### 5. Runtime Errors

**Error:**
```
Segmentation fault in JS_Init()
```

**Solutions:**

**Check Library Compatibility:**
```bash
# Verify library version matches headers
pkg-config --modversion mozjs-128

# Check library location
pkg-config --libs mozjs-128

# Test with minimal example
```

**Debug Build:**
```bash
# Build with debug symbols
cmake -DCMAKE_BUILD_TYPE=Debug ..
make -j$(nproc)

# Run with debugger
gdb ./your_app
(gdb) run
(gdb) bt  # when it crashes
```

#### 6. Windows-Specific Issues

**Error:**
```
MSVCRT.lib conflicts with use of other libs
```

**Solution:**
```cmake
# Set consistent runtime library
set_property(TARGET your_app PROPERTY
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL"
)

# Or use static runtime
set_property(TARGET your_app PROPERTY
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
)
```

### Debugging CMake Issues

#### Enable Verbose Output

```bash
# Verbose CMake configuration
cmake -DCMAKE_VERBOSE_MAKEFILE=ON ..

# Verbose build
make VERBOSE=1

# CMake debug output
cmake --debug-output ..
```

#### Check CMake Variables

```cmake
# Debug CMake variables
message(STATUS "CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
message(STATUS "CMAKE_CXX_STANDARD: ${CMAKE_CXX_STANDARD}")
message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

# Check if target exists
if(TARGET SpiderMonkey::spidermonkey)
    message(STATUS "SpiderMonkey target found")
    get_target_property(SM_INCLUDE_DIRS SpiderMonkey::spidermonkey INTERFACE_INCLUDE_DIRECTORIES)
    message(STATUS "SpiderMonkey include dirs: ${SM_INCLUDE_DIRS}")
else()
    message(WARNING "SpiderMonkey target not found")
endif()
```

#### Generate Compilation Database

```cmake
# Enable compile commands export
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

```bash
# Use with clang tools
clang-check -p build compile_commands.json src/main.cpp
```

### Performance Troubleshooting

#### Build Performance

```bash
# Use multiple cores
make -j$(nproc)

# Or with CMake
cmake --build . --parallel $(nproc)

# Use Ninja for faster builds
cmake -GNinja ..
ninja
```

#### Runtime Performance

```cpp
// Profile SpiderMonkey usage
#include <chrono>

auto start = std::chrono::high_resolution_clock::now();
// SpiderMonkey operations
auto end = std::chrono::high_resolution_clock::now();
auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
std::cout << "Operation took: " << duration.count() << " microseconds" << std::endl;
```

---

## Platform-Specific Instructions

### Linux (Ubuntu/Debian)

#### Complete Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install build tools
sudo apt install -y build-essential cmake git pkg-config

# Install SpiderMonkey
sudo apt install -y libmozjs-128-dev

# Verify installation
pkg-config --modversion mozjs-128
cmake --version
g++ --version

# Clone and build example
git clone <repository-url> spidermonkey-cmake
cd spidermonkey-cmake
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
./bin/basic_js
```

#### Distribution-Specific Notes

**Ubuntu 20.04 LTS:**
- Default CMake is 3.16, need to upgrade
- SpiderMonkey package might be older version

**Ubuntu 22.04 LTS:**
- CMake 3.22+ available
- Modern SpiderMonkey packages available

**Debian 11 (Bullseye):**
- May need backports for newer CMake
- SpiderMonkey available in main repository

### macOS

#### Complete Setup

```bash
# Install Xcode command line tools
xcode-select --install

# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install cmake spidermonkey git

# Verify installation
cmake --version
pkg-config --modversion mozjs-128
clang++ --version

# Clone and build
git clone <repository-url> spidermonkey-cmake
cd spidermonkey-cmake
./build.sh
```

#### macOS-Specific Notes

**Apple Silicon (M1/M2):**
- Homebrew installs to `/opt/homebrew`
- May need to set `PKG_CONFIG_PATH`

```bash
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
```

**Intel Macs:**
- Homebrew installs to `/usr/local`
- Standard pkg-config paths work

**Xcode Integration:**
```bash
# Generate Xcode project
cmake -G Xcode ..
open YourProject.xcodeproj
```

### Windows

#### Visual Studio Setup

**Prerequisites:**
- Visual Studio 2019 or later
- CMake 3.20+
- Git for Windows

**Using vcpkg:**
```powershell
# Install vcpkg
git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
cd C:\vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install

# Install SpiderMonkey
.\vcpkg install spidermonkey:x64-windows

# Set environment variable
$env:CMAKE_TOOLCHAIN_FILE = "C:\vcpkg\scripts\buildsystems\vcpkg.cmake"
```

**Build Project:**
```powershell
# Clone project
git clone <repository-url> spidermonkey-cmake
cd spidermonkey-cmake

# Configure and build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake ..
cmake --build . --config Release

# Run examples
.\bin\Release\basic_js.exe
```

#### MinGW-w64 Setup

```bash
# Install MSYS2
# Download from https://www.msys2.org/

# In MSYS2 terminal
pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-cmake mingw-w64-x86_64-pkg-config

# Add to PATH
export PATH="/mingw64/bin:$PATH"

# Build project
mkdir build && cd build
cmake -G "MinGW Makefiles" ..
mingw32-make -j$(nproc)
```

### Cross-Compilation

#### ARM64 Linux

```cmake
# Toolchain file: arm64-linux.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++)

set(CMAKE_FIND_ROOT_PATH /usr/aarch64-linux-gnu)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```

```bash
# Install cross-compiler
sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Build
cmake -DCMAKE_TOOLCHAIN_FILE=arm64-linux.cmake ..
make -j$(nproc)
```

---

## Best Practices

### Project Organization

#### Recommended Directory Structure

```
your-project/
├── CMakeLists.txt              # Main build configuration
├── cmake/                      # CMake modules and scripts
│   ├── FindSpiderMonkey.cmake  # Custom find module (if needed)
│   └── CompilerWarnings.cmake  # Compiler warning configuration
├── external/                   # Third-party dependencies
│   ├── spidermonkey/          # This SpiderMonkey project
│   └── other-deps/            # Other dependencies
├── include/                    # Public headers
│   └── your-project/          # Namespaced headers
├── src/                       # Source files
│   ├── js/                    # JavaScript integration code
│   ├── core/                  # Core application code
│   └── main.cpp               # Application entry point
├── tests/                     # Unit tests
│   ├── js/                    # JavaScript-related tests
│   └── core/                  # Core functionality tests
├── examples/                  # Usage examples
├── docs/                      # Documentation
├── scripts/                   # Build and utility scripts
│   ├── build.sh              # Build script
│   └── setup.sh              # Environment setup
├── .gitignore                 # Git ignore file
├── .gitmodules               # Git submodules (if using)
├── README.md                 # Project documentation
└── LICENSE                   # License file
```

#### CMake Best Practices

**Modern CMake Patterns:**
```cmake
# Use modern CMake (3.20+)
cmake_minimum_required(VERSION 3.20)

# Set project with version and languages
project(YourProject 
    VERSION 1.0.0 
    LANGUAGES CXX C
    DESCRIPTION "Your project description"
)

# Use standard variables
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Create interface library for common settings
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)

# Create interface library for warnings
add_library(project_warnings INTERFACE)
target_compile_options(project_warnings INTERFACE
    $<$<CXX_COMPILER_ID:GNU,Clang>:-Wall -Wextra -Wpedantic>
    $<$<CXX_COMPILER_ID:MSVC>:/W4>
)

# Use target-based approach
add_executable(your_app src/main.cpp)
target_link_libraries(your_app PRIVATE 
    SpiderMonkey::spidermonkey
    project_options
    project_warnings
)
```

### Code Organization

#### JavaScript Engine Wrapper

**js_engine.h:**
```cpp
#pragma once

#include "jsapi.h"
#include "js/Initialization.h"
#include <memory>
#include <string>
#include <functional>

namespace js {

class Engine {
public:
    Engine();
    ~Engine();
    
    // Non-copyable, movable
    Engine(const Engine&) = delete;
    Engine& operator=(const Engine&) = delete;
    Engine(Engine&&) = default;
    Engine& operator=(Engine&&) = default;
    
    bool initialize();
    void shutdown();
    
    // Script execution
    bool evaluate(const std::string& script, std::string& result);
    bool evaluateFile(const std::string& filename, std::string& result);
    
    // Function calls
    bool callFunction(const std::string& name, 
                     const std::vector<std::string>& args,
                     std::string& result);
    
    // Error handling
    using ErrorCallback = std::function<void(const std::string&)>;
    void setErrorCallback(ErrorCallback callback);
    
    // State
    bool isInitialized() const { return initialized_; }
    JSContext* getContext() const { return context_; }

private:
    bool initialized_;
    JSContext* context_;
    JS::PersistentRootedObject global_;
    ErrorCallback error_callback_;
    
    void reportError(const std::string& message);
    static void errorReporter(JSContext* cx, JSErrorReport* report);
};

} // namespace js
```

#### Error Handling

```cpp
// Comprehensive error handling
class JSException : public std::exception {
public:
    explicit JSException(const std::string& message) : message_(message) {}
    const char* what() const noexcept override { return message_.c_str(); }

private:
    std::string message_;
};

// RAII for JavaScript contexts
class JSContextGuard {
public:
    explicit JSContextGuard(JSContext* cx) : cx_(cx) {}
    ~JSContextGuard() {
        if (cx_ && JS_IsExceptionPending(cx_)) {
            JS_ClearPendingException(cx_);
        }
    }

private:
    JSContext* cx_;
};
```

### Build Configuration

#### Multi-Configuration Support

```cmake
# Support multiple build types
set(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo;MinSizeRel" CACHE STRING "")

# Set default build type
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "RelWithDebInfo" "MinSizeRel")
endif()

# Configuration-specific settings
target_compile_definitions(your_app PRIVATE
    $<$<CONFIG:Debug>:DEBUG_BUILD>
    $<$<CONFIG:Release>:RELEASE_BUILD>
)
```

#### Dependency Management

```cmake
# Use FetchContent for automatic dependency management
include(FetchContent)

# Declare dependencies
FetchContent_Declare(
    spidermonkey
    GIT_REPOSITORY <repository-url>
    GIT_TAG main
    GIT_SHALLOW TRUE
)

# Make available
FetchContent_MakeAvailable(spidermonkey)

# Alternative: ExternalProject for more control
include(ExternalProject)
ExternalProject_Add(
    spidermonkey_external
    GIT_REPOSITORY <repository-url>
    GIT_TAG main
    CMAKE_ARGS -DSPIDERMONKEY_BUILD_EXAMPLES=OFF
    INSTALL_COMMAND ""
)
```

### Testing Integration

#### Unit Tests with SpiderMonkey

```cpp
// Using Google Test
#include <gtest/gtest.h>
#include "js_engine.h"

class JSEngineTest : public ::testing::Test {
protected:
    void SetUp() override {
        ASSERT_TRUE(engine_.initialize());
    }
    
    void TearDown() override {
        engine_.shutdown();
    }
    
    js::Engine engine_;
};

TEST_F(JSEngineTest, BasicEvaluation) {
    std::string result;
    EXPECT_TRUE(engine_.evaluate("2 + 3", result));
    EXPECT_EQ(result, "5");
}

TEST_F(JSEngineTest, FunctionCall) {
    std::string result;
    EXPECT_TRUE(engine_.evaluate("function add(a, b) { return a + b; }", result));
    EXPECT_TRUE(engine_.callFunction("add", {"2", "3"}, result));
    EXPECT_EQ(result, "5");
}
```

#### CMake Test Configuration

```cmake
# Enable testing
enable_testing()

# Find test framework
find_package(GTest REQUIRED)

# Create test executable
add_executable(js_tests
    tests/js_engine_test.cpp
    tests/js_value_test.cpp
)

target_link_libraries(js_tests PRIVATE
    SpiderMonkey::spidermonkey
    GTest::gtest_main
    your_js_wrapper
)

# Register tests
gtest_discover_tests(js_tests)

# Custom test target
add_custom_target(run_tests
    COMMAND ${CMAKE_CTEST_COMMAND} --verbose
    DEPENDS js_tests
)
```

---

## API Reference

### Core SpiderMonkey Headers

#### Essential Headers

| Header | Purpose | Key Functions/Classes |
|--------|---------|----------------------|
| `jsapi.h` | Main API header | `JS_Init()`, `JS_NewContext()`, `JS_DestroyContext()` |
| `js/Initialization.h` | Engine initialization | `JS_Init()`, `JS_ShutDown()` |
| `js/Context.h` | Context management | `JSContext`, context operations |
| `js/CompilationAndEvaluation.h` | Script execution | `JS::Evaluate()`, `JS::Compile()` |
| `js/SourceText.h` | Source code handling | `JS::SourceText` |
| `js/Value.h` | JavaScript values | `JS::Value`, `JS::RootedValue` |
| `js/Object.h` | Object operations | `JSObject`, object manipulation |
| `js/Array.h` | Array operations | Array creation and access |
| `js/Function.h` | Function operations | Function calls and creation |
| `js/Exception.h` | Error handling | Exception management |

#### Utility Headers

| Header | Purpose | Key Components |
|--------|---------|----------------|
| `mozilla/Assertions.h` | Debug assertions | `MOZ_ASSERT()`, `MOZ_CRASH()` |
| `mozilla/Attributes.h` | Compiler attributes | `MOZ_MUST_USE`, `MOZ_RAII` |
| `mozilla/Types.h` | Basic types | `char16_t`, size types |
| `mozilla/UniquePtr.h` | Smart pointers | `mozilla::UniquePtr` |
| `mozilla/Vector.h` | Dynamic arrays | `mozilla::Vector` |

### Common API Patterns

#### Engine Initialization

```cpp
#include "jsapi.h"
#include "js/Initialization.h"

// Initialize SpiderMonkey
bool initializeJS() {
    return JS_Init();
}

// Create context
JSContext* createContext() {
    return JS_NewContext(JS::DefaultHeapMaxBytes);
}

// Cleanup
void shutdownJS(JSContext* cx) {
    if (cx) {
        JS_DestroyContext(cx);
    }
    JS_ShutDown();
}
```

#### Script Evaluation

```cpp
#include "js/CompilationAndEvaluation.h"
#include "js/SourceText.h"

bool evaluateScript(JSContext* cx, JSObject* global, 
                   const char* script, JS::MutableHandleValue result) {
    JSAutoRealm ar(cx, global);
    
    JS::SourceText<mozilla::Utf8Unit> source;
    if (!source.init(cx, script, strlen(script), 
                     JS::SourceOwnership::Borrowed)) {
        return false;
    }
    
    return JS::Evaluate(cx, source, result);
}
```

#### Value Conversion

```cpp
#include "js/Value.h"
#include "js/Conversions.h"

// Convert C++ to JavaScript
JS::Value cppToJS(JSContext* cx, int value) {
    return JS::Int32Value(value);
}

JS::Value cppToJS(JSContext* cx, const std::string& str) {
    JSString* jsStr = JS_NewStringCopyZ(cx, str.c_str());
    return JS::StringValue(jsStr);
}

// Convert JavaScript to C++
bool jsToCpp(JSContext* cx, JS::HandleValue val, int& result) {
    if (!val.isNumber()) return false;
    result = val.toInt32();
    return true;
}

bool jsToCpp(JSContext* cx, JS::HandleValue val, std::string& result) {
    if (!val.isString()) return false;
    JSString* str = val.toString();
    JS::UniqueChars chars = JS_EncodeStringToUTF8(cx, str);
    if (!chars) return false;
    result = chars.get();
    return true;
}
```

#### Function Calls

```cpp
#include "js/CallAndConstruct.h"

bool callJSFunction(JSContext* cx, JSObject* global,
                   const char* functionName,
                   const JS::HandleValueArray& args,
                   JS::MutableHandleValue result) {
    JSAutoRealm ar(cx, global);
    
    JS::RootedValue funVal(cx);
    if (!JS_GetProperty(cx, global, functionName, &funVal)) {
        return false;
    }
    
    if (!funVal.isObject() || !JS::IsCallable(&funVal.toObject())) {
        return false;
    }
    
    return JS::Call(cx, global, funVal, args, result);
}
```

#### Error Handling

```cpp
#include "js/Exception.h"

void setupErrorReporter(JSContext* cx) {
    JS_SetErrorReporter(cx, [](JSContext* cx, JSErrorReport* report) {
        fprintf(stderr, "JS Error: %s\n", report->message().c_str());
    });
}

bool checkException(JSContext* cx) {
    if (JS_IsExceptionPending(cx)) {
        JS::RootedValue exception(cx);
        if (JS_GetPendingException(cx, &exception)) {
            // Handle exception
            JS_ClearPendingException(cx);
        }
        return true;
    }
    return false;
}
```

### CMake Target Properties

#### SpiderMonkey::spidermonkey Target

The `SpiderMonkey::spidermonkey` target provides:

**Interface Include Directories:**
- SpiderMonkey header directories
- Mozilla utility header directories

**Interface Compile Features:**
- C++17 standard requirement

**Interface Link Libraries:**
- System SpiderMonkey library (when available)
- Required system libraries (pthread, dl, etc.)

**Interface Compile Definitions:**
- Platform-specific definitions
- SpiderMonkey version macros

#### Target Usage

```cmake
# Basic usage
target_link_libraries(your_target PRIVATE SpiderMonkey::spidermonkey)

# Get target properties
get_target_property(SM_INCLUDES SpiderMonkey::spidermonkey INTERFACE_INCLUDE_DIRECTORIES)
get_target_property(SM_LIBRARIES SpiderMonkey::spidermonkey INTERFACE_LINK_LIBRARIES)
get_target_property(SM_FEATURES SpiderMonkey::spidermonkey INTERFACE_COMPILE_FEATURES)

message(STATUS "SpiderMonkey includes: ${SM_INCLUDES}")
message(STATUS "SpiderMonkey libraries: ${SM_LIBRARIES}")
message(STATUS "SpiderMonkey features: ${SM_FEATURES}")
```

---

## Complete Example Project

### Project Structure

```
example-js-app/
├── CMakeLists.txt
├── external/
│   └── spidermonkey/          # This SpiderMonkey project
├── include/
│   └── js_wrapper.h
├── src/
│   ├── main.cpp
│   └── js_wrapper.cpp
├── scripts/
│   └── test.js
└── README.md
```

### CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.20)
project(ExampleJSApp VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add SpiderMonkey
add_subdirectory(external/spidermonkey)

# Create executable
add_executable(js_app
    src/main.cpp
    src/js_wrapper.cpp
)

# Link libraries
target_link_libraries(js_app PRIVATE SpiderMonkey::spidermonkey)

# Include directories
target_include_directories(js_app PRIVATE include)

# Set output directory
set_target_properties(js_app PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Copy test script
configure_file(scripts/test.js ${CMAKE_BINARY_DIR}/bin/test.js COPYONLY)
```

### js_wrapper.h

```cpp
#pragma once

#include "jsapi.h"
#include "js/Initialization.h"
#include "js/CompilationAndEvaluation.h"
#include "js/SourceText.h"
#include <string>
#include <memory>

class JSWrapper {
public:
    JSWrapper();
    ~JSWrapper();
    
    bool initialize();
    void shutdown();
    
    bool evaluateScript(const std::string& script, std::string& result);
    bool evaluateFile(const std::string& filename, std::string& result);
    
    bool isInitialized() const { return initialized_; }

private:
    bool initialized_;
    JSContext* context_;
    JS::PersistentRootedObject global_;
    
    std::string readFile(const std::string& filename);
    void reportError(JSContext* cx);
};
```

### js_wrapper.cpp

```cpp
#include "js_wrapper.h"
#include "js/Context.h"
#include "js/Exception.h"
#include <fstream>
#include <sstream>
#include <iostream>

JSWrapper::JSWrapper() : initialized_(false), context_(nullptr) {}

JSWrapper::~JSWrapper() {
    shutdown();
}

bool JSWrapper::initialize() {
    if (initialized_) {
        return true;
    }
    
    if (!JS_Init()) {
        std::cerr << "Failed to initialize SpiderMonkey" << std::endl;
        return false;
    }
    
    context_ = JS_NewContext(JS::DefaultHeapMaxBytes);
    if (!context_) {
        std::cerr << "Failed to create JavaScript context" << std::endl;
        JS_ShutDown();
        return false;
    }
    
    // Set error reporter
    JS_SetErrorReporter(context_, [](JSContext* cx, JSErrorReport* report) {
        std::cerr << "JS Error: " << report->message().c_str() << std::endl;
    });
    
    initialized_ = true;
    return true;
}

void JSWrapper::shutdown() {
    if (!initialized_) {
        return;
    }
    
    global_.reset();
    
    if (context_) {
        JS_DestroyContext(context_);
        context_ = nullptr;
    }
    
    JS_ShutDown();
    initialized_ = false;
}

bool JSWrapper::evaluateScript(const std::string& script, std::string& result) {
    if (!initialized_) {
        result = "JavaScript engine not initialized";
        return false;
    }
    
    // Note: This is a header-only demonstration
    // Full script evaluation requires system SpiderMonkey library
    result = "Script evaluation requires system SpiderMonkey library installation";
    std::cout << "Script to evaluate: " << script << std::endl;
    std::cout << "Headers are available for compilation" << std::endl;
    
    return false; // Would return true with system library
}

bool JSWrapper::evaluateFile(const std::string& filename, std::string& result) {
    std::string script = readFile(filename);
    if (script.empty()) {
        result = "Failed to read file: " + filename;
        return false;
    }
    
    return evaluateScript(script, result);
}

std::string JSWrapper::readFile(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        return "";
    }
    
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

void JSWrapper::reportError(JSContext* cx) {
    if (JS_IsExceptionPending(cx)) {
        JS_ClearPendingException(cx);
    }
}
```

### main.cpp

```cpp
#include "js_wrapper.h"
#include <iostream>
#include <string>

int main() {
    std::cout << "SpiderMonkey CMake Integration Example" << std::endl;
    std::cout << "=====================================" << std::endl;
    
    JSWrapper js;
    
    if (!js.initialize()) {
        std::cerr << "Failed to initialize JavaScript engine" << std::endl;
        return 1;
    }
    
    std::cout << "JavaScript engine initialized successfully!" << std::endl;
    
    // Test script evaluation
    std::string result;
    std::string script = "var x = 10; var y = 20; x + y;";
    
    std::cout << "\nTesting script evaluation..." << std::endl;
    if (js.evaluateScript(script, result)) {
        std::cout << "Result: " << result << std::endl;
    } else {
        std::cout << "Info: " << result << std::endl;
    }
    
    // Test file evaluation
    std::cout << "\nTesting file evaluation..." << std::endl;
    if (js.evaluateFile("test.js", result)) {
        std::cout << "File result: " << result << std::endl;
    } else {
        std::cout << "File info: " << result << std::endl;
    }
    
    std::cout << "\nTo enable full JavaScript execution:" << std::endl;
    std::cout << "1. Install system SpiderMonkey library:" << std::endl;
    std::cout << "   macOS: brew install spidermonkey" << std::endl;
    std::cout << "   Ubuntu: sudo apt install libmozjs-128-dev" << std::endl;
    std::cout << "2. Rebuild the project" << std::endl;
    std::cout << "3. The same headers will work with the system library" << std::endl;
    
    std::cout << "\nShutting down..." << std::endl;
    return 0;
}
```

### test.js

```javascript
// Test JavaScript file
console.log("Hello from JavaScript!");

function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(10);
console.log("Fibonacci(10) =", result);

// Object and array examples
var person = {
    name: "Alice",
    age: 30,
    greet: function() {
        return "Hello, I'm " + this.name;
    }
};

var numbers = [1, 2, 3, 4, 5];
var sum = numbers.reduce(function(a, b) { return a + b; }, 0);

console.log("Person:", person.greet());
console.log("Sum:", sum);
```

### Build and Run

```bash
# Clone SpiderMonkey CMake project into external/
git submodule add <repository-url> external/spidermonkey

# Build
mkdir build && cd build
cmake ..
make -j$(nproc)

# Run
./bin/js_app
```

---

## Conclusion

This comprehensive installation manual covers all aspects of using the SpiderMonkey CMake project:

### Key Takeaways

1. **Header Distribution**: This project provides complete SpiderMonkey headers for compilation
2. **CMake Integration**: Easy integration as a subdirectory with `SpiderMonkey::spidermonkey` target
3. **System Library**: Install system SpiderMonkey library for full JavaScript execution
4. **Cross-Platform**: Works on Linux, macOS, and Windows
5. **Modern CMake**: Uses CMake 3.20+ with modern practices

### Quick Reference

**Basic Integration:**
```cmake
add_subdirectory(external/spidermonkey)
target_link_libraries(your_app PRIVATE SpiderMonkey::spidermonkey)
```

**System Library Installation:**
```bash
# macOS
brew install spidermonkey

# Ubuntu/Debian
sudo apt install libmozjs-128-dev
```

**Build Commands:**
```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
```

### Support and Resources

- **SpiderMonkey Documentation**: https://spidermonkey.dev/
- **Mozilla Developer Network**: https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey
- **CMake Documentation**: https://cmake.org/documentation/

This manual should provide everything needed to successfully integrate SpiderMonkey into your C/C++ projects using CMake. The project is designed to be as simple as possible while providing maximum flexibility for different use cases.
