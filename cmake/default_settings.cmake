# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(
    STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE
      RelWithDebInfo
      CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui, ccmake
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
                                               "MinSizeRel" "RelWithDebInfo")
endif()

# default the standard to 17.
set(CMAKE_CXX_STANDARD
    17
    CACHE STRING "C++ standard")

# Generate compile_commands.json to make it easier to work with clang based
# tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(ENABLE_IPO
       "Enable Iterprocedural Optimization, aka Link Time Optimization (LTO)"
       OFF)

if(ENABLE_IPO)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT result OUTPUT output)
  if(result)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
  else()
    message(SEND_ERROR "IPO is not supported: ${output}")
  endif()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/runtime.cmake)
# sets of different warnings for compilers.
include(${CMAKE_CURRENT_LIST_DIR}/warnings.cmake)

function(brr_target_init target)
  set_target_warnings("${target}")
  set_runtime(TARGET "${target}")
  set_property(TARGET "${target}" PROPERTY POSITION_INDEPENDENT_CODE ON)
endfunction()
