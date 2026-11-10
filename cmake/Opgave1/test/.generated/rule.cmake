# The following functions contains all the flags passed to the different build stages.

set(PACK_REPO_PATH "/home/jakob-hjort/.mchp_packs" CACHE PATH "Path to the root of a pack repository.")

function(Opgave1_test_test_toolchain_assemble_rule target)
    set(options
        "-x"
        "assembler-with-cpp"
        "${MP_EXTRA_AS_PRE}"
        "-mmcu=atmega328pb"
        "-B${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/gcc/dev/atmega328pb"
        "-c"
        "-Wa,--defsym=__MPLAB_BUILD=1${MP_EXTRA_AS_POST}")
    list(REMOVE_ITEM options "")
    target_compile_options(${target} PRIVATE "${options}")
    target_compile_definitions(${target}
        PRIVATE "__ATmega328PB__"
        PRIVATE "test=test")
    target_include_directories(${target} PRIVATE "${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/include")
endfunction()
function(Opgave1_test_test_toolchain_assembleWithPreprocess_rule target)
    set(options
        "-x"
        "assembler-with-cpp"
        "${MP_EXTRA_AS_PRE}"
        "-mmcu=atmega328pb"
        "-B${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/gcc/dev/atmega328pb"
        "-c"
        "-Wa,--defsym=__MPLAB_BUILD=1${MP_EXTRA_AS_POST}")
    list(REMOVE_ITEM options "")
    target_compile_options(${target} PRIVATE "${options}")
    target_compile_definitions(${target}
        PRIVATE "__ATmega328PB__"
        PRIVATE "test=test")
    target_include_directories(${target} PRIVATE "${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/include")
endfunction()
function(Opgave1_test_test_toolchain_compile_rule target)
    set(options
        "-g"
        "-gdwarf-2"
        "${MP_EXTRA_CC_PRE}"
        "-mmcu=atmega328pb"
        "-B${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/gcc/dev/atmega328pb"
        "-x"
        "c"
        "-c"
        "-funsigned-char"
        "-funsigned-bitfields"
        "-O1"
        "-ffunction-sections"
        "-fdata-sections"
        "-fpack-struct"
        "-fshort-enums"
        "-Wall")
    list(REMOVE_ITEM options "")
    target_compile_options(${target} PRIVATE "${options}")
    target_compile_definitions(${target}
        PRIVATE "__ATmega328PB__"
        PRIVATE "test=test")
    target_include_directories(${target} PRIVATE "${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/include")
endfunction()
function(Opgave1_test_test_toolchain_compile_cpp_rule target)
    set(options
        "-g"
        "-gdwarf-2"
        "${MP_EXTRA_CC_PRE}"
        "-mmcu=atmega328pb"
        "-B${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/gcc/dev/atmega328pb"
        "-x"
        "c++"
        "-c"
        "-funsigned-char"
        "-funsigned-bitfields"
        "-O1"
        "-ffunction-sections"
        "-fdata-sections"
        "-fpack-struct"
        "-fshort-enums"
        "-Wall")
    list(REMOVE_ITEM options "")
    target_compile_options(${target} PRIVATE "${options}")
    target_compile_definitions(${target}
        PRIVATE "__ATmega328PB__"
        PRIVATE "test=test")
    target_include_directories(${target} PRIVATE "${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/include")
endfunction()
function(Opgave1_test_link_rule target)
    set(options
        "-gdwarf-2"
        "${MP_EXTRA_LD_PRE}"
        "-mmcu=atmega328pb"
        "-B${PACK_REPO_PATH}/Microchip/ATmega_DFP/3.6.299/gcc/dev/atmega328pb"
        "-Wl,-Map=mem.map"
        "-Wl,--defsym=__MPLAB_BUILD=1${MP_EXTRA_LD_POST}"
        "-Wl,--gc-sections")
    list(REMOVE_ITEM options "")
    target_link_options(${target} PRIVATE "${options}")
    target_compile_definitions(${target}
        PRIVATE "__ATmega328PB__"
        PRIVATE "test=test")
endfunction()
function(Opgave1_test_objcopy_ihex_rule target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${OBJCOPY}
        ARGS --output-target=ihex ${Opgave1_test_image_name} ${Opgave1_test_image_base_name}.hex
        WORKING_DIRECTORY ${Opgave1_test_output_dir})
endfunction()
function(Opgave1_test_objcopy_eep_rule target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${OBJCOPY}
        ARGS --only-section=.eeprom --change-section-lma .eeprom=0 --no-change-warnings --output-target=ihex ${Opgave1_test_image_name} ${Opgave1_test_image_base_name}.eep
        WORKING_DIRECTORY ${Opgave1_test_output_dir})
endfunction()
function(Opgave1_test_objcopy_lss_rule target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${OBJDUMP}
        ARGS --disassemble --wide --demangle --line-numbers --section-headers --source ${Opgave1_test_image_name} > ${Opgave1_test_image_base_name}.lss
        WORKING_DIRECTORY ${Opgave1_test_output_dir})
endfunction()
function(Opgave1_test_objcopy_srec_rule target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${OBJCOPY}
        ARGS --output-target=srec --remove-section=.eeprom --remove-section=.fuse --remove-section=.lock --remove-section=.signature ${Opgave1_test_image_name} ${Opgave1_test_image_base_name}.srec
        WORKING_DIRECTORY ${Opgave1_test_output_dir})
endfunction()
function(Opgave1_test_objcopy_sig_rule target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${OBJCOPY}
        ARGS --only-section=.user_signatures --change-section-lma .user_signatures=0 --no-change-warnings --output-target=ihex ${Opgave1_test_image_name} ${Opgave1_test_image_base_name}.usersignatures
        WORKING_DIRECTORY ${Opgave1_test_output_dir})
endfunction()
function(Opgave1_test_objcopy_memusage_rule target)
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${OBJDUMP}
        ARGS -Pmem-usage ${Opgave1_test_image_name}
        WORKING_DIRECTORY ${Opgave1_test_output_dir})
endfunction()
