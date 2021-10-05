set(PATH_TO_CONSTRUCT ${PROJECT_SOURCE_DIR}/construct/)
install(CODE "set(PATH_TO_CONSTRUCT \"${PATH_TO_CONSTRUCT}\")")

install(
  CODE "
message(\" Creating conda construct package \")
execute_process(COMMAND constructor \${PATH_TO_CONSTRUCT} --output-dir=\${PATH_TO_CONSTRUCT}
  WORKING_DIRECTORY \${PATH_TO_CONSTRUCT}
  RESULT_VARIABLE construct_result
  OUTPUT_VARIABLE construct_output
  COMMAND_ECHO STDOUT)
message(\"Finished creating conda construct env: \${construct_result} \${construct_output} \")
 
"
)
