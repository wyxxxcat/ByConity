if (APPLE OR SPLIT_SHARED_LIBRARIES OR NOT ARCH_AMD64)
    set (ENABLE_EMBEDDED_COMPILER OFF CACHE INTERNAL "")
endif()

option (ENABLE_EMBEDDED_COMPILER "Set to TRUE to enable support for 'compile_expressions' option for query execution" ${ENABLE_LIBRARIES})
# Broken in macos. TODO: update clang, re-test, enable on Apple
if (ENABLE_EMBEDDED_COMPILER AND NOT SPLIT_SHARED_LIBRARIES AND ARCH_AMD64 AND NOT (SANITIZE STREQUAL "undefined"))
    option (USE_INTERNAL_LLVM_LIBRARY "Use bundled or system LLVM library." ${NOT_UNBUNDLED})
endif()

if (NOT ENABLE_EMBEDDED_COMPILER)
    if(USE_INTERNAL_LLVM_LIBRARY)
        message (${RECONFIGURE_MESSAGE_LEVEL} "Cannot use internal LLVM library with ENABLE_EMBEDDED_COMPILER=OFF")
    endif()
    return()
endif()

if (NOT EXISTS "${ClickHouse_SOURCE_DIR}/contrib/llvm/llvm/CMakeLists.txt")
    if (USE_INTERNAL_LLVM_LIBRARY)
        message (WARNING "submodule contrib/llvm is missing. to fix try run: \n git submodule update --init --recursive")
        message (${RECONFIGURE_MESSAGE_LEVEL} "Can't fidd internal LLVM library")
    endif()
    set (MISSING_INTERNAL_LLVM_LIBRARY 1)
endif ()

if (NOT USE_INTERNAL_LLVM_LIBRARY)
    set (LLVM_PATHS "/usr/local/lib/llvm")

    if (NOT LLVM_FOUND)
        find_package (LLVM 11.1 11 CONFIG PATHS ${LLVM_PATHS})
    endif ()

    if (LLVM_FOUND)
        # Remove dynamically-linked zlib and libedit from LLVM's dependencies:
        set_target_properties(LLVMSupport PROPERTIES INTERFACE_LINK_LIBRARIES "-lpthread;LLVMDemangle;${ZLIB_LIBRARIES}")
        set_target_properties(LLVMLineEditor PROPERTIES INTERFACE_LINK_LIBRARIES "LLVMSupport")

        option(LLVM_HAS_RTTI "Enable if LLVM was build with RTTI enabled" ON)
        set (USE_EMBEDDED_COMPILER 1)
    else()
        message (${RECONFIGURE_MESSAGE_LEVEL} "Can't find system LLVM")
        set (USE_EMBEDDED_COMPILER 0)
    endif()

    if (LLVM_FOUND AND OS_LINUX AND USE_LIBCXX AND NOT FORCE_LLVM_WITH_LIBCXX)
        message(WARNING "Option USE_INTERNAL_LLVM_LIBRARY is not set but the LLVM library from OS packages "
                "in Linux is incompatible with libc++ ABI. LLVM Will be disabled. Force: -DFORCE_LLVM_WITH_LIBCXX=ON")
        message (${RECONFIGURE_MESSAGE_LEVEL} "Unsupported LLVM configuration, cannot enable LLVM")
        set (LLVM_FOUND 0)
        set (USE_EMBEDDED_COMPILER 0)
    endif ()
endif()

if(NOT LLVM_FOUND AND NOT MISSING_INTERNAL_LLVM_LIBRARY)
    if (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_CURRENT_BINARY_DIR)
        message(WARNING "Option ENABLE_EMBEDDED_COMPILER is set but internal LLVM library cannot build if build directory is the same as source directory.")
        set (LLVM_FOUND 0)
        set (USE_EMBEDDED_COMPILER 0)
    elseif (SPLIT_SHARED_LIBRARIES)
        # llvm-tablegen cannot find shared libraries that we build. Probably can be easily fixed.
        message(WARNING "Option USE_INTERNAL_LLVM_LIBRARY is not compatible with SPLIT_SHARED_LIBRARIES. Build of LLVM will be disabled.")
        set (LLVM_FOUND 0)
        set (USE_EMBEDDED_COMPILER 0)
    elseif (NOT ARCH_AMD64)
        # It's not supported yet, but you can help.
        message(WARNING "Option USE_INTERNAL_LLVM_LIBRARY is only available for x86_64. Build of LLVM will be disabled.")
        set (LLVM_FOUND 0)
        set (USE_EMBEDDED_COMPILER 0)
    elseif (SANITIZE STREQUAL "undefined")
        # llvm-tblgen, that is used during LLVM build, doesn't work with UBSan.
        message(WARNING "Option USE_INTERNAL_LLVM_LIBRARY does not work with UBSan, because 'llvm-tblgen' tool from LLVM has undefined behaviour. Build of LLVM will be disabled.")
        set (LLVM_FOUND 0)
        set (USE_EMBEDDED_COMPILER 0)
    else ()
        set (USE_INTERNAL_LLVM_LIBRARY ON)
        set (LLVM_FOUND 1)
        set (USE_EMBEDDED_COMPILER 1)
        set (LLVM_VERSION "9.0.0bundled")
        set (LLVM_INCLUDE_DIRS
            "${ClickHouse_SOURCE_DIR}/contrib/llvm/llvm/include"
            "${ClickHouse_BINARY_DIR}/contrib/llvm/llvm/include"
        )
        set (LLVM_LIBRARY_DIRS "${ClickHouse_BINARY_DIR}/contrib/llvm/llvm")
    endif()
endif()

if (LLVM_FOUND)
    message(STATUS "LLVM include Directory: ${LLVM_INCLUDE_DIRS}")
    message(STATUS "LLVM library Directory: ${LLVM_LIBRARY_DIRS}")
    message(STATUS "LLVM C++ compiler flags: ${LLVM_CXXFLAGS}")
else()
    message (${RECONFIGURE_MESSAGE_LEVEL} "Can't enable LLVM")
endif()

# This list was generated by listing all LLVM libraries, compiling the binary and removing all libraries while it still compiles.
set (REQUIRED_LLVM_LIBRARIES
LLVMOrcJIT
LLVMExecutionEngine
LLVMRuntimeDyld
LLVMX86CodeGen
LLVMX86Desc
LLVMX86Info
LLVMX86Utils
LLVMAsmPrinter
LLVMDebugInfoDWARF
LLVMGlobalISel
LLVMSelectionDAG
LLVMMCDisassembler
LLVMPasses
LLVMCodeGen
LLVMipo
LLVMBitWriter
LLVMInstrumentation
LLVMScalarOpts
LLVMAggressiveInstCombine
LLVMInstCombine
LLVMVectorize
LLVMTransformUtils
LLVMTarget
LLVMAnalysis
LLVMProfileData
LLVMObject
LLVMBitReader
LLVMCore
LLVMRemarks
LLVMBitstreamReader
LLVMMCParser
LLVMMC
LLVMBinaryFormat
LLVMDebugInfoCodeView
LLVMSupport
LLVMDemangle
)

#function(llvm_libs_all REQUIRED_LLVM_LIBRARIES)
#    llvm_map_components_to_libnames (result all)
#    if (USE_STATIC_LIBRARIES OR NOT "LLVM" IN_LIST result)
#        list (REMOVE_ITEM result "LTO" "LLVM")
#    else()
#        set (result "LLVM")
#    endif ()
#    list (APPEND result ${CMAKE_DL_LIBS} ${ZLIB_LIBRARIES})
#    set (${REQUIRED_LLVM_LIBRARIES} ${result} PARENT_SCOPE)
#endfunction()
