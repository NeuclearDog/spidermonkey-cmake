# SpiderMonkey Compiler Configuration

# Set standards
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# Compiler-specific flags
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  if(SPIDERMONKEY_STRICT_MODE)
    add_compile_options(-Wall -Wextra -Wpedantic -Werror)
  else()
    add_compile_options(-Wall -Wno-unused-parameter -Wno-unused-variable)
  endif()
  
  if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR SPIDERMONKEY_ENABLE_DEBUG)
    add_compile_options(-g -O0)
    add_compile_definitions(DEBUG=1 JS_DEBUG=1)
  else()
    if(SPIDERMONKEY_OPTIMIZE_SIZE)
      add_compile_options(-Os)
    else()
      add_compile_options(-O2)
    endif()
    add_compile_definitions(NDEBUG)
  endif()
  
  # Additional flags for SpiderMonkey
  add_compile_options(-fno-rtti -fno-exceptions)
  
elseif(MSVC)
  if(SPIDERMONKEY_STRICT_MODE)
    add_compile_options(/W4 /WX)
  else()
    add_compile_options(/W3)
  endif()
  
  if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR SPIDERMONKEY_ENABLE_DEBUG)
    add_compile_options(/Od /Zi)
    add_compile_definitions(DEBUG=1 JS_DEBUG=1)
  else()
    if(SPIDERMONKEY_OPTIMIZE_SIZE)
      add_compile_options(/Os)
    else()
      add_compile_options(/O2)
    endif()
    add_compile_definitions(NDEBUG)
  endif()
endif()

message(STATUS "Compiler configuration:")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "  C Standard: ${CMAKE_C_STANDARD}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Strict Mode: ${SPIDERMONKEY_STRICT_MODE}")
message(STATUS "  Optimize Size: ${SPIDERMONKEY_OPTIMIZE_SIZE}")
