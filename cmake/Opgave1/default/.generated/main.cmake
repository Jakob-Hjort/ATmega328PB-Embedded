include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(Opgave1_default_library_list )

set(OUTPUT_SUFFIX elf)
# Handle files with suffix s, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_assemble)
add_library(Opgave1_default_default_XC8_assemble OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_assemble})
    Opgave1_default_default_XC8_assemble_rule(Opgave1_default_default_XC8_assemble)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_assemble>")

endif()

# Handle files with suffix S, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_assembleWithPreprocess)
add_library(Opgave1_default_default_XC8_assembleWithPreprocess OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_assembleWithPreprocess})
    Opgave1_default_default_XC8_assembleWithPreprocess_rule(Opgave1_default_default_XC8_assembleWithPreprocess)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_assembleWithPreprocess>")

endif()

# Handle files with suffix [cC], for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_compile)
add_library(Opgave1_default_default_XC8_compile OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_compile})
    Opgave1_default_default_XC8_compile_rule(Opgave1_default_default_XC8_compile)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_compile>")

endif()

# Handle files with suffix cpp, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_compile_cpp)
add_library(Opgave1_default_default_XC8_compile_cpp OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_compile_cpp})
    Opgave1_default_default_XC8_compile_cpp_rule(Opgave1_default_default_XC8_compile_cpp)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_compile_cpp>")

endif()

# Handle files with suffix elf, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_objcopy_ihex)
add_library(Opgave1_default_default_XC8_objcopy_ihex OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_objcopy_ihex})
    Opgave1_default_default_XC8_objcopy_ihex_rule(Opgave1_default_default_XC8_objcopy_ihex)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_objcopy_ihex>")

endif()

# Handle files with suffix elf, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_objcopy_eep)
add_library(Opgave1_default_default_XC8_objcopy_eep OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_objcopy_eep})
    Opgave1_default_default_XC8_objcopy_eep_rule(Opgave1_default_default_XC8_objcopy_eep)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_objcopy_eep>")

endif()

# Handle files with suffix elf, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_objcopy_lss)
add_library(Opgave1_default_default_XC8_objcopy_lss OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_objcopy_lss})
    Opgave1_default_default_XC8_objcopy_lss_rule(Opgave1_default_default_XC8_objcopy_lss)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_objcopy_lss>")

endif()

# Handle files with suffix elf, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_objcopy_srec)
add_library(Opgave1_default_default_XC8_objcopy_srec OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_objcopy_srec})
    Opgave1_default_default_XC8_objcopy_srec_rule(Opgave1_default_default_XC8_objcopy_srec)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_objcopy_srec>")

endif()

# Handle files with suffix elf, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_objcopy_sig)
add_library(Opgave1_default_default_XC8_objcopy_sig OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_objcopy_sig})
    Opgave1_default_default_XC8_objcopy_sig_rule(Opgave1_default_default_XC8_objcopy_sig)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_objcopy_sig>")

endif()

# Handle files with suffix elf, for group default-XC8
if(Opgave1_default_default_XC8_FILE_TYPE_objcopy_memusage)
add_library(Opgave1_default_default_XC8_objcopy_memusage OBJECT ${Opgave1_default_default_XC8_FILE_TYPE_objcopy_memusage})
    Opgave1_default_default_XC8_objcopy_memusage_rule(Opgave1_default_default_XC8_objcopy_memusage)
    list(APPEND Opgave1_default_library_list "$<TARGET_OBJECTS:Opgave1_default_default_XC8_objcopy_memusage>")

endif()


# Main target for this project
add_executable(Opgave1_default_image_rv_WOLht ${Opgave1_default_library_list})

set_target_properties(Opgave1_default_image_rv_WOLht PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    ADDITIONAL_CLEAN_FILES "${output_extensions}"
    RUNTIME_OUTPUT_DIRECTORY "${Opgave1_default_output_dir}")
target_link_libraries(Opgave1_default_image_rv_WOLht PRIVATE ${Opgave1_default_default_XC8_FILE_TYPE_link})
# Add the link options from the rule file.
Opgave1_default_link_rule( Opgave1_default_image_rv_WOLht)


#Add objcopy steps
Opgave1_default_objcopy_ihex_rule(Opgave1_default_image_rv_WOLht)
Opgave1_default_objcopy_eep_rule(Opgave1_default_image_rv_WOLht)
Opgave1_default_objcopy_lss_rule(Opgave1_default_image_rv_WOLht)
Opgave1_default_objcopy_srec_rule(Opgave1_default_image_rv_WOLht)
Opgave1_default_objcopy_sig_rule(Opgave1_default_image_rv_WOLht)
Opgave1_default_objcopy_memusage_rule(Opgave1_default_image_rv_WOLht)

