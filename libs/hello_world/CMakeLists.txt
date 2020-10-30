find_package(fmt REQUIRED)

brr_add_library(hello_world_lib STATIC)
target_link_libraries(hello_world_lib PRIVATE fmt::fmt)
