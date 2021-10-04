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

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set_target_properties(MWindowApp PROPERTIES INSTALL_RPATH
                                              "@loader_path/../Frameworks")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  set_target_properties(MWindowApp PROPERTIES INSTALL_RPATH
                                              "\$ORIGIN/../${LIB_DIR}")
endif()

install(
  TARGETS MWindowApp
  BUNDLE DESTINATION . COMPONENT Runtime
  RUNTIME DESTINATION bin COMPONENT Runtime)

include(InstallQt5Libs)

# Determine location of QT libraries and frameworks
get_property(
  _Qt5_Widgets_LOCATION
  TARGET Qt5::Widgets
  PROPERTY LOCATION)
get_filename_component(Qt_LIB_DIR "${_Qt5_Wigets_LOCATION}" PATH)
if(APPLE)
  get_filename_component(Qt_LIB_DIR "${Qt_LIB_DIR}" PATH)
endif(APPLE)

message("${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS}")

set(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
include(InstallRequiredSystemLibraries)

# Apples bundle things
if(APPLE)
  set(BUNDLE_DIR "MWindowApp.app")
  install_qt5_plugin("Qt5::Widgets" plugins_to_fixup
                     "${BUNDLE_DIR}/Contents/Frameworks")

  # Qt config
  install(CODE "file(WRITE
\"\${CMAKE_INSTALL_PREFIX}/${BUNDLE_DIR}/Contents/Resources/qt.conf\"
\"[Paths]\nPlugins = PlugIns\nTranslations = i18n\n\")")

  # Qt plugins & bundle
  install(CODE " include(BundleUtilities)
fixup_bundle(\"\${CMAKE_INSTALL_PREFIX}/${BUNDLE_DIR}\"
\"${plugins_to_fixup}\" \"${CMAKE_INSTALL_PREFIX}/${BUNDLE_DIR}/Contents/Frameworks\")")

endif()

set(MY_DEPENDENCY_PATHS /usr/lib)
install(CODE "set(MY_DEPENDENCY_PATHS \"${MY_DEPENDENCY_PATHS}\")")



# This will analyse every otool dependency and copy it into the frameworks folder of the bundle
# We probably then need to do something./..
install(
  CODE [[
  file(GET_RUNTIME_DEPENDENCIES
    EXECUTABLES $<TARGET_FILE:MWindowApp>
    RESOLVED_DEPENDENCIES_VAR _r_deps
    UNRESOLVED_DEPENDENCIES_VAR _u_deps
    DIRECTORIES ${MY_DEPENDENCY_PATHS}
  )
  message("${_r_deps}")
  foreach(_file ${_r_deps})
    file(INSTALL
      DESTINATION "${CMAKE_INSTALL_PREFIX}/MWindowApp.app/Contents/Frameworks"
      TYPE SHARED_LIBRARY
      FILES "${_file}"
    )
  endforeach()
  list(LENGTH _u_deps _u_length)
  if("${_u_length}" GREATER 0)
    message(WARNING "Unresolved dependencies detected!")
  endif()
]])
# this will miss the qt plugins - and extra qt stuff, we should fix this
# manually
