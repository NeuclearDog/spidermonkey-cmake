# SpiderMonkey Library Configuration

# Collect SpiderMonkey headers
set(SPIDERMONKEY_HEADERS
  fdlibm.h
  BaseProfiler.h
  jsapi.h
  mozmemory.h
  jstypes.h
  encoding_rs_mem.h
  mozmemory_utils.h
  jspubtd.h
  BaseProfilerSharedLibraries.h
  mozjemalloc_types.h
  jsfriendapi.h
  PHC.h
  BaseProfilingCategory.h
  malloc_decls.h
  mozmemory_wrap.h
  js-config.h
)

# Collect all headers recursively
file(GLOB_RECURSE MOZILLA_HEADERS "mozilla/*.h")
file(GLOB_RECURSE JS_HEADERS "js/*.h")
file(GLOB_RECURSE DOUBLE_CONVERSION_HEADERS "double-conversion/*.h")
file(GLOB_RECURSE FUNCTION2_HEADERS "function2/*.hpp")

# Create SpiderMonkey interface library
add_library(spidermonkey INTERFACE)

# Add include directories
target_include_directories(spidermonkey INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
)

# Add compile definitions based on options
target_compile_definitions(spidermonkey INTERFACE
  SPIDERMONKEY_VERSION_MAJOR=${PROJECT_VERSION_MAJOR}
  SPIDERMONKEY_VERSION_MINOR=${PROJECT_VERSION_MINOR}
  SPIDERMONKEY_VERSION_PATCH=${PROJECT_VERSION_PATCH}
)

# Feature-based definitions
if(SPIDERMONKEY_ENABLE_DEBUG)
  target_compile_definitions(spidermonkey INTERFACE DEBUG=1 JS_DEBUG=1)
endif()

if(SPIDERMONKEY_ENABLE_PROFILING)
  target_compile_definitions(spidermonkey INTERFACE JS_ENABLE_PROFILING=1)
endif()

if(SPIDERMONKEY_ENABLE_TRACE_LOGGING)
  target_compile_definitions(spidermonkey INTERFACE JS_TRACE_LOGGING=1)
endif()

if(NOT SPIDERMONKEY_ENABLE_INTL)
  target_compile_definitions(spidermonkey INTERFACE JS_WITHOUT_INTL=1)
endif()

if(NOT SPIDERMONKEY_ENABLE_SHARED_MEMORY)
  target_compile_definitions(spidermonkey INTERFACE JS_WITHOUT_SHARED_MEMORY=1)
endif()

if(SPIDERMONKEY_ENABLE_BIGINT)
  target_compile_definitions(spidermonkey INTERFACE JS_HAS_BIGINT=1)
endif()

if(SPIDERMONKEY_ENABLE_WASM)
  target_compile_definitions(spidermonkey INTERFACE JS_HAS_WASM=1)
endif()

if(SPIDERMONKEY_ENABLE_TEMPORAL)
  target_compile_definitions(spidermonkey INTERFACE JS_HAS_TEMPORAL_API=1)
endif()

if(NOT SPIDERMONKEY_ENABLE_JIT)
  target_compile_definitions(spidermonkey INTERFACE JS_WITHOUT_JIT=1)
endif()

if(SPIDERMONKEY_ENABLE_GC_ZEAL)
  target_compile_definitions(spidermonkey INTERFACE JS_GC_ZEAL=1)
endif()

if(SPIDERMONKEY_ENABLE_CTYPES)
  target_compile_definitions(spidermonkey INTERFACE JS_HAS_CTYPES=1)
endif()

# Platform-specific libraries
if(APPLE)
  target_link_libraries(spidermonkey INTERFACE "-framework CoreFoundation")
elseif(UNIX)
  target_link_libraries(spidermonkey INTERFACE pthread dl m)
endif()

# Create alias
add_library(SpiderMonkey::spidermonkey ALIAS spidermonkey)

message(STATUS "SpiderMonkey library configuration complete")
message(STATUS "Note: Examples are demonstration programs")
message(STATUS "For full JavaScript execution, install SpiderMonkey library:")
message(STATUS "  macOS: brew install spidermonkey")
message(STATUS "  Ubuntu: apt install libmozjs-128-dev")
