CMAKE_MINIMUM_REQUIRED(VERSION 3.4.1)

##################################### cmake util for set_if ########################
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(cmake_util)

##################################### project #####################################
project(stmrtp)
message("PROJECT_SOURCE_DIR is: " ${PROJECT_SOURCE_DIR})

##################################### platform #####################################
string(TOLOWER ${CMAKE_SYSTEM_NAME} SYSNAME_LC)
message("CMAKE_SYSTEM_NAME is: " ${SYSNAME_LC})

set_if(ANDROID          ${CMAKE_SYSTEM_NAME} MATCHES "Android")
set_if(IOS              ${CMAKE_SYSTEM_NAME} MATCHES "iOS")
set_if(MAC	            ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
set_if(LINUX            ${CMAKE_SYSTEM_NAME} MATCHES "Linux")
set_if(WINDOWS          WIN32 AND (NOT MINGW AND NOT CYGWIN))
set_if(PLATFORMSUPPORT  ANDROID OR IOS OR MAC OR LINUX OR WINDOWS)
if(NOT PLATFORMSUPPORT)
    message(FATAL_ERROR "platform Not support" ${CMAKE_SYSTEM_NAME})
endif()

if(MAC)
    set(PLATFORM mac)
else()
    set(PLATFORM ${SYSNAME_LC})
endif()

if(ANDROID)
    set(PLATFORM_ARCH ${ANDROID_ABI})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/libs/${ANDROID_ABI})
elseif(WINDOWS)
    add_compile_definitions(_XKEYCHECK_H)
    string(FIND ${CMAKE_MODULE_LINKER_FLAGS} "x64" ISx64Platform)
    message("ISx64Platform:" ${ISx64Platform})
    if(ISx64Platform GREATER 0)
        SET(PLATFORM windows/x64)
    else()
        SET(PLATFORM windows/x86)
    endif()
endif()

message("PLATFORM is: " ${PLATFORM})

##################################### build setting #####################################
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

if(${CMAKE_BUILD_TYPE} MATCHES "Debug")
    add_definitions(
        -D_DEBUG
    )
elseif(${CMAKE_BUILD_TYPE} MATCHES "Release")
    add_definitions(
        -DNDEBUG
    )
endif ()

##################################### platform #####################################
if((NOT ANDROID) AND (NOT WINDOWS))
    find_package(Threads REQUIRED)
    if(THREADS_HAVE_PTHREAD_ARG)
        target_compile_options(${PROJECT_NAME} PUBLIC "-pthread")
    endif()
endif()

##################################### definitions #####################################
if(WINDOWS)
    if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
        string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    else()
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
    endif()

    SET(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG} "/MDd /Zi /Ob0 /Od")
    SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MD /Zi /Ob0 /Od")

    SET (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /DEBUG /SAFESEH:NO")
    SET (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /SAFESEH:NO")
    SET (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /SAFESEH:NO")
elseif(MAC)

elseif(IOS)

elseif(LINUX)
    SET(CMAKE_C_FLAGS "-fPIC")
    SET(CMAKE_CXX_FLAGS "-fPIC")
elseif(ANDROID)
    SET(BUILD_WARN_OPTIONS "-std=c++11 -Wall -Wextra -Wformat \
            -Wno-format-security \
            -Wnull-dereference \
            -Wno-unused-variable \
            -Wno-unused-parameter \
            -Wno-unused-function \
            -Wno-unused-private-field \
            -Wno-shift-negative-value \
            -Wno-deprecated-register \
            -Wno-deprecated-declarations \
            -Wno-sign-compare ")

    if(${CMAKE_BUILD_TYPE} MATCHES "Release")
        SET(CMAKE_CXX_FLAGS "-DANDROID -fdata-sections -ffunction-sections -funwind-tables \
                             -fstack-protector-strong -no-canonical-prefixes -D_FORTIFY_SOURCE=2 \
                             -Wformat -Werror=format-security")
    endif()

    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${CXXFLAGS} ${BUILD_WARN_OPTIONS} -O0 -g -ggdb")
    SET(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} ${BUILD_WARN_OPTIONS} -Os")
endif()

##################################### header file #####################################
include_directories(src)

##################################### source code #####################################
set(SRC
        src/frtp.h          
        src/frtp.cpp  
        src/frtp_internal.h 
        src/frtp_hevc.h        
        src/frtp_hevc.cpp   
        src/frtp_opus.h
        src/frtp_opus.cpp
)

############################### config #################################
add_library(stmrtp 
    STATIC
    ${SRC}
)

if(MAC OR IOS)
    set_target_properties(stmrtp PROPERTIES
        XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH "NO"
        XCODE_ATTRIBUTE_ALWAYS_SEARCH_USER_PATHS "NO"
        XCODE_ATTRIBUTE_USE_HEADERMAP "YES"
        XCODE_ATTRIBUTE_CLANG_ENABLE_MODULES "YES"
        XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC "YES"
        XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_WEAK "YES"
        XCODE_ATTRIBUTE_CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING "YES"
        XCODE_ATTRIBUTE_CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF "YES"
        XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
    )
endif()

if(IOS)
    set_target_properties(stmrtp PROPERTIES
        XCODE_ATTRIBUTE_ENABLE_BITCODE "YES"
        XCODE_ATTRIBUTE_OTHER_CFLAGS[variant=Debug] "-fembed-bitcode-marker"
        XCODE_ATTRIBUTE_OTHER_CFLAGS[variant=Release] "-fembed-bitcode"
        XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE[variant=Debug] "marker"
        XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE[variant=Release] "bitcode"
    )

    if(ENABLE_DEMO)
        message(WARNING "In order to debug source code, demo do not prelink xxx.a")
    else()
        if(${STM_IOS_ACTIVE_ARCH} MATCHES "arm64" OR ${STM_IOS_ACTIVE_ARCH} MATCHES "armv7")
            set(ARCH_TYPE "iphoneos")
        elseif(${STM_IOS_ACTIVE_ARCH} MATCHES "x86_64" OR ${STM_IOS_ACTIVE_ARCH} MATCHES "i386")
            set(ARCH_TYPE "iphonesimulator")
        endif()
        
        set(BUILD_TYPE "Debug")
        if(${CMAKE_BUILD_TYPE} MATCHES "Debug")
            set(BUILD_TYPE "Debug")
        elseif(${CMAKE_BUILD_TYPE} MATCHES "Release")
            set(BUILD_TYPE "Release")
        endif()
        message("BUILD_TYPE: ${BUILD_TYPE}")

        # set(PRELINK_LIBS "xxx/yyy/zzz.a")

        set_target_properties(stmrtp PROPERTIES
            XCODE_ATTRIBUTE_GENERATE_MASTER_OBJECT_FILE "YES"
            # XCODE_ATTRIBUTE_PRELINK_LIBS ${PRELINK_LIBS}
            XCODE_ATTRIBUTE_PRELINK_FLAGS "-ObjC"
        )
    endif()
endif()

