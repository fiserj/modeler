add_library(gleq INTERFACE)

target_include_directories(gleq INTERFACE
    ${gleq_SOURCE_DIR}
)

set_target_properties(gleq PROPERTIES
    FOLDER "Third Party"
)