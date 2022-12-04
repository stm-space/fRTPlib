#-------------------------------------------------------------------------------
# macos.cmake
# cmake settings file for macOS target platform.
#-------------------------------------------------------------------------------

set(STM_PLATFORM MACOS)
set(STM_PLATFORM_NAME "macos")
set(STM_MACOS 1)
set(STM_APPLE 1)
set(STM_POSIX 1)

set(CMAKE_OSX_DEPLOYMENT_TARGET "10.10" CACHE STRING "Minimum OS X deployment version" FORCE)
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "")

message(STATUS "CMAKE_OSX_DEPLOYMENT_TARGET ${CMAKE_OSX_DEPLOYMENT_TARGET}")
message(STATUS "CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET}")

