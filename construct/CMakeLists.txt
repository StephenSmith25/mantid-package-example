set(PATH_TO_CONSTRUCT ${PROJECT_SOURCE_DIR}/construct)
if (WIN32)
set(OUTPUT_ENV "${PATH_TO_CONSTRUCT}/MantidPython-0.1.0-Windows-x86_64.exe")
else()
set(OUTPUT_ENV "${PATH_TO_CONSTRUCT}/MantidPython-0.1.0-MacOSX-x86_64.sh")
endif()

add_custom_command(OUTPUT ${OUTPUT_ENV}
    COMMAND constructor ${PATH_TO_CONSTRUCT} --output-dir=${PATH_TO_CONSTRUCT}
    COMMENT "Creating conda construct python package"
)

add_custom_target(ConstructorEnv ALL
    DEPENDS ${OUTPUT_ENV}
)

# execute_process(
#   COMMAND constructor ${PATH_TO_CONSTRUCT}
#           --output-dir=${PATH_TO_CONSTRUCT}
#   WORKING_DIRECTORY ${PATH_TO_CONSTRUCT}
#   RESULT_VARIABLE construct_result
#   OUTPUT_VARIABLE construct_output COMMAND_ECHO STDOUT)
# message(
#   "Finished creating conda construct env: ${construct_result} ${construct_output} "
#)

# install(DIRECTORY ${PATH_TO_CONSTRUCT}/env_installer DESTINATION
# MantidPrototype.app/Contents/Resources FILES_MATCHING
# PATTERN "*.sh" PATTERN "tmp" EXCLUDE)

install(FILES ${OUTPUT_ENV}
        DESTINATION resources/env_installer COMPONENT Runtime)
