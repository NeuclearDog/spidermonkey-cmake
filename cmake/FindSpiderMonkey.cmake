# Find SpiderMonkey Library

find_package(PkgConfig QUIET)

if(PKG_CONFIG_FOUND)
  # Set pkg-config path for macOS Homebrew
  set(ENV{PKG_CONFIG_PATH} "/usr/local/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
  
  pkg_check_modules(MOZJS QUIET mozjs-128)
  if(MOZJS_FOUND)
    message(STATUS "Found system SpiderMonkey ${MOZJS_VERSION}")
    target_link_libraries(spidermonkey INTERFACE ${MOZJS_LIBRARIES})
    target_link_directories(spidermonkey INTERFACE ${MOZJS_LIBRARY_DIRS})
    target_compile_options(spidermonkey INTERFACE ${MOZJS_CFLAGS_OTHER})
    # Add system include directories for examples
    target_include_directories(spidermonkey INTERFACE ${MOZJS_INCLUDE_DIRS})
    set(SPIDERMONKEY_SYSTEM_FOUND TRUE PARENT_SCOPE)
  else()
    # Try to find library manually
    find_library(MOZJS_LIBRARY 
      NAMES mozjs-128 js mozjs
      PATHS /usr/local/lib /usr/lib /opt/local/lib
    )
    
    if(MOZJS_LIBRARY)
      message(STATUS "Found SpiderMonkey library: ${MOZJS_LIBRARY}")
      target_link_libraries(spidermonkey INTERFACE ${MOZJS_LIBRARY})
      
      # Try to find include directory
      find_path(MOZJS_INCLUDE_DIR jsapi.h
        PATHS /usr/local/include/mozjs-128 /usr/include/mozjs-128
              /usr/local/include /usr/include
      )
      
      if(MOZJS_INCLUDE_DIR)
        message(STATUS "Found SpiderMonkey headers: ${MOZJS_INCLUDE_DIR}")
        target_include_directories(spidermonkey INTERFACE ${MOZJS_INCLUDE_DIR})
        set(SPIDERMONKEY_SYSTEM_FOUND TRUE PARENT_SCOPE)
      else()
        message(WARNING "SpiderMonkey headers not found in system")
        set(SPIDERMONKEY_SYSTEM_FOUND FALSE PARENT_SCOPE)
      endif()
    else()
      message(WARNING "SpiderMonkey library not found.")
      message(WARNING "Install SpiderMonkey library:")
      message(WARNING "  macOS: brew install spidermonkey")
      message(WARNING "  Ubuntu: apt install libmozjs-128-dev")
      set(SPIDERMONKEY_SYSTEM_FOUND FALSE PARENT_SCOPE)
    endif()
  endif()
else()
  message(WARNING "pkg-config not found. Cannot detect system SpiderMonkey.")
  set(SPIDERMONKEY_SYSTEM_FOUND FALSE PARENT_SCOPE)
endif()
