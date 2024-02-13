cmake_minimum_required(3.27)
project(flavors-client)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON) # for NVIM LSP to work.

# Set the build type to Release if not specified
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

include_directories(include)
file(GLOB_RECURSE SOURCES src/*.cpp)
file(GLOB_RECURSE HEADERS include/*.hpp)

add_library(FlavorsLib ${SOURCES} ${HEADERS})
add_executable(flavors-client src/main.cpp)
target_link_libraries(flavors-client FlavorsLib)

# Option to enable/disable unit testing
option(BUILD_TESTS "Build unit tests" OFF)

# If unit tests are enabled, add the tests directory
# if (BUILD_TESTS)
#     enable_testing()
#     add_subdirectory(tests)
# endif()
