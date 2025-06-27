# SpiderMonkey Examples using the SpiderMonkey subdirectory

# Basic JavaScript execution example (C++)
if(SPIDERMONKEY_BUILD_BASIC_EXAMPLE)
  add_executable(basic_js basic_js.cpp)
  target_link_libraries(basic_js PRIVATE SpiderMonkey::spidermonkey)
  
  message(STATUS "Building basic C++ example")
endif()

# Advanced JavaScript execution example (C++)
if(SPIDERMONKEY_BUILD_ADVANCED_EXAMPLE)
  add_executable(advanced_js advanced_js.cpp)
  target_link_libraries(advanced_js PRIVATE SpiderMonkey::spidermonkey)
  
  message(STATUS "Building advanced C++ example")
endif()

# Interactive JavaScript shell (C++)
if(SPIDERMONKEY_BUILD_INTERACTIVE_EXAMPLE)
  add_executable(interactive_js interactive_js.cpp)
  target_link_libraries(interactive_js PRIVATE SpiderMonkey::spidermonkey)
  
  message(STATUS "Building interactive shell example")
endif()

# Collect all example targets
set(EXAMPLE_TARGETS "")

if(SPIDERMONKEY_BUILD_BASIC_EXAMPLE)
  list(APPEND EXAMPLE_TARGETS basic_js)
endif()

if(SPIDERMONKEY_BUILD_ADVANCED_EXAMPLE)
  list(APPEND EXAMPLE_TARGETS advanced_js)
endif()

if(SPIDERMONKEY_BUILD_INTERACTIVE_EXAMPLE)
  list(APPEND EXAMPLE_TARGETS interactive_js)
endif()

# Set output directory for all examples
if(EXAMPLE_TARGETS)
  set_target_properties(${EXAMPLE_TARGETS} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
  )
  
  # Custom target to build all examples
  add_custom_target(examples
    DEPENDS ${EXAMPLE_TARGETS}
    COMMENT "Building SpiderMonkey JavaScript execution examples"
  )
  
  message(STATUS "SpiderMonkey examples configured:")
  foreach(target ${EXAMPLE_TARGETS})
    message(STATUS "  - ${target}")
  endforeach()
else()
  message(STATUS "No examples enabled")
endif()
