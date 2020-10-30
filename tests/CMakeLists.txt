find_package(doctest REQUIRED)

brr_add_executable(unit_tests)
target_link_libraries(unit_tests PRIVATE doctest::doctest)

add_test(
  NAME unit-tests
  COMMAND unit_tests
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
