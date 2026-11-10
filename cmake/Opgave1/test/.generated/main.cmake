include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(Opgave1_test_library_list )

set(OUTPUT_SUFFIX elf)
# Handle files with suffix s, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_assemble)
add_library(Opgave1_test_test_toolchain_assemble OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_assemble})
    Opgave1_test_test_toolchain_assemble_rule(Opgave1_test_test_toolchain_assemble)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_assemble>")

endif()

# Handle files with suffix S, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_assembleWithPreprocess)
add_library(Opgave1_test_test_toolchain_assembleWithPreprocess OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_assembleWithPreprocess})
    Opgave1_test_test_toolchain_assembleWithPreprocess_rule(Opgave1_test_test_toolchain_assembleWithPreprocess)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_assembleWithPreprocess>")

endif()

# Handle files with suffix [cC], for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_compile)
add_library(Opgave1_test_test_toolchain_compile OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_compile})
    Opgave1_test_test_toolchain_compile_rule(Opgave1_test_test_toolchain_compile)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_compile>")

endif()

# Handle files with suffix cpp, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_compile_cpp)
add_library(Opgave1_test_test_toolchain_compile_cpp OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_compile_cpp})
    Opgave1_test_test_toolchain_compile_cpp_rule(Opgave1_test_test_toolchain_compile_cpp)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_compile_cpp>")

endif()

# Handle files with suffix elf, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_objcopy_ihex)
add_library(Opgave1_test_test_toolchain_objcopy_ihex OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_objcopy_ihex})
    Opgave1_test_test_toolchain_objcopy_ihex_rule(Opgave1_test_test_toolchain_objcopy_ihex)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_objcopy_ihex>")

endif()

# Handle files with suffix elf, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_objcopy_eep)
add_library(Opgave1_test_test_toolchain_objcopy_eep OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_objcopy_eep})
    Opgave1_test_test_toolchain_objcopy_eep_rule(Opgave1_test_test_toolchain_objcopy_eep)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_objcopy_eep>")

endif()

# Handle files with suffix elf, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_objcopy_lss)
add_library(Opgave1_test_test_toolchain_objcopy_lss OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_objcopy_lss})
    Opgave1_test_test_toolchain_objcopy_lss_rule(Opgave1_test_test_toolchain_objcopy_lss)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_objcopy_lss>")

endif()

# Handle files with suffix elf, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_objcopy_srec)
add_library(Opgave1_test_test_toolchain_objcopy_srec OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_objcopy_srec})
    Opgave1_test_test_toolchain_objcopy_srec_rule(Opgave1_test_test_toolchain_objcopy_srec)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_objcopy_srec>")

endif()

# Handle files with suffix elf, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_objcopy_sig)
add_library(Opgave1_test_test_toolchain_objcopy_sig OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_objcopy_sig})
    Opgave1_test_test_toolchain_objcopy_sig_rule(Opgave1_test_test_toolchain_objcopy_sig)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_objcopy_sig>")

endif()

# Handle files with suffix elf, for group test_toolchain
if(Opgave1_test_test_toolchain_FILE_TYPE_objcopy_memusage)
add_library(Opgave1_test_test_toolchain_objcopy_memusage OBJECT ${Opgave1_test_test_toolchain_FILE_TYPE_objcopy_memusage})
    Opgave1_test_test_toolchain_objcopy_memusage_rule(Opgave1_test_test_toolchain_objcopy_memusage)
    list(APPEND Opgave1_test_library_list "$<TARGET_OBJECTS:Opgave1_test_test_toolchain_objcopy_memusage>")

endif()


# Main target for this project
add_executable(Opgave1_test_image_x9uElL4d ${Opgave1_test_library_list})

set_target_properties(Opgave1_test_image_x9uElL4d PROPERTIES
    OUTPUT_NAME "test"
    SUFFIX ".elf"
    ADDITIONAL_CLEAN_FILES "${output_extensions}"
    RUNTIME_OUTPUT_DIRECTORY "${Opgave1_test_output_dir}")
target_link_libraries(Opgave1_test_image_x9uElL4d PRIVATE ${Opgave1_test_test_toolchain_FILE_TYPE_link})
# Add the link options from the rule file.
Opgave1_test_link_rule( Opgave1_test_image_x9uElL4d)


#Add objcopy steps
Opgave1_test_objcopy_ihex_rule(Opgave1_test_image_x9uElL4d)
Opgave1_test_objcopy_eep_rule(Opgave1_test_image_x9uElL4d)
Opgave1_test_objcopy_lss_rule(Opgave1_test_image_x9uElL4d)
Opgave1_test_objcopy_srec_rule(Opgave1_test_image_x9uElL4d)
Opgave1_test_objcopy_sig_rule(Opgave1_test_image_x9uElL4d)
Opgave1_test_objcopy_memusage_rule(Opgave1_test_image_x9uElL4d)

