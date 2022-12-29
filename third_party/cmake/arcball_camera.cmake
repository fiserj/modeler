add_library(arcball_camera INTERFACE)

target_include_directories(arcball_camera INTERFACE
    ${arcball_camera_SOURCE_DIR}
)

set_target_properties(arcball_camera PROPERTIES
    FOLDER "Third Party"
)