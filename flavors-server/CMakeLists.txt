cmake_minimum_required(VERSION 3.5)
project(flavors-server)

# Set the build type to Release if not specified
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

execute_process(COMMAND stack build)
file(RENAME .stack-work ${CMAKE_CURRENT_BINARY_DIR}/stack-work)

# Option to enable/disable unit testing
option(BUILD_TESTS "Build unit tests" OFF)

# If unit tests are enabled, add the tests directory
# if (BUILD_TESTS)
#     enable_testing()
#     add_subdirectory(tests)
# endif()
