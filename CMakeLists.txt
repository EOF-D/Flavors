cmake_minimum_required(VERSION 3.5)
project(flavors-client)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON) # for NVIM LSP to work.

# Set the build type to Release if not specified
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

add_subdirectory(flavors-client)

# Option to enable/disable unit testing
option(BUILD_TESTS "Build unit tests" OFF)

# If unit tests are enabled, add the tests directory
# if (BUILD_TESTS)
#     enable_testing()
#     add_subdirectory(tests)
# endif()
