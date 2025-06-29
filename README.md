# Stargazers and forkers for this responsitory

[![Stargazers repo roster for @USERNAME/REPO_NAME](https://reporoster.com/stars/NeuclearDog/spidermonkey-cmake)](https://github.com/NeuclearDog/spidermonkey-cmake/stargazers)

[![Forkers repo roster for @USERNAME/REPO_NAME](https://reporoster.com/forks/NeuclearDog/spidermonkey-cmake)](https://github.com/NeuclearDog/spidermonkey-cmake/network/members)



# SpiderMonkey CMake Integration

A complete CMake build system for Mozilla's SpiderMonkey JavaScript engine headers with working integration examples.

## About

This project provides the **actual SpiderMonkey source headers** (mozjs-128) with a CMake integration that allows you to:
- Use SpiderMonkey headers in your C/C++ projects
- Build examples demonstrating CMake integration
- Integrate as a CMake subdirectory in other projects
- Link against system SpiderMonkey library when available

**This IS the SpiderMonkey header distribution that works as a portable CMake subdirectory.**

## Quick Start

### Build and Run Examples

```bash
# Build and run examples
./build.sh

# Clean build with verbose output
./build.sh --clean --verbose

# Debug build
./build.sh --type Debug
```

### Manual CMake Build

```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
./bin/basic_js
./bin/advanced_js
```

## Project Structure

```
spidermonkey/
├── CMakeLists.txt          # Main CMake configuration
├── build.sh               # Automated build script
├── README.md              # This file
├── examples/              # CMake integration examples
│   ├── basic_js.c         # Basic C integration example
│   └── advanced_js.cpp    # Advanced C++ integration example
├── js/                    # SpiderMonkey JS API headers
├── mozilla/               # Mozilla utility headers
├── jsapi.h                # Main SpiderMonkey API header
└── [SpiderMonkey headers...] # Complete SpiderMonkey header set
```

## Using as CMake Subdirectory

This is the primary use case - integrate SpiderMonkey headers into your project:

### In your CMakeLists.txt:
```cmake
# Add SpiderMonkey as subdirectory
add_subdirectory(spidermonkey)

# Link your target against SpiderMonkey
target_link_libraries(your_target PRIVATE SpiderMonkey::spidermonkey)
```

### In your C/C++ code:
```cpp
#include "jsapi.h"
#include "js/Initialization.h"
#include "js/CompilationAndEvaluation.h"
// ... other SpiderMonkey headers as needed

int main() {
    // Initialize SpiderMonkey
    if (!JS_Init()) {
        return 1;
    }
    
    // Create context
    JSContext *cx = JS_NewContext(JS::DefaultHeapMaxBytes);
    
    // ... use SpiderMonkey API
    
    // Cleanup
    JS_DestroyContext(cx);
    JS_ShutDown();
    return 0;
}
```

## Examples

### Basic Integration Example (C)

The `basic_js.c` example demonstrates:
- How to use SpiderMonkey as a CMake subdirectory
- CMake target integration
- Header availability
- Project structure

### Advanced Integration Example (C++)

The `advanced_js.cpp` example shows:
- Modern C++ integration patterns
- SpiderMonkey API usage examples
- Best practices for JavaScript engine integration

## Full JavaScript Execution

For complete JavaScript execution capabilities:

1. **Install system SpiderMonkey library:**
   ```bash
   # macOS
   brew install spidermonkey
   
   # Ubuntu/Debian
   sudo apt install libmozjs-128-dev
   
   # Fedora/CentOS
   sudo dnf install mozjs128-devel
   ```

2. **Use headers from this project** (they're compatible with system library)

3. **Your CMake will automatically link against system library when available**

## Build Options

| Option | Description | Default |
|--------|-------------|---------|
| `SPIDERMONKEY_BUILD_EXAMPLES` | Build integration examples | ON |
| `SPIDERMONKEY_BUILD_TESTS` | Build test programs | OFF |
| `SPIDERMONKEY_INSTALL` | Enable installation | OFF |

## Build Script Options

```bash
Usage: ./build.sh [OPTIONS]

Options:
    -h, --help              Show help
    -t, --type TYPE         Build type (Debug, Release, etc.)
    -c, --clean             Clean build
    -e, --examples          Build examples (default)
    -v, --verbose           Verbose output
    -r, --run               Run examples after build (default)
    -j, --jobs N            Parallel jobs
```

## Requirements

- **CMake**: 3.20+
- **C++ Compiler**: C++17 support (GCC 7+, Clang 5+, MSVC 2017+)
- **C Compiler**: C11 support

## SpiderMonkey Headers Included

This project includes the complete SpiderMonkey header set:

- `jsapi.h` - Main JavaScript API
- `js/Initialization.h` - Engine initialization
- `js/CompilationAndEvaluation.h` - Script execution
- `js/SourceText.h` - Source code handling
- `js/Context.h` - JavaScript contexts
- `js/Value.h` - JavaScript values
- `mozilla/*.h` - Mozilla utility headers
- And many more...

## JavaScript API Usage Examples

When you have the system library installed, you can use patterns like:

```javascript
// Basic JavaScript execution
var result = 2 + 3 * 4;

// String manipulation
var greeting = 'Hello, SpiderMonkey!';

// Functions
function factorial(n) {
    return n <= 1 ? 1 : n * factorial(n - 1);
}

// Arrays
var numbers = [1, 2, 3, 4, 5];
var sum = numbers.reduce((a, b) => a + b, 0);

// Objects
var person = { name: 'Alice', age: 25 };
```

## Integration Examples

### Simple Integration
```cmake
add_subdirectory(spidermonkey)
target_link_libraries(my_app SpiderMonkey::spidermonkey)
```

### Advanced Integration
```cmake
# Add SpiderMonkey
add_subdirectory(external/spidermonkey)

# Create your JavaScript-enabled application
add_executable(js_app main.cpp)
target_link_libraries(js_app PRIVATE SpiderMonkey::spidermonkey)

# Optional: copy SpiderMonkey headers for IDE
target_include_directories(js_app PRIVATE external/spidermonkey)
```

## Troubleshooting

### Build Issues
```bash
# Clean build with verbose output
./build.sh --clean --verbose

# Check requirements
cmake --version  # Should be 3.20+
```

### Header Conflicts
If you encounter header conflicts:
- The project uses minimal include paths by default
- SpiderMonkey headers are available but not automatically included
- Include specific headers as needed: `#include "jsapi.h"`

### System Library Integration
```bash
# Check if system SpiderMonkey is available
pkg-config --exists mozjs-128 && echo "Available" || echo "Not available"

# Install system library for full functionality
brew install spidermonkey  # macOS
```

## License

This project follows Mozilla SpiderMonkey's license (MPL 2.0).

## Resources

- [SpiderMonkey Documentation](https://spidermonkey.dev/)
- [SpiderMonkey Embedding Guide](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/How_to_embed_the_JavaScript_engine)
- [Mozilla SpiderMonkey Source](https://github.com/mozilla/gecko-dev/tree/master/js/src)
- [CMake Documentation](https://cmake.org/documentation/)

---

**This is the complete SpiderMonkey header distribution with CMake integration. Use it as a subdirectory in your projects for JavaScript engine capabilities.**
