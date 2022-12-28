add_library(par INTERFACE)

target_include_directories(par INTERFACE
    ${par_SOURCE_DIR}
)

set_target_properties(par PROPERTIES
    FOLDER "Third Party"
)