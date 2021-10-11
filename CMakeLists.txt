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
  set(MantidPrototype_BUNDLE MantidPrototype.app/Contents/)
  set(MantidPrototype_BIN_DIR ${MantidPrototype_BUNDLE}MacOS)
  set(MantidPrototype_LIB_DIR ${MantidPrototype_BUNDLE}MacOS)
  set(MantidPrototype_SITE_PACKAGES ${MantidPrototype_BUNDLE}MacOS)
elseif(WIN32)
  set(MantidPrototype_BIN_DIR bin)
  set(MantidPrototype_LIB_DIR lib)
  set(MantidPrototype_SITE_PACKAGES lib)
endif()



add_subdirectory(src)
add_subdirectory(construct)
#add_subdirectory(bundle-scripts)


include(MantidPrototypeCPack)



