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
set(MACOSX_BUNDLE_ICON_FILE icon.icns)

# And this part tells CMake where to find and install the file itself
set(MantidPrototype_ICON ${CMAKE_SOURCE_DIR}/install/icons/icon.icns)
set_source_files_properties(${MantidPrototype_ICON}
                            PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

add_executable(
  MantidPrototype MACOSX_BUNDLE ${MantidPrototype_ICON} main.cpp mainwindow.cpp
                           mainwindow.ui resources.qrc)
target_link_libraries(MantidPrototype Qt5::Widgets)

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set_target_properties(MantidPrototype PROPERTIES INSTALL_RPATH
                                              "@loader_path/../Frameworks")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  set_target_properties(MantidPrototype PROPERTIES INSTALL_RPATH
                                              "\$ORIGIN/../${LIB_DIR}")
endif()

set(MY_DEPENDENCY_PATHS /usr/lib)
install(CODE "set(MY_DEPENDENCY_PATHS \"${MY_DEPENDENCY_PATHS}\")")

# This will analyse every otool dependency and copy it into the frameworks
# folder of the bundle We probably then need to do something./.. 
if (APPLE)
install( CODE
[[ file(GET_RUNTIME_DEPENDENCIES EXECUTABLES $<TARGET_FILE:MantidPrototype>
LIBRARIES $<TARGET_FILE:Qt5::QCocoaIntegrationPlugin>
RESOLVED_DEPENDENCIES_VAR _r_deps UNRESOLVED_DEPENDENCIES_VAR _u_deps
DIRECTORIES ${MY_DEPENDENCY_PATHS} ) 
foreach(_file ${_r_deps}) 
file(INSTALL DESTINATION
"${CMAKE_INSTALL_PREFIX}/MantidPrototype.app/Contents/Frameworks" TYPE
SHARED_LIBRARY FOLLOW_SYMLINK_CHAIN FILES "${_file}" ) 
endforeach()
list(LENGTH _u_deps _u_length) 
if("${_u_length}" GREATER 0) 
message(WARNING
"Unresolved dependencies detected!")
 endif() 
]] COMPONENT Runtime)
elseif(WIN32)
install( CODE 
[[ file(GET_RUNTIME_DEPENDENCIES EXECUTABLES $<TARGET_FILE:MantidPrototype>
RESOLVED_DEPENDENCIES_VAR _r_deps UNRESOLVED_DEPENDENCIES_VAR _u_deps
DIRECTORIES ${MY_DEPENDENCY_PATHS} ) 
foreach(_file ${_r_deps}) 
file(INSTALL DESTINATION
"${CMAKE_INSTALL_PREFIX}/MantidPrototype.app/Contents/Frameworks" TYPE
SHARED_LIBRARY FOLLOW_SYMLINK_CHAIN FILES "${_file}" ) 
endforeach()
list(LENGTH _u_deps _u_length) 
if("${_u_length}" GREATER 0) 
message(WARNING
"Unresolved dependencies detected!")
 endif() 
]] COMPONENT Runtime)


endif() 
# - and extra qt stuff, we should fix this manually

set(prefix "MantidPrototype.app/Contents")
set(INSTALL_RUNTIME_DIR "${prefix}/MacOS")
set(INSTALL_CMAKE_DIR "${prefix}/Resources")

set(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
include(InstallRequiredSystemLibraries)

macro(install_qt5_plugin_A _qt_plugin_name _qt_plugins_var _prefix)
  get_target_property(_qt_plugin_path "${_qt_plugin_name}" LOCATION)
  if(EXISTS "${_qt_plugin_path}")
    get_filename_component(_qt_plugin_file "${_qt_plugin_path}" NAME)
    get_filename_component(_qt_plugin_type "${_qt_plugin_path}" PATH)
    get_filename_component(_qt_plugin_type "${_qt_plugin_type}" NAME)
    set(_qt_plugin_dest "${_prefix}/PlugIns/${_qt_plugin_type}")
    install(FILES "${_qt_plugin_path}" DESTINATION "${_qt_plugin_dest}" COMPONENT Runtime)
    set(${_qt_plugins_var}
        "${${_qt_plugins_var}};\$ENV{DEST_DIR}\${CMAKE_INSTALL_PREFIX}/${_qt_plugin_dest}/${_qt_plugin_file}"
    )
  else()
    message(FATAL_ERROR "QT plugin ${_qt_plugin_name} not found")
  endif()
endmacro()

if (APPLE)
install_qt5_plugin_a("Qt5::QCocoaIntegrationPlugin" QT_PLUGINS ${prefix})
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/qt.conf"
     "[Paths]\nPlugins = ${_qt_plugin_dir}\n")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/qt.conf"
        DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT Runtime)
endif()
# Destination paths below are relative to ${CMAKE_INSTALL_PREFIX}
install(
  TARGETS MantidPrototype
  BUNDLE DESTINATION . COMPONENT Runtime
  RUNTIME DESTINATION ${INSTALL_RUNTIME_DIR} COMPONENT Runtime)

# Note Mac specific extension .app
set(APPS "\${CMAKE_INSTALL_PREFIX}/MantidPrototype.app")

# Directories to look for dependencies
set(DIRS "${CMAKE_BINARY_DIR}")

# Path used for searching by FIND_XXX(), with appropriate suffixes added
if(CMAKE_PREFIX_PATH)
  foreach(dir ${CMAKE_PREFIX_PATH})
    list(APPEND DIRS "${dir}/bin" "${dir}/lib")
  endforeach()
endif()

# Append Qt's lib folder which is two levels above Qt5Widgets_DIR
list(APPEND DIRS "${Qt5Widgets_DIR}/../..")

set(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
include(InstallRequiredSystemLibraries)

message(STATUS "APPS: ${APPS}")
message(STATUS "QT_PLUGINS: ${QT_PLUGINS}")
message(STATUS "DIRS: ${DIRS}")

# function(gp_resolved_file_type_override resolved_file type_var)
#   message(\"resolving \${resolved_file} as \${type_var}\")
#   if(resolved_file MATCHES \"mantid_python\" OR resolved_file MATCHES \"^(/usr/lib)\" )
#     message(\"resolving \${resolved_file} as system\")
#     set(${type_var}
#         system
#         PARENT_SCOPE)
#   endif()
# endfunction()

# install(CODE "
# include(BundleUtilities)
# set(BU_CHMOD_BUNDLE_ITEMS ON)
# fixup_bundle(\"${APPS}\" \"${QT_PLUGINS}\" \"${DIRS}\")
# ")
