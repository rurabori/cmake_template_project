# add_versioning(target [PREFIX prefix])
#
# adds version.h to the provided target. Configures it with current
# PROJECT_VERSION and the name of the target provided. If one wishes to prefix
# defines and variables in version.h with a different value than target name it
# is possible by calling add_versioning with the optional argument PREFIX and
# specify the desired value. On windows this also adds VERSIONINFO resource. On
# *nix platforms, this adds .versioninfo section which contains informations
# about the program such as version, name and from which commit hash it was
# built.

function(add_versioning target)
  # just making sure the inputs are correct.
  if(${ARGC} EQUAL 3)
    if("${ARGV1}" STREQUAL "PREFIX")
      set(prefix ${ARGV2})
    else()
      message(
        FATAL_ERROR
          "Unknown argument ${ARGV1}. Usage add_versioning(target [PREFIX prefix])."
        )
    endif()
  elseif(${ARGC} EQUAL 1)
    set(prefix ${target})
  else()
    message(
      FATAL_ERROR
        "Wrong number of arguments. Usage add_versioning(target [PREFIX prefix])."
      )
  endif()

  configure_file(${CMAKE_HOME_DIRECTORY}/resources/version.h.in version.h)
  target_include_directories(${target} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
  # get target type.
  get_target_property(target_type ${target} TYPE)

  # cmake-format: off
  # add proper versioning to shared libraries. This will create symlinks on linux.
  # see https://cmake.org/cmake/help/v3.16/prop_tgt/SOVERSION.html
  # such that :
  #   target.so -> target.so.1
  #   target.so.1 -> target.so.1.0.0
  #   target.so.1.0.0
  # cmake-format: on
  if(${target_type} STREQUAL "SHARED_LIBRARY")
    set_target_properties(${target}
                          PROPERTIES SOVERSION
                                     ${PROJECT_VERSION_MAJOR}
                                     VERSION
                                     ${PROJECT_VERSION})
  endif()

  # no point in embedding this info into static library. Also breaks on LINUX
  # static libraries and we do not have usecase for static libraries yet anyway.
  if(${target_type} STREQUAL "SHARED_LIBRARY"
     OR ${target_type} STREQUAL "EXECUTABLE")
    # on Windows, add VERSIONINFO type resource.
    if(WIN32)
      # figure out the filetype.
      if(${target_type} STREQUAL "EXECUTABLE")
        set(VERSIONINFO_FILETYPE "VFT_APP")
      else()
        set(VERSIONINFO_FILETYPE "VFT_DLL")
      endif()
      # fill the values into the .rc file.
      configure_file(${CMAKE_HOME_DIRECTORY}/resources/versioninfo.rc.in
                     "${target}_versioninfo.rc")
      # add the configured rc file to sources
      target_sources(${target} PRIVATE
                     "${CMAKE_CURRENT_BINARY_DIR}/${target}_versioninfo.rc")
    elseif(UNIX)
      # On Unix-like systems, configure a .cpp file with version information and
      # add this file into the build. The inclusion of this file will create a
      # .versioninfo section in the created target.
      configure_file(${CMAKE_HOME_DIRECTORY}/resources/versioninfo.cpp.in
                     "${target}_versioninfo.cpp")
      target_sources(${target} PRIVATE
                     "${CMAKE_CURRENT_BINARY_DIR}/${target}_versioninfo.cpp")
    endif()
  endif()
endfunction()
