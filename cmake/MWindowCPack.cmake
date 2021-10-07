set(CPACK_PACKAGE_NAME "MWindow")
set(CPACK_PACKAGE_FILE_NAME "MWindow")
set(CPACK_PACKAGE_VENDOR "Stephen Smith")
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
                        ${PROJECT_SOURCE_DIR}/packaging/mwindow.plist)
