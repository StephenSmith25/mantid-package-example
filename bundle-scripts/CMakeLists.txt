set(PATH_TO_SCRIPT ${PROJECT_SOURCE_DIR}/bundle-scripts)
install(CODE "set(INSTALL_PREFIX \"${CMAKE_INSTALL_PREFIX}\")")
install(CODE "set(PATH_TO_SCRIPT \"${PATH_TO_SCRIPT}\")")

install(
  CODE "
execute_process(COMMAND \${PATH_TO_SCRIPT}/osx_install.sh \${INSTALL_PREFIX}
  WORKING_DIRECTORY \${PATH_TO_CONSTRUCT}
  COMMAND_ECHO STDOUT)
"
)
