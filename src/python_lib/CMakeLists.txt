
find_package(pybind11)
pybind11_add_module(python_lib src/main.cpp)

# EXAMPLE_VERSION_INFO is defined by setup.py and passed into the C++ code as a
# define (VERSION_INFO) here.
target_compile_definitions(python_lib PRIVATE VERSION_INFO="0.1.0")


install(
  TARGETS python_lib
  COMPONENT RUNTIME
  DESTINATION ${MWINDOW_BIN_DIR}
  COMPONENT LIBRARY
  DESTINATION ${MWINDOW_LIB_DIR})