# Link with static runtime on windows by default.
if(WIN32)
  option(use_static_cpp_runtime "Link runtime statically" ON)
else()
  option(use_static_cpp_runtime "Link runtime statically" OFF)
endif()

function(windows_set_runtime target static)
  set_property(
    TARGET ${target}
    PROPERTY
      MSVC_RUNTIME_LIBRARY
      "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<NOT:$<BOOL:${static}>>:DLL>")
endfunction()

function(linux_set_runtime target static)
  if(static)
    target_link_options(${target} PRIVATE -static-libstdc++ -static-libgcc)
  endif()
endfunction()

function(set_runtime)
  set(options STATIC DYNAMIC)
  set(single_value TARGET)
  set(multi_value "")
  cmake_parse_arguments(set_runtime "${options}" "${single_value}"
                        "${multi_value}" ${ARGN})

  if(set_runtime_STATIC)
    set(static TRUE)
  elseif(set_runtime_DYNAMIC)
    set(static FALSE)
  else()
    set(static "${use_static_cpp_runtime}")
  endif()

  if(WIN32)
    windows_set_runtime("${set_runtime_TARGET}" "${static}")
  elseif(APPLE)
    message(VERBOSE "Using default Apple runtime.")
  else()
    linux_set_runtime("${set_runtime_TARGET}" "${static}")
  endif()
endfunction()
