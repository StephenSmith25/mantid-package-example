# Find includes in the build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Turn on automatic invocation of the MOC, UIC & RCC
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

if(WIN32)
  set(CMAKE_WIN32_EXECUTABLE ON)
endif()

# Find the QtWidgets library
find_package(Qt5 REQUIRED COMPONENTS Widgets)

# NOTE: Don't include the path in MACOSX_BUNDLE_ICON_FILE -- this is the
# property added to Info.plist
set(MACOSX_BUNDLE_ICON_FILE icon)

# And this part tells CMake where to find and install the file itself
set(MWindowApp_ICON ${CMAKE_SOURCE_DIR}/install/icons/icon.icns)
set_source_files_properties(${MWindowApp_ICON}
                            PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

add_executable(
  MWindowApp MACOSX_BUNDLE ${MWindowApp_ICON} main.cpp mainwindow.cpp
                           mainwindow.ui resources.qrc)
target_link_libraries(MWindowApp Qt5::Widgets)

install(
  TARGETS MWindowApp
  BUNDLE DESTINATION . COMPONENT Runtime
  RUNTIME DESTINATION bin COMPONENT Runtime)
