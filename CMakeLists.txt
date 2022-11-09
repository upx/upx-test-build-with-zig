cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# compilation config options
option(PKG_CONFIG_DISABLE_SANITIZE "Do not compile with sanitize options." ON)
option(PKG_CONFIG_DISABLE_WERROR   "Do not compile with -Werror option."   ON)

#***********************************************************************
# init
#***********************************************************************

set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(CMAKE_DISABLE_SOURCE_CHANGES  ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
if(",${CMAKE_SOURCE_DIR}," STREQUAL ",${CMAKE_BINARY_DIR},")
    message(FATAL_ERROR "ERROR: In-source builds are not allowed, please use an extra build dir.")
endif()
set(CMAKE_C_STANDARD_REQUIRED   ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(simple VERSION 1.2.3 LANGUAGES C CXX)

# set default build type to "Release"
get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(is_multi_config)
    set(c "${CMAKE_CONFIGURATION_TYPES}")
    list(INSERT c 0 "Release")
    list(INSERT c 1 "Debug")
    if (CMAKE_BUILD_TYPE)
        list(INSERT c 0 "${CMAKE_BUILD_TYPE}")
    endif()
    list(REMOVE_DUPLICATES c)
    set(CMAKE_CONFIGURATION_TYPES "${c}" CACHE STRING "List of supported configuration types." FORCE)
elseif(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build." FORCE)
endif()

#***********************************************************************
# targets and compilation flags
#***********************************************************************

add_executable(simple_c src/simple_c.c)
add_executable(simple_x src/simple_x.cpp)

if(PKG_CONFIG_DISABLE_WERROR)
    set(warn_Werror "")
    set(warn_WX "")
else()
    set(warn_Werror -Werror)
    set(warn_WX -WX)
endif()

if(NOT MSVC)
    # use -O2 instead of -O3 to reduce code size
    string(REGEX REPLACE "(^| )-O3( |$$)" "\\1-O2\\2" a "${CMAKE_C_FLAGS_RELEASE}")
    string(REGEX REPLACE "(^| )-O3( |$$)" "\\1-O2\\2" b "${CMAKE_CXX_FLAGS_RELEASE}")
    set(CMAKE_C_FLAGS_RELEASE "${a}" CACHE STRING "Flags used by the C compiler during RELEASE builds." FORCE)
    set(CMAKE_CXX_FLAGS_RELEASE "${b}" CACHE STRING "Flags used by the CXX compiler during RELEASE builds." FORCE)
endif()

if(MSVC)
    # disable silly warnings about using "deprecated" POSIX functions like fopen()
    add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)
    add_definitions(-D_CRT_NONSTDC_NO_WARNINGS)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
else()
    # protect against security threats caused by misguided compiler "optimizations"
    if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
        add_definitions(-fno-delete-null-pointer-checks)
    endif()
    add_definitions(-fstrict-aliasing -fno-strict-overflow -funsigned-char)
endif()

function(pkg_sanitize_target t)
    if(NOT PKG_CONFIG_DISABLE_SANITIZE AND NOT MSVC)
        # default sanitizer for Debug builds
        target_compile_options(${t} PRIVATE $<$<CONFIG:Debug>:-fsanitize=undefined -fsanitize-undefined-trap-on-error -fstack-protector-all>)
        # default sanitizer for Release builds
        target_compile_options(${t} PRIVATE $<$<CONFIG:Release>:-fstack-protector>)
    endif()
endfunction()

set(t simple_c)
target_compile_definitions(${t} PRIVATE $<$<CONFIG:Debug>:DEBUG=1>)
pkg_sanitize_target(${t})
if(MSVC)
    target_compile_options(${t} PRIVATE -J -W4 ${warn_WX})
else()
    target_compile_options(${t} PRIVATE
        -Wall -Wextra -Wcast-align -Wcast-qual -Wno-missing-declarations -Wpointer-arith
        -Wshadow -Wvla -Wwrite-strings ${warn_Werror}
    )
endif()

set(t simple_x)
target_compile_definitions(${t} PRIVATE $<$<CONFIG:Debug>:DEBUG=1>)
pkg_sanitize_target(${t})
if(MSVC)
    target_compile_options(${t} PRIVATE -EHsc -J -W4 ${warn_WX})
else()
    target_compile_options(${t} PRIVATE
        -Wall -Wextra -Wcast-align -Wcast-qual -Wno-missing-declarations -Wpointer-arith
        -Wshadow -Wvla -Wwrite-strings ${warn_Werror}
    )
endif()

#***********************************************************************
# "make test"
#***********************************************************************

include(CTest)
if(NOT CMAKE_CROSSCOMPILING)
    add_test(NAME simple_c COMMAND simple_c)
    add_test(NAME simple_x COMMAND simple_x)
endif()

#***********************************************************************
# finally print some info about the build configuration
#***********************************************************************

function(print_var v)
    if(${v})
        message(STATUS "${v} = ${${v}}")
    endif()
endfunction()
print_var(CMAKE_BUILD_TYPE)
print_var(CMAKE_CONFIGURATION_TYPES)
print_var(CMAKE_INSTALL_PREFIX)
print_var(CMAKE_CROSSCOMPILING)
print_var(CMAKE_C_COMPILER_ID)
print_var(CMAKE_C_COMPILER_VERSION)
print_var(CMAKE_C_COMPILER_ARCHITECTURE_ID)
print_var(CMAKE_C_PLATFORM_ID)
print_var(CMAKE_C_COMPILER_ABI)
print_var(CMAKE_CXX_COMPILER_ID)
print_var(CMAKE_CXX_COMPILER_VERSION)
print_var(CMAKE_CXX_COMPILER_ARCHITECTURE_ID)
print_var(CMAKE_CXX_PLATFORM_ID)
print_var(CMAKE_CXX_COMPILER_ABI)
if (CMAKE_BUILD_TYPE AND NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|Release)$")
    message(WARNING "WARNING: unsupported CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}; please use \"Debug\" or \"Release\"")
endif()

# vim:set ft=cmake ts=4 sw=4 tw=0 et:
