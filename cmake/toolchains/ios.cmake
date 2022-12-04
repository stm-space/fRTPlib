#-------------------------------------------------------------------------------
# ios.toolchain.cmake
# cmake toolchain file for cross-compiling to iOS from macOS.
#
#   NOTE that iOS support requires at least cmake 3.14!
# 
# available parameters:
# 
# STM_IOS_ACTIVE_ARCH - Only build active architecture, default ON
# STM_IOS_ONLY_ACTIVE_ARCH - Only build active architecture, default ON
# STM_IOS_USE_ARC - wheter to use ARC, default ON
# STM_EXCEPTIONS - whether to enable exceptions, default OFF
# STM_RTTI - whether to enable exceptions, default OFF
#-------------------------------------------------------------------------------

if(NOT STM_IOS_ACTIVE_ARCH)
    set(STM_IOS_ACTIVE_ARCH "arm64")
endif()

message(STATUS "STM_IOS_ACTIVE_ARCH ${STM_IOS_ACTIVE_ARCH}")

set(STM_PLATFORM IOS)
set(STM_PLATFORM_NAME "ios")
set(STM_IOS 1)
set(STM_APPLE 1)
set(STM_POSIX 1)

set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_OSX_ARCHITECTURES "${STM_IOS_ACTIVE_ARCH}")
#set(CMAKE_XCODE_ATTRIBUTE_ARCHS[sdk=iphoneos*] "${STM_IOS_ACTIVE_ARCH}")
set(CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos;-iphonesimulator")
#set(CMAKE_XCODE_ATTRIBUTE_VALID_ARCHS "arm64 armv7")

if(STM_IOS_ACTIVE_ARCH STREQUAL "arm64")
    set(CMAKE_XCODE_ATTRIBUTE_ARCHS[sdk=iphoneos*] "${STM_IOS_ACTIVE_ARCH}")
    set(CMAKE_OSX_SYSROOT "iphoneos")
elseif(STM_IOS_ACTIVE_ARCH STREQUAL "armv7")
    set(CMAKE_XCODE_ATTRIBUTE_ARCHS[sdk=iphoneos*] "${STM_IOS_ACTIVE_ARCH}")
    set(CMAKE_OSX_SYSROOT "iphoneos")
elseif(STM_IOS_ACTIVE_ARCH STREQUAL "x86_64")
    set(CMAKE_XCODE_ATTRIBUTE_ARCHS[sdk=iphonesimulator*] "${STM_IOS_ACTIVE_ARCH}")
    set(CMAKE_OSX_SYSROOT "iphonesimulator")
elseif(STM_IOS_ACTIVE_ARCH STREQUAL "i386")
    set(CMAKE_XCODE_ATTRIBUTE_ARCHS[sdk=iphonesimulator*] "${STM_IOS_ACTIVE_ARCH}")
    set(CMAKE_OSX_SYSROOT "iphonesimulator")
else()
     message(FATAL_ERROR "unknown STM_IOS_ACTIVE_ARCH ${STM_IOS_ACTIVE_ARCH}")
endif()

set(CMAKE_SYSTEM_PROCESSOR ${STM_IOS_ACTIVE_ARCH})

# ios deplayment target for third party libs, when build third_party libs ,open it.
set(CMAKE_OSX_DEPLOYMENT_TARGET "")
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "9.0")

message(STATUS "CMAKE_OSX_DEPLOYMENT_TARGET ${CMAKE_OSX_DEPLOYMENT_TARGET}")
message(STATUS "CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET}")

# enable bitcode
set(ENABLE_BITCODE TRUE)
set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "YES")
set(CMAKE_XCODE_ATTRIBUTE_OTHER_CFLAGS[variant=Debug] "-fembed-bitcode-marker")
set(CMAKE_XCODE_ATTRIBUTE_OTHER_CFLAGS[variant=Release] "-fembed-bitcode")
set(CMAKE_XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE[variant=Debug] "marker")
set(CMAKE_XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE[variant=Release] "bitcode")

# Fix for PThread library not in path
set(CMAKE_THREAD_LIBS_INIT "-lpthread")
set(CMAKE_HAVE_THREADS_LIBRARY 1)
set(CMAKE_USE_WIN32_THREADS_INIT 0)
set(CMAKE_USE_PTHREADS_INIT 1)