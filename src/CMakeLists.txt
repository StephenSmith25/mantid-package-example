include(PythonPackageTargetFunctions)

add_python_package(m_window INSTALL_LIB_DIRS ${MWINDOW_LIB_DIR})

add_subdirectory(lib)
add_subdirectory(python_lib)
add_subdirectory(sip)
add_subdirectory(qt_executable)
