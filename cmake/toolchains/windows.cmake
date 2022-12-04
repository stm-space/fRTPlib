#-------------------------------------------------------------------------------
# windows.cmake
# cmake settings file for Windows platform (supports 32- and 64-bit)
#-------------------------------------------------------------------------------

# detect 32-bit or 64-bit target platform   
if (CMAKE_CL_64)
    set(STM_PLATFORM WIN64)
    set(STM_PLATFORM_NAME "win64")
    set(STM_WIN64 1)
    set(STM_WINDOWS 1)
    set(STM_WINDOWS_PLATFORM_NAME "x64")
else()
    set(STM_PLATFORM WIN32)
    set(STM_PLATFORM_NAME "win32")
    set(STM_WIN32 1)
    set(STM_WINDOWS 1)
    set(STM_WINDOWS_PLATFORM_NAME "x86")
endif()
