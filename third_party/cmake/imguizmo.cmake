set(IMGUIZMO_DIR ${imguizmo_SOURCE_DIR})

add_library(imguizmo STATIC
    ${IMGUIZMO_DIR}/ImGuizmo.cpp
    ${IMGUIZMO_DIR}/ImGuizmo.h
)

target_include_directories(imguizmo PUBLIC
    ${IMGUIZMO_DIR}
)

target_link_libraries(imguizmo PRIVATE
    imgui
)

set_target_properties(imguizmo PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party"
)