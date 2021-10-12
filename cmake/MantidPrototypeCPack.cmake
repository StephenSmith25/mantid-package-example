set(CPACK_PACKAGE_NAME "MantidPrototype")
set(CPACK_PACKAGE_FILE_NAME "MantidPrototype")
set(CPACK_PACKAGE_VENDOR "Stephen Smith")
if (APPLE)
set(CPACK_SET_DESTDIR true)
set(CPACK_INSTALL_PREFIX "/Applications")
set(CPACK_PACKAGING_INSTALL_PREFIX "/Applications")
set(CPACK_PACKAGE_DESCRIPTION "Test project for Mantid")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Test project for Mantid")
set(CPACK_PACKAGE_VERSION_MAJOR 0)
set(CPACK_PACKAGE_VERSION_MINOR 1)
set(CPACK_PACKAGE_VERSION_PATCH 0)
set(CPACK_POSTFLIGHT_RUNTIME_SCRIPT
    ${PROJECT_SOURCE_DIR}/bundle-scripts/postinstall)
set(CPACK_GENERATOR "productbuild")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Stephen Smith") # required


include(CPack)

cpack_add_component(
  Runtime
  DISPLAY_NAME Runtime
  DESCRIPTION "Runtime of window application" PLIST
                        ${PROJECT_SOURCE_DIR}/packaging/MantidPrototype.plist)

elseif(WIN32)

set(CPACK_GENERATOR "NSIS")
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "MantidPrototype")

set(CPACK_NSIS_INSTALLED_ICON_NAME "${APP_LOW_NAME}.ico")
set(CPACK_NSIS_HELP_LINK "www.google.co.uk")
set(CPACK_NSIS_URL_INFO_ABOUT "www.google.co.uk")
set(CPACK_NSIS_CONTACT "1@2")
include(CPack)

# Configure file with custom definitions for NSIS.
configure_file(
  ${PROJECT_SOURCE_DIR}/bundle-scripts/NSIS.definitions.nsh.in
  ${CMAKE_CURRENT_BINARY_DIR}/resources/nsis/NSIS.definitions.nsh
)

endif()
