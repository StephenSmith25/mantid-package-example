set(SIP_SRC _message_box.sip)
set(SRC_FILES message_box.h)
set(MODULE_SPEC ${CMAKE_CURRENT_LIST_DIR}/${SIP_SRC})

list(APPEND _sip_include_flags "-I${PYQT5_SIP_DIR}")
set(_pyqt_sip_flags -n PyQt5.sip -t WS_X11 -t Qt_5_12_9)
set(_sip_generated_cpp ${CMAKE_CURRENT_BINARY_DIR}/sip_message_boxpart0.cpp)
set(_sip_include_deps ${PARSED_HEADER_DEPS})

# We also have to deal with the added complication that sip generates code that
# is not C++-17 compatible as it includes throw specifiers. We deal with this by
# replacing them in the generated code.
set(_sip_sanitizer ${CMAKE_CURRENT_LIST_DIR}/sip-sanitize-module.py)
add_custom_command(
  OUTPUT ${_sip_generated_cpp}
  COMMAND ${SIP_EXECUTABLE} ARGS ${_sip_include_flags} ${_pyqt_sip_flags} -c
          ${CMAKE_CURRENT_BINARY_DIR} -j1 -w -e ${MODULE_SPEC}
  COMMAND ${Python_EXECUTABLE} ${_sip_sanitizer} ARGS ${_sip_generated_cpp}
  DEPENDS ${MODULE_SPEC} ${_sip_include_deps}
  COMMENT "Generating message_box python bindings with sip")

add_library(PythonMessageBox MODULE ${_sip_generated_cpp} ${_sip_include_deps})

if(NOT APPLE)
  set(PYTHON_LINK_LIBS ${PYTHON_LINK_LIBS} Python::Python)
endif()

target_link_libraries(PythonMessageBox Qt5::Core Qt5::Gui Qt5::Widgets
                      MathFunctions ${PYTHON_LINK_LIBS})
target_include_directories(PythonMessageBox SYSTEM
                           PRIVATE ${CMAKE_CURRENT_LIST_DIR} ${SIP_INCLUDE_DIR})
# No library prefixes
set_target_properties(PythonMessageBox PROPERTIES PREFIX "")
# Library name needs to end in .pyd for Windows
if(MSVC)
  set_target_properties(
    PythonMessageBox PROPERTIES SUFFIX .pyd COMPILE_FLAGS
                                            "/bigobj /w44005 /w44244"
  )# bigobj required for intensive templating
elseif(APPLE)
  # and in .so on the Mac
  set_target_properties(PythonMessageBox PROPERTIES SUFFIX .so)
endif()

set_target_properties(PythonMessageBox PROPERTIES OUTPUT_NAME "_message_box")

if(APPLE)
  set_target_properties(PythonMessageBox PROPERTIES LINK_FLAGS
                                                    "-undefined dynamic_lookup")
endif()

install(
  TARGETS PythonMessageBox
  COMPONENT RUNTIME
  DESTINATION ${MWINDOW_SITE_PACKAGES}/m_window
  COMPONENT LIBRARY
  DESTINATION ${MWINDOW_SITE_PACKAGES}/m_window)
