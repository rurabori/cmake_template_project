find_package(benchmark REQUIRED)

brr_add_executable(bench)

target_link_libraries(bench PRIVATE benchmark::benchmark)
