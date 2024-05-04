cmake_minimum_required(VERSION 3.5)
project(flavors-client)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # for NVIM LSP to work.

# Set Qt stuff.
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Set the build type to Release if not specified
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Find Qt5
find_package(Qt5 HINTS ${QT_ROOT}/lib/cmake/Qt5 REQUIRED Core Gui Quick Qml QuickControls2 COMPONENTS)

file(GLOB_RECURSE SOURCES src/*.cpp)
file(GLOB_RECURSE HEADERS include/*.h include/*.hpp)

# Add the QML resources
qt_add_resources(QML_RESOURCES qml.qrc)
add_executable(flavors-client
    ${QML_RESOURCES}
    ${SOURCES}
    ${HEADERS}
    qml.qrc
)

include_directories(include)
target_link_libraries(flavors-client PRIVATE
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
)
