cmake_minimum_required(VERSION 3.15)
project(small_vector VERSION 1.0.0)

# default project settings.
include(cmake/default_settings.cmake)

# conan integration.
include(cmake/conan.cmake)

# versioning functions.
include(cmake/versioning.cmake)

# helper functions.
include(cmake/functions.cmake)

# default installation directories for OSes.
include(GNUInstallDirs)

add_subdirectory(libs)
add_subdirectory(apps)

include(CTest)
add_subdirectory(tests)
add_subdirectory(benchmarks)

include(CPack)
