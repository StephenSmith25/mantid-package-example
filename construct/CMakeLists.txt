set(PATH_TO_CONSTRUCT ${PROJECT_SOURCE_DIR}/construct)

message(" Creating conda construct python package ")
execute_process(
  COMMAND constructor ${PATH_TO_CONSTRUCT}
          --output-dir=${PATH_TO_CONSTRUCT}/env_installer
  WORKING_DIRECTORY ${PATH_TO_CONSTRUCT}
  RESULT_VARIABLE construct_result
  OUTPUT_VARIABLE construct_output COMMAND_ECHO STDOUT)
message(
  "Finished creating conda construct env: ${construct_result} ${construct_output} "
)

file(GLOB CONDA_CONSTRUCT_ENV ${PATH_TO_CONSTRUCT}/env_installer/*.sh)

# install(DIRECTORY ${PATH_TO_CONSTRUCT}/env_installer DESTINATION
# MWindowApp.app/Contents/Resources FILES_MATCHING
# PATTERN "*.sh" PATTERN "tmp" EXCLUDE)

install(FILES ${CONDA_CONSTRUCT_ENV}
        DESTINATION MWindowApp.app/Contents/Resources/env_installer COMPONENT Runtime)
