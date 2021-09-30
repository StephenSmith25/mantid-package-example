
add_library(MathFunctions SHARED src/math_functions.cpp
                                 inc/MWindow/math_functions.h)

target_include_directories(
  MathFunctions PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/inc>
                       $<INSTALL_INTERFACE:include/MWindow>)

target_link_libraries(MathFunctions PUBLIC Boost::boost)

install(
  TARGETS MathFunctions
  COMPONENT RUNTIME
  DESTINATION ${MWINDOW_BIN_DIR}
  COMPONENT LIBRARY
  DESTINATION ${MWINDOW_LIB_DIR})
