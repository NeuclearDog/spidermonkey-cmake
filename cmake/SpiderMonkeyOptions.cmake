# SpiderMonkey Build Options

# Core build options
option(SPIDERMONKEY_BUILD_EXAMPLES "Build example programs" ON)
option(SPIDERMONKEY_BUILD_TESTS "Build test programs" OFF)
option(SPIDERMONKEY_INSTALL "Enable installation" OFF)

# Debug and development options
option(SPIDERMONKEY_ENABLE_DEBUG "Enable debug mode" OFF)
option(SPIDERMONKEY_ENABLE_PROFILING "Enable profiling support" OFF)
option(SPIDERMONKEY_ENABLE_TRACE_LOGGING "Enable trace logging" OFF)
option(SPIDERMONKEY_STRICT_MODE "Enable strict compilation warnings" OFF)
option(SPIDERMONKEY_OPTIMIZE_SIZE "Optimize for size instead of speed" OFF)

# JavaScript feature options
option(SPIDERMONKEY_ENABLE_INTL "Enable Internationalization API" ON)
option(SPIDERMONKEY_ENABLE_SHARED_MEMORY "Enable SharedArrayBuffer support" ON)
option(SPIDERMONKEY_ENABLE_STREAMS "Enable Streams API" ON)
option(SPIDERMONKEY_ENABLE_BIGINT "Enable BigInt support" ON)
option(SPIDERMONKEY_ENABLE_WASM "Enable WebAssembly support" ON)
option(SPIDERMONKEY_ENABLE_TEMPORAL "Enable Temporal API" OFF)
option(SPIDERMONKEY_ENABLE_REGEXP "Enable RegExp support" ON)
option(SPIDERMONKEY_ENABLE_JSON "Enable JSON support" ON)

# Advanced options
option(SPIDERMONKEY_ENABLE_JIT "Enable Just-In-Time compilation" ON)
option(SPIDERMONKEY_ENABLE_ION "Enable Ion optimizing compiler" ON)
option(SPIDERMONKEY_ENABLE_BASELINE "Enable Baseline JIT" ON)
option(SPIDERMONKEY_ENABLE_GC_ZEAL "Enable GC debugging features" OFF)
option(SPIDERMONKEY_ENABLE_CTYPES "Enable ctypes support" OFF)

# Example options
option(SPIDERMONKEY_BUILD_BASIC_EXAMPLE "Build basic C example" ON)
option(SPIDERMONKEY_BUILD_ADVANCED_EXAMPLE "Build advanced C++ example" ON)
option(SPIDERMONKEY_BUILD_INTERACTIVE_EXAMPLE "Build interactive shell example" ON)
option(SPIDERMONKEY_BUILD_MODULE_EXAMPLE "Build ES6 module example" ON)
