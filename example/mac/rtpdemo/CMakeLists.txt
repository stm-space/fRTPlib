cmake_minimum_required(VERSION 3.4.1)

include_directories(./rtpdemo ../../../src/api/client)

set(CUSTOM_OUTPUT_NAME rtpdemo)

FILE(GLOB_RECURSE SOURCES "./rtpdemo/*.h" "./rtpdemo/*.pch" "./rtpdemo/*.cc" 
                        "./rtpdemo/*.m" "./rtpdemo/*.mm")

FILE(GLOB_RECURSE RESOURCES 
    "./rtpdemo/Base.lproj/*.storyboard"
    "./rtpdemo/*.storyboard"
    "./rtpdemo/*.xib" 
    "./rtpdemo/*.entitlements")

LIST(APPEND RESOURCES "./rtpdemo/Assets.xcassets")

set(EXAMPLE_SRC ${SOURCES} ${RESOURCES})

foreach(file ${SOURCES})
    file(RELATIVE_PATH relative_file "${CMAKE_CURRENT_LIST_DIR}/rtpdemo" ${file})
    get_filename_component(dir "${relative_file}" PATH)
    if (NOT "${dir}" STREQUAL "")
        string(REPLACE "/" "\\" dir ${dir})
        source_group("${dir}" FILES ${file})
    endif()
endforeach()

source_group(Resources FILES ${RESOURCES})

add_executable(rtpdemo MACOSX_BUNDLE ${EXAMPLE_SRC})

target_compile_options(rtpdemo PRIVATE -fobjc-arc "$<$<COMPILE_LANGUAGE:CXX>:-std=c++11>")

target_link_libraries(rtpdemo 
    stmrtp 
    "-framework Foundation"
    "-framework Cocoa"
    "-framework AppKit"
    "-framework AVFoundation"
    "-framework CoreVideo"
    "-framework CoreMedia"
    "-framework VideoToolbox"
    "-framework IOKit"
    "-framework SystemConfiguration"
    "-framework AudioUnit"
    "-framework CoreAudio"
)

set_target_properties(rtpdemo PROPERTIES
    # MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/rtpdemo/Info.plist
    RESOURCE "${RESOURCES}"
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "com.tms.rtpdemo"
    XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS "@executable_path/../Frameworks @loader_path/Frameworks"
    XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC "YES"
    XCODE_ATTRIBUTE_GCC_ENABLE_CPP_RTTI "NO"
    XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11"
    XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++"
    XCODE_ATTRIBUTE_GCC_PRECOMPILE_PREFIX_HEADER "YES"
    XCODE_ATTRIBUTE_GCC_PREFIX_HEADER ""
    XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS ""
    XCODE_ATTRIBUTE_LIBRARY_SEARCH_PATHS ""
    XCODE_ATTRIBUTE_OTHER_CODE_SIGN_FLAGS "--deep"
    OUTPUT_NAME ${CUSTOM_OUTPUT_NAME}
)
