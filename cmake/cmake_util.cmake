include(CheckCXXSourceCompiles)

# Useful for combinging paths

function(adddirname prefix lst out_lst)
	set(output)
	foreach(item ${lst})
		list(APPEND output "${prefix}/${item}")
	endforeach()
	set(${out_lst} ${${out_lst}} ${output} PARENT_SCOPE)
endfunction()

# Splits a version formed as "major.minor.patch" recorded in variable 'prefix'
# and writes it into variables started with 'prefix' and ended with _MAJOR, _MINOR and _PATCH.
MACRO(set_version_variables prefix value)
	string(REPLACE "." ";" VERSION_LIST ${value})
	list(GET VERSION_LIST 0 ${prefix}_MAJOR)
	list(GET VERSION_LIST 1 ${prefix}_MINOR)
	list(GET VERSION_LIST 2 ${prefix}_PATCH)
	set(${prefix}_DEFINESTR "")
ENDMACRO(set_version_variables)

# Sets given variable to 1, if the condition that follows it is satisfied.
# Otherwise set it to 0.
MACRO(set_if varname)
	IF(${ARGN})
		SET(${varname} 1)
	ELSE(${ARGN})
		SET(${varname} 0)
	ENDIF(${ARGN})
ENDMACRO(set_if)

FUNCTION(join_arguments outvar)
	set (output)

	foreach (i ${ARGN})
		set(output "${output} ${i}")
	endforeach()

	set (${outvar} ${output} PARENT_SCOPE)
ENDFUNCTION()


# NOTE: This is historical only. Not in use.
# It should be a similar interface to mafread.tcl like
# the above MafRead macro.
MACRO(GetMafHeaders directory outvar)
	EXECUTE_PROCESS(
		COMMAND ${CMAKE_MODULE_PATH}/mafread.tcl
			${CMAKE_SOURCE_DIR}/${directory}/HEADERS.maf
			"PUBLIC HEADERS"
			"PROTECTED HEADERS"
		OUTPUT_STRIP_TRAILING_WHITESPACE
		OUTPUT_VARIABLE ${outvar}
	)
	SEPARATE_ARGUMENTS(${outvar})
	adddirname(${CMAKE_SOURCE_DIR}/${directory} "${${outvar}}" ${outvar})
ENDMACRO(GetMafHeaders)

function (getVarsWith _prefix _varResult)
	get_cmake_property(_vars VARIABLES)
	string (REGEX MATCHALL "(^|;)${_prefix}[A-Za-z0-9_]*" _matchedVars "${_vars}")
	set (${_varResult} ${_matchedVars} PARENT_SCOPE)
endfunction()

function (check_testcode_compiles testcode libraries _successful)
	set (save_required_libraries ${CMAKE_REQUIRED_LIBRARIES})
	set (CMAKE_REQUIRED_LIBRARIES "${CMAKE_REQUIRED_LIBRARIES} ${libraries}")

	check_cxx_source_compiles("${testcode}" ${_successful})
	set (${_successful} ${${_successful}} PARENT_SCOPE)
	set (CMAKE_REQUIRED_LIBRARIES ${save_required_libraries})
endfunction()


function (parse_compiler_type wct _type _suffix)
	if (wct STREQUAL "")
		set(${_type} "" PARENT_SCOPE)
		set(${_suffix} "" PARENT_SCOPE)
	else()
		string(REPLACE "-" ";" OUTLIST ${wct})
		list(LENGTH OUTLIST OUTLEN)
		list(GET OUTLIST 0 ITEM)
		set(${_type} ${ITEM} PARENT_SCOPE)
		if (OUTLEN LESS 2)
			set(_suffix "" PARENT_SCOPE)
		else()
			list(GET OUTLIST 1 ITEM)
			set(${_suffix} "-${ITEM}" PARENT_SCOPE)
		endif()
	endif()
endfunction()
