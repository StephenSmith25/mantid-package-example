include(PythonPackageTargetFunctions)

add_python_package(m_window INSTALL_LIB_DIRS ${_install_lib_dirs})

add_subdirectory(lib)
add_subdirectory(sip)
add_subdirectory(executable)