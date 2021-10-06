cmake_minimum_required(VERSION 3.16)

project(mantid_package_example)

enable_language(CXX)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

set(MINIMUM_PYTHON_VERSION 3.7)
find_package(Python ${MINIMUM_PYTHON_VERSION} REQUIRED
             COMPONENTS Interpreter Development NumPy)

find_package(PyQt5 REQUIRED)
find_package(SIP REQUIRED)
find_package(Qt5 COMPONENTS Core Gui Widgets)

find_package(Boost)

if(APPLE)
  set(MWINDOW_BUNDLE MWindowApp.app/Contents/)
  set(MWINDOW_BIN_DIR ${MWINDOW_BUNDLE}MacOS)
  set(MWINDOW_LIB_DIR ${MWINDOW_BUNDLE}MacOS)
  set(MWINDOW_SITE_PACKAGES ${MWINDOW_BUNDLE}MacOS)
endif()

add_subdirectory(src)
add_subdirectory(construct)
#add_subdirectory(bundle-scripts)


include(MWindowCPack)



