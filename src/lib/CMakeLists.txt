
add_library(MathFunctions SHARED src/math_functions.cpp
                                 inc/MantidPrototype/math_functions.h)


include(GenerateExportHeader)
generate_export_header(MathFunctions)

target_include_directories(
  MathFunctions PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc>
                       $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
                       $<INSTALL_INTERFACE:include/MantidPrototype>)

target_link_libraries(MathFunctions PUBLIC Boost::boost)

install(
  TARGETS MathFunctions
  COMPONENT RUNTIME
  DESTINATION ${MantidPrototype_BIN_DIR}
  COMPONENT LIBRARY
  DESTINATION ${MantidPrototype_LIB_DIR})
