cmake_minimum_required(VERSION 3.20)

project(spidermonkey
  LANGUAGES C CXX
  VERSION 128.0.0
  DESCRIPTION "Mozilla SpiderMonkey JavaScript Engine"
)

# Add cmake modules path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Include modular configuration files
include(SpiderMonkeyOptions)
include(SpiderMonkeyCompiler)
include(SpiderMonkeyLibrary)

# Examples
if(SPIDERMONKEY_BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

# Tests
if(SPIDERMONKEY_BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif()

# Installation
if(SPIDERMONKEY_INSTALL)
  include(GNUInstallDirs)
  include(cmake/SpiderMonkeyInstall.cmake)
endif()

# Print configuration summary
message(STATUS "")
message(STATUS "SpiderMonkey Configuration Summary:")
message(STATUS "  Version: ${PROJECT_VERSION}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Build examples: ${SPIDERMONKEY_BUILD_EXAMPLES}")
message(STATUS "  Build tests: ${SPIDERMONKEY_BUILD_TESTS}")
message(STATUS "  Enable debug: ${SPIDERMONKEY_ENABLE_DEBUG}")
message(STATUS "  Enable profiling: ${SPIDERMONKEY_ENABLE_PROFILING}")
message(STATUS "  Enable trace logging: ${SPIDERMONKEY_ENABLE_TRACE_LOGGING}")
message(STATUS "  Enable Intl API: ${SPIDERMONKEY_ENABLE_INTL}")
message(STATUS "  Enable SharedArrayBuffer: ${SPIDERMONKEY_ENABLE_SHARED_MEMORY}")
message(STATUS "  Enable BigInt: ${SPIDERMONKEY_ENABLE_BIGINT}")
message(STATUS "  Enable WebAssembly: ${SPIDERMONKEY_ENABLE_WASM}")
message(STATUS "  Enable JIT: ${SPIDERMONKEY_ENABLE_JIT}")
message(STATUS "  Strict mode: ${SPIDERMONKEY_STRICT_MODE}")
message(STATUS "  Install: ${SPIDERMONKEY_INSTALL}")
message(STATUS "")
