

# NOTE: Don't include the path in MACOSX_BUNDLE_ICON_FILE -- this is
# the property added to Info.plist
set(MACOSX_BUNDLE_ICON_FILE icon.icns)

# And this part tells CMake where to find and install the file itself
set(MWindowApp_ICON ${CMAKE_SOURCE_DIR}/install/icons/icon.icns)
set_source_files_properties(${MWindowApp_ICON} PROPERTIES
       MACOSX_PACKAGE_LOCATION "Resources")

add_executable(MWindowApp MACOSX_BUNDLE ${MWindowApp_ICON} main.cpp)

