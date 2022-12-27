set(GLSL_OPTIMIZER "${bgfx_SOURCE_DIR}/3rdparty/glsl-optimizer/")
set(FCPP_DIR "${bgfx_SOURCE_DIR}/3rdparty/fcpp/")
set(GLSLANG "${bgfx_SOURCE_DIR}/3rdparty/glslang/")
set(SPIRV_CROSS "${bgfx_SOURCE_DIR}/3rdparty/spirv-cross/")
set(SPIRV_HEADERS "${bgfx_SOURCE_DIR}/3rdparty/spirv-headers/")
set(SPIRV_TOOLS "${bgfx_SOURCE_DIR}/3rdparty/spirv-tools/")


# ------------------------------------------------------------------------------
# SPIRV-OPT
# ------------------------------------------------------------------------------

add_library(spirv_opt STATIC
    ${SPIRV_TOOLS}source/assembly_grammar.cpp
    ${SPIRV_TOOLS}source/binary.cpp
    ${SPIRV_TOOLS}source/diagnostic.cpp
    ${SPIRV_TOOLS}source/disassemble.cpp
    ${SPIRV_TOOLS}source/enum_string_mapping.cpp
    ${SPIRV_TOOLS}source/ext_inst.cpp
    ${SPIRV_TOOLS}source/extensions.cpp
    ${SPIRV_TOOLS}source/libspirv.cpp
    ${SPIRV_TOOLS}source/name_mapper.cpp
    ${SPIRV_TOOLS}source/opcode.cpp
    ${SPIRV_TOOLS}source/operand.cpp
    ${SPIRV_TOOLS}source/parsed_operand.cpp
    ${SPIRV_TOOLS}source/print.cpp
    ${SPIRV_TOOLS}source/software_version.cpp
    ${SPIRV_TOOLS}source/spirv_endian.cpp
    ${SPIRV_TOOLS}source/spirv_optimizer_options.cpp
    ${SPIRV_TOOLS}source/spirv_reducer_options.cpp
    ${SPIRV_TOOLS}source/spirv_target_env.cpp
    ${SPIRV_TOOLS}source/spirv_validator_options.cpp
    ${SPIRV_TOOLS}source/table.cpp
    ${SPIRV_TOOLS}source/text.cpp
    ${SPIRV_TOOLS}source/text_handler.cpp
    ${SPIRV_TOOLS}source/util/bit_vector.cpp
    ${SPIRV_TOOLS}source/util/parse_number.cpp
    ${SPIRV_TOOLS}source/util/string_utils.cpp
    ${SPIRV_TOOLS}source/val/basic_block.cpp
    ${SPIRV_TOOLS}source/val/construct.cpp
    ${SPIRV_TOOLS}source/val/function.cpp
    ${SPIRV_TOOLS}source/val/instruction.cpp
    ${SPIRV_TOOLS}source/val/validate.cpp
    ${SPIRV_TOOLS}source/val/validate_adjacency.cpp
    ${SPIRV_TOOLS}source/val/validate_annotation.cpp
    ${SPIRV_TOOLS}source/val/validate_arithmetics.cpp
    ${SPIRV_TOOLS}source/val/validate_atomics.cpp
    ${SPIRV_TOOLS}source/val/validate_barriers.cpp
    ${SPIRV_TOOLS}source/val/validate_bitwise.cpp
    ${SPIRV_TOOLS}source/val/validate_builtins.cpp
    ${SPIRV_TOOLS}source/val/validate_capability.cpp
    ${SPIRV_TOOLS}source/val/validate_cfg.cpp
    ${SPIRV_TOOLS}source/val/validate_composites.cpp
    ${SPIRV_TOOLS}source/val/validate_constants.cpp
    ${SPIRV_TOOLS}source/val/validate_conversion.cpp
    ${SPIRV_TOOLS}source/val/validate_debug.cpp
    ${SPIRV_TOOLS}source/val/validate_decorations.cpp
    ${SPIRV_TOOLS}source/val/validate_derivatives.cpp
    ${SPIRV_TOOLS}source/val/validate_execution_limitations.cpp
    ${SPIRV_TOOLS}source/val/validate_extensions.cpp
    ${SPIRV_TOOLS}source/val/validate_function.cpp
    ${SPIRV_TOOLS}source/val/validate_id.cpp
    ${SPIRV_TOOLS}source/val/validate_image.cpp
    ${SPIRV_TOOLS}source/val/validate_instruction.cpp
    ${SPIRV_TOOLS}source/val/validate_interfaces.cpp
    ${SPIRV_TOOLS}source/val/validate_layout.cpp
    ${SPIRV_TOOLS}source/val/validate_literals.cpp
    ${SPIRV_TOOLS}source/val/validate_logicals.cpp
    ${SPIRV_TOOLS}source/val/validate_memory.cpp
    ${SPIRV_TOOLS}source/val/validate_memory_semantics.cpp
    ${SPIRV_TOOLS}source/val/validate_misc.cpp
    ${SPIRV_TOOLS}source/val/validate_mode_setting.cpp
    ${SPIRV_TOOLS}source/val/validate_non_uniform.cpp
    ${SPIRV_TOOLS}source/val/validate_primitives.cpp
    ${SPIRV_TOOLS}source/val/validate_ray_query.cpp
    ${SPIRV_TOOLS}source/val/validate_scopes.cpp
    ${SPIRV_TOOLS}source/val/validate_small_type_uses.cpp
    ${SPIRV_TOOLS}source/val/validate_type.cpp
    ${SPIRV_TOOLS}source/val/validation_state.cpp

    ${SPIRV_TOOLS}source/opt/aggressive_dead_code_elim_pass.cpp
    ${SPIRV_TOOLS}source/opt/amd_ext_to_khr.cpp
    ${SPIRV_TOOLS}source/opt/basic_block.cpp
    ${SPIRV_TOOLS}source/opt/block_merge_pass.cpp
    ${SPIRV_TOOLS}source/opt/block_merge_util.cpp
    ${SPIRV_TOOLS}source/opt/build_module.cpp
    ${SPIRV_TOOLS}source/opt/ccp_pass.cpp
    ${SPIRV_TOOLS}source/opt/cfg.cpp
    ${SPIRV_TOOLS}source/opt/cfg_cleanup_pass.cpp
    ${SPIRV_TOOLS}source/opt/code_sink.cpp
    ${SPIRV_TOOLS}source/opt/combine_access_chains.cpp
    ${SPIRV_TOOLS}source/opt/compact_ids_pass.cpp
    ${SPIRV_TOOLS}source/opt/composite.cpp
    ${SPIRV_TOOLS}source/opt/constants.cpp
    ${SPIRV_TOOLS}source/opt/const_folding_rules.cpp
    ${SPIRV_TOOLS}source/opt/control_dependence.cpp
    ${SPIRV_TOOLS}source/opt/convert_to_half_pass.cpp
    ${SPIRV_TOOLS}source/opt/convert_to_sampled_image_pass.cpp
    ${SPIRV_TOOLS}source/opt/copy_prop_arrays.cpp
    ${SPIRV_TOOLS}source/opt/dataflow.cpp
    ${SPIRV_TOOLS}source/opt/dead_branch_elim_pass.cpp
    ${SPIRV_TOOLS}source/opt/dead_insert_elim_pass.cpp
    ${SPIRV_TOOLS}source/opt/dead_variable_elimination.cpp
    ${SPIRV_TOOLS}source/opt/debug_info_manager.cpp
    ${SPIRV_TOOLS}source/opt/decoration_manager.cpp
    ${SPIRV_TOOLS}source/opt/def_use_manager.cpp
    ${SPIRV_TOOLS}source/opt/desc_sroa.cpp
    ${SPIRV_TOOLS}source/opt/desc_sroa_util.cpp
    ${SPIRV_TOOLS}source/opt/dominator_analysis.cpp
    ${SPIRV_TOOLS}source/opt/dominator_tree.cpp
    ${SPIRV_TOOLS}source/opt/eliminate_dead_constant_pass.cpp
    ${SPIRV_TOOLS}source/opt/eliminate_dead_functions_pass.cpp
    ${SPIRV_TOOLS}source/opt/eliminate_dead_functions_util.cpp
    ${SPIRV_TOOLS}source/opt/eliminate_dead_input_components_pass.cpp
    ${SPIRV_TOOLS}source/opt/eliminate_dead_members_pass.cpp
    ${SPIRV_TOOLS}source/opt/feature_manager.cpp
    ${SPIRV_TOOLS}source/opt/fix_func_call_arguments.cpp
    ${SPIRV_TOOLS}source/opt/fix_storage_class.cpp
    ${SPIRV_TOOLS}source/opt/flatten_decoration_pass.cpp
    ${SPIRV_TOOLS}source/opt/fold.cpp
    ${SPIRV_TOOLS}source/opt/folding_rules.cpp
    ${SPIRV_TOOLS}source/opt/fold_spec_constant_op_and_composite_pass.cpp
    ${SPIRV_TOOLS}source/opt/freeze_spec_constant_value_pass.cpp
    ${SPIRV_TOOLS}source/opt/function.cpp
    ${SPIRV_TOOLS}source/opt/graphics_robust_access_pass.cpp
    ${SPIRV_TOOLS}source/opt/if_conversion.cpp
    ${SPIRV_TOOLS}source/opt/inline_exhaustive_pass.cpp
    ${SPIRV_TOOLS}source/opt/inline_opaque_pass.cpp
    ${SPIRV_TOOLS}source/opt/inline_pass.cpp
    ${SPIRV_TOOLS}source/opt/instruction.cpp
    ${SPIRV_TOOLS}source/opt/instruction_list.cpp
    ${SPIRV_TOOLS}source/opt/instrument_pass.cpp
    ${SPIRV_TOOLS}source/opt/inst_bindless_check_pass.cpp
    ${SPIRV_TOOLS}source/opt/inst_buff_addr_check_pass.cpp
    ${SPIRV_TOOLS}source/opt/inst_debug_printf_pass.cpp
    ${SPIRV_TOOLS}source/opt/interface_var_sroa.cpp
    ${SPIRV_TOOLS}source/opt/interp_fixup_pass.cpp
    ${SPIRV_TOOLS}source/opt/ir_context.cpp
    ${SPIRV_TOOLS}source/opt/ir_loader.cpp
    ${SPIRV_TOOLS}source/opt/licm_pass.cpp
    ${SPIRV_TOOLS}source/opt/local_access_chain_convert_pass.cpp
    ${SPIRV_TOOLS}source/opt/local_redundancy_elimination.cpp
    ${SPIRV_TOOLS}source/opt/local_single_block_elim_pass.cpp
    ${SPIRV_TOOLS}source/opt/local_single_store_elim_pass.cpp
    ${SPIRV_TOOLS}source/opt/loop_dependence.cpp
    ${SPIRV_TOOLS}source/opt/loop_dependence_helpers.cpp
    ${SPIRV_TOOLS}source/opt/loop_descriptor.cpp
    ${SPIRV_TOOLS}source/opt/loop_fission.cpp
    ${SPIRV_TOOLS}source/opt/loop_fusion.cpp
    ${SPIRV_TOOLS}source/opt/loop_fusion_pass.cpp
    ${SPIRV_TOOLS}source/opt/loop_peeling.cpp
    ${SPIRV_TOOLS}source/opt/loop_unroller.cpp
    ${SPIRV_TOOLS}source/opt/loop_unswitch_pass.cpp
    ${SPIRV_TOOLS}source/opt/loop_utils.cpp
    ${SPIRV_TOOLS}source/opt/mem_pass.cpp
    ${SPIRV_TOOLS}source/opt/merge_return_pass.cpp
    ${SPIRV_TOOLS}source/opt/module.cpp
    ${SPIRV_TOOLS}source/opt/optimizer.cpp
    ${SPIRV_TOOLS}source/opt/pass.cpp
    ${SPIRV_TOOLS}source/opt/pass_manager.cpp
    ${SPIRV_TOOLS}source/opt/pch_source_opt.cpp
    ${SPIRV_TOOLS}source/opt/private_to_local_pass.cpp
    ${SPIRV_TOOLS}source/opt/propagator.cpp
    ${SPIRV_TOOLS}source/opt/reduce_load_size.cpp
    ${SPIRV_TOOLS}source/opt/redundancy_elimination.cpp
    ${SPIRV_TOOLS}source/opt/register_pressure.cpp
    ${SPIRV_TOOLS}source/opt/relax_float_ops_pass.cpp
    ${SPIRV_TOOLS}source/opt/remove_dontinline_pass.cpp
    ${SPIRV_TOOLS}source/opt/remove_duplicates_pass.cpp
    ${SPIRV_TOOLS}source/opt/remove_unused_interface_variables_pass.cpp
    ${SPIRV_TOOLS}source/opt/replace_desc_array_access_using_var_index.cpp
    ${SPIRV_TOOLS}source/opt/replace_invalid_opc.cpp
    ${SPIRV_TOOLS}source/opt/scalar_analysis.cpp
    ${SPIRV_TOOLS}source/opt/scalar_analysis_simplification.cpp
    ${SPIRV_TOOLS}source/opt/scalar_replacement_pass.cpp
    ${SPIRV_TOOLS}source/opt/set_spec_constant_default_value_pass.cpp
    ${SPIRV_TOOLS}source/opt/simplification_pass.cpp
    ${SPIRV_TOOLS}source/opt/spread_volatile_semantics.cpp
    ${SPIRV_TOOLS}source/opt/ssa_rewrite_pass.cpp
    ${SPIRV_TOOLS}source/opt/strength_reduction_pass.cpp
    ${SPIRV_TOOLS}source/opt/strip_debug_info_pass.cpp
    ${SPIRV_TOOLS}source/opt/strip_nonsemantic_info_pass.cpp
    ${SPIRV_TOOLS}source/opt/struct_cfg_analysis.cpp
    ${SPIRV_TOOLS}source/opt/types.cpp
    ${SPIRV_TOOLS}source/opt/type_manager.cpp
    ${SPIRV_TOOLS}source/opt/unify_const_pass.cpp
    ${SPIRV_TOOLS}source/opt/upgrade_memory_model.cpp
    ${SPIRV_TOOLS}source/opt/value_number_table.cpp
    ${SPIRV_TOOLS}source/opt/vector_dce.cpp
    ${SPIRV_TOOLS}source/opt/workaround1209.cpp
    ${SPIRV_TOOLS}source/opt/wrap_opkill.cpp

    ${SPIRV_TOOLS}source/reduce/change_operand_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/change_operand_to_undef_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/conditional_branch_to_simple_conditional_branch_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/conditional_branch_to_simple_conditional_branch_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/merge_blocks_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/merge_blocks_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/operand_to_const_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/operand_to_dominating_id_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/operand_to_undef_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/pch_source_reduce.cpp
    ${SPIRV_TOOLS}source/reduce/reducer.cpp
    ${SPIRV_TOOLS}source/reduce/reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/reduction_pass.cpp
    ${SPIRV_TOOLS}source/reduce/reduction_util.cpp
    ${SPIRV_TOOLS}source/reduce/remove_block_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/remove_block_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/remove_function_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/remove_function_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/remove_instruction_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/remove_selection_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/remove_selection_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/remove_struct_member_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/remove_unused_instruction_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/remove_unused_struct_member_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/simple_conditional_branch_to_branch_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/simple_conditional_branch_to_branch_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/structured_construct_to_block_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/structured_construct_to_block_reduction_opportunity_finder.cpp
    ${SPIRV_TOOLS}source/reduce/structured_loop_to_selection_reduction_opportunity.cpp
    ${SPIRV_TOOLS}source/reduce/structured_loop_to_selection_reduction_opportunity_finder.cpp
)

target_include_directories(spirv_opt
    PUBLIC
        ${SPIRV_TOOLS}include
        ${SPIRV_TOOLS}include/generated
        ${SPIRV_HEADERS}include
    PRIVATE
        ${SPIRV_TOOLS}
        ${SPIRV_TOOLS}source
)

if(MSVC)
    target_compile_options(spirv_opt PRIVATE
        /wd4127 # warning C4127: conditional expression is constant
        /wd4389 # warning C4389: '==': signed/unsigned mismatch
        /wd4702 # warning C4702: unreachable code
        /wd4706 # warning C4706: assignment within conditional expression
    )
endif()

if(APPLE OR LINUX OR MINGW)
    target_compile_options(spirv_opt PRIVATE
        -Wno-misleading-indentation
        -Wno-switch
    )
endif()

set_target_properties(spirv_opt PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party/shaderc"
)


# ------------------------------------------------------------------------------
# SPIRV-CROSS
# ------------------------------------------------------------------------------

add_library(spirv_cross STATIC
    ${SPIRV_CROSS}spirv.hpp
    ${SPIRV_CROSS}spirv_cfg.cpp
    ${SPIRV_CROSS}spirv_cfg.hpp
    ${SPIRV_CROSS}spirv_common.hpp
    ${SPIRV_CROSS}spirv_cpp.cpp
    ${SPIRV_CROSS}spirv_cpp.hpp
    ${SPIRV_CROSS}spirv_cross.cpp
    ${SPIRV_CROSS}spirv_cross.hpp
    ${SPIRV_CROSS}spirv_cross_parsed_ir.cpp
    ${SPIRV_CROSS}spirv_cross_parsed_ir.hpp
    ${SPIRV_CROSS}spirv_cross_util.cpp
    ${SPIRV_CROSS}spirv_cross_util.hpp
    ${SPIRV_CROSS}spirv_glsl.cpp
    ${SPIRV_CROSS}spirv_glsl.hpp
    ${SPIRV_CROSS}spirv_hlsl.cpp
    ${SPIRV_CROSS}spirv_hlsl.hpp
    ${SPIRV_CROSS}spirv_msl.cpp
    ${SPIRV_CROSS}spirv_msl.hpp
    ${SPIRV_CROSS}spirv_parser.cpp
    ${SPIRV_CROSS}spirv_parser.hpp
    ${SPIRV_CROSS}spirv_reflect.cpp
    ${SPIRV_CROSS}spirv_reflect.hpp
)

target_include_directories(spirv_cross PUBLIC
    ${SPIRV_CROSS}
    ${SPIRV_CROSS}include
)

target_compile_definitions(spirv_cross PUBLIC
    SPIRV_CROSS_EXCEPTIONS_TO_ASSERTIONS
)

if(MSVC)
    target_compile_options(spirv_cross PRIVATE
        /wd4018 # warning C4018: '<': signed/unsigned mismatch
        /wd4245 # warning C4245: 'return': conversion from 'int' to 'unsigned int', signed/unsigned mismatch
        /wd4706 # warning C4706: assignment within conditional expression
        /wd4715 # warning C4715: '': not all control paths return a value
    )
endif()

if(APPLE OR LINUX OR MINGW)
    target_compile_options(spirv_opt PRIVATE
        -Wno-type-limits
    )
endif()

set_target_properties(spirv_cross PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party/shaderc"
)


# ------------------------------------------------------------------------------
# GLSLANG
# ------------------------------------------------------------------------------

set(GLSLANG_SOURCES
    ${GLSLANG}glslang/CInterface/glslang_c_interface.cpp
    ${GLSLANG}glslang/GenericCodeGen/CodeGen.cpp
    ${GLSLANG}glslang/GenericCodeGen/Link.cpp
    ${GLSLANG}glslang/HLSL/hlslAttributes.cpp
    ${GLSLANG}glslang/HLSL/hlslGrammar.cpp
    ${GLSLANG}glslang/HLSL/hlslOpMap.cpp
    ${GLSLANG}glslang/HLSL/hlslParseables.cpp
    ${GLSLANG}glslang/HLSL/hlslParseHelper.cpp
    ${GLSLANG}glslang/HLSL/hlslScanContext.cpp
    ${GLSLANG}glslang/HLSL/hlslTokenStream.cpp
    ${GLSLANG}glslang/MachineIndependent/attribute.cpp
    ${GLSLANG}glslang/MachineIndependent/Constant.cpp
    ${GLSLANG}glslang/MachineIndependent/glslang_tab.cpp
    ${GLSLANG}glslang/MachineIndependent/InfoSink.cpp
    ${GLSLANG}glslang/MachineIndependent/Initialize.cpp
    ${GLSLANG}glslang/MachineIndependent/Intermediate.cpp
    ${GLSLANG}glslang/MachineIndependent/intermOut.cpp
    ${GLSLANG}glslang/MachineIndependent/IntermTraverse.cpp
    ${GLSLANG}glslang/MachineIndependent/iomapper.cpp
    ${GLSLANG}glslang/MachineIndependent/limits.cpp
    ${GLSLANG}glslang/MachineIndependent/linkValidate.cpp
    ${GLSLANG}glslang/MachineIndependent/parseConst.cpp
    ${GLSLANG}glslang/MachineIndependent/ParseContextBase.cpp
    ${GLSLANG}glslang/MachineIndependent/ParseHelper.cpp
    ${GLSLANG}glslang/MachineIndependent/PoolAlloc.cpp
    ${GLSLANG}glslang/MachineIndependent/propagateNoContraction.cpp
    ${GLSLANG}glslang/MachineIndependent/reflection.cpp
    ${GLSLANG}glslang/MachineIndependent/RemoveTree.cpp
    ${GLSLANG}glslang/MachineIndependent/Scan.cpp
    ${GLSLANG}glslang/MachineIndependent/ShaderLang.cpp
    ${GLSLANG}glslang/MachineIndependent/SpirvIntrinsics.cpp
    ${GLSLANG}glslang/MachineIndependent/SymbolTable.cpp
    ${GLSLANG}glslang/MachineIndependent/Versions.cpp
    ${GLSLANG}glslang/MachineIndependent/preprocessor/Pp.cpp
    ${GLSLANG}glslang/MachineIndependent/preprocessor/PpAtom.cpp
    ${GLSLANG}glslang/MachineIndependent/preprocessor/PpContext.cpp
    ${GLSLANG}glslang/MachineIndependent/preprocessor/PpScanner.cpp
    ${GLSLANG}glslang/MachineIndependent/preprocessor/PpTokens.cpp
    ${GLSLANG}glslang/OSDependent/Web/glslang.js.cpp

    ${GLSLANG}hlsl/stub.cpp

    ${GLSLANG}SPIRV/disassemble.cpp
    ${GLSLANG}SPIRV/doc.cpp
    ${GLSLANG}SPIRV/GlslangToSpv.cpp
    ${GLSLANG}SPIRV/InReadableOrder.cpp
    ${GLSLANG}SPIRV/Logger.cpp
    ${GLSLANG}SPIRV/SpvBuilder.cpp
    ${GLSLANG}SPIRV/SpvPostProcess.cpp
    ${GLSLANG}SPIRV/SPVRemapper.cpp
    ${GLSLANG}SPIRV/SpvTools.cpp
    ${GLSLANG}SPIRV/CInterface/spirv_c_interface.cpp

    ${GLSLANG}OGLCompilersDLL/InitializeDll.cpp
)

if(WIN32)
    list(APPEND GLSLANG_SOURCES
        ${GLSLANG}glslang/OSDependent/Windows/ossource.cpp
    )
else()
    list(APPEND GLSLANG_SOURCES
        ${GLSLANG}glslang/OSDependent/Unix/ossource.cpp
    )
endif()

add_library(glslang STATIC ${GLSLANG_SOURCES})

target_include_directories(glslang
    PUBLIC
        ${GLSLANG}
        ${GLSLANG}..
        ${GLSLANG}glslang/Include
        ${GLSLANG}glslang/Public
        ${SPIRV_TOOLS}include
    PRIVATE
        ${SPIRV_TOOLS}source
)

target_compile_definitions(glslang PUBLIC
    ENABLE_HLSL=1
    ENABLE_OPT=1
)

if(MSVC)
    target_compile_options(glslang PRIVATE
        /wd4005 # warning C4005: '_CRT_SECURE_NO_WARNINGS': macro redefinition
        /wd4065 # warning C4065: switch statement contains 'default' but no 'case' labels
        /wd4100 # warning C4100: 'inclusionDepth' : unreferenced formal parameter
        /wd4127 # warning C4127: conditional expression is constant
        /wd4189 # warning C4189: 'isFloat': local variable is initialized but not referenced
        /wd4244 # warning C4244: '=': conversion from 'int' to 'char', possible loss of data
        /wd4310 # warning C4310: cast truncates constant value
        /wd4389 # warning C4389: '==': signed/unsigned mismatch
        /wd4456 # warning C4456: declaration of 'feature' hides previous local declaration
        /wd4457 # warning C4457: declaration of 'token' hides function parameter
        /wd4458 # warning C4458: declaration of 'language' hides class member
        /wd4702 # warning C4702: unreachable code
        /wd4715 # warning C4715: 'spv::Builder::makeFpConstant': not all control paths return a value
        /wd4838 # warning C4838: conversion from 'spv::GroupOperation' to 'unsigned int' requires a narrowing conversion
    )
endif()

if(APPLE OR LINUX OR MINGW)
    target_compile_options(glslang PRIVATE
        -fno-strict-aliasing
        -Wno-ignored-qualifiers
        -Wno-implicit-fallthrough
        -Wno-missing-field-initializers
        -Wno-reorder
        -Wno-return-type
        -Wno-shadow
        -Wno-sign-compare
        -Wno-switch
        -Wno-undef
        -Wno-unknown-pragmas
        -Wno-unused-function
        -Wno-unused-parameter
        -Wno-unused-variable

        -Wno-unused-const-variable
        -Wno-deprecated-register
    )
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    target_compile_options(glslang PRIVATE
        -Wno-logical-op
        -Wno-maybe-uninitialized
        -Wno-unused-but-set-variable
    )
endif()

set_target_properties(glslang PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party/shaderc"
)


# ------------------------------------------------------------------------------
# GLSL OPTIMIZER
# ------------------------------------------------------------------------------

add_library(glsl_optimizer STATIC
    ${GLSL_OPTIMIZER}src/glsl/glcpp/glcpp-lex.c
    ${GLSL_OPTIMIZER}src/glsl/glcpp/glcpp-parse.c
    ${GLSL_OPTIMIZER}src/glsl/glcpp/pp.c

    ${GLSL_OPTIMIZER}src/glsl/ast_array_index.cpp
    ${GLSL_OPTIMIZER}src/glsl/ast_expr.cpp
    ${GLSL_OPTIMIZER}src/glsl/ast_function.cpp
    ${GLSL_OPTIMIZER}src/glsl/ast_to_hir.cpp
    ${GLSL_OPTIMIZER}src/glsl/ast_type.cpp
    ${GLSL_OPTIMIZER}src/glsl/builtin_functions.cpp
    ${GLSL_OPTIMIZER}src/glsl/builtin_types.cpp
    ${GLSL_OPTIMIZER}src/glsl/builtin_variables.cpp
    ${GLSL_OPTIMIZER}src/glsl/glsl_lexer.cpp
    ${GLSL_OPTIMIZER}src/glsl/glsl_optimizer.cpp
    ${GLSL_OPTIMIZER}src/glsl/glsl_parser.cpp
    ${GLSL_OPTIMIZER}src/glsl/glsl_parser_extras.cpp
    ${GLSL_OPTIMIZER}src/glsl/glsl_symbol_table.cpp
    ${GLSL_OPTIMIZER}src/glsl/glsl_types.cpp
    ${GLSL_OPTIMIZER}src/glsl/hir_field_selection.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_basic_block.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_builder.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_clone.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_constant_expression.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_equals.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_expression_flattening.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_function.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_function_can_inline.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_function_detect_recursion.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_hierarchical_visitor.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_hv_accept.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_import_prototypes.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_print_glsl_visitor.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_print_metal_visitor.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_print_visitor.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_rvalue_visitor.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_stats.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_unused_structs.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_validate.cpp
    ${GLSL_OPTIMIZER}src/glsl/ir_variable_refcount.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_atomics.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_functions.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_interface_blocks.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_uniform_block_active_visitor.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_uniform_blocks.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_uniform_initializers.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_uniforms.cpp
    ${GLSL_OPTIMIZER}src/glsl/link_varyings.cpp
    ${GLSL_OPTIMIZER}src/glsl/linker.cpp
    ${GLSL_OPTIMIZER}src/glsl/loop_analysis.cpp
    ${GLSL_OPTIMIZER}src/glsl/loop_controls.cpp
    ${GLSL_OPTIMIZER}src/glsl/loop_unroll.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_clip_distance.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_discard.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_discard_flow.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_if_to_cond_assign.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_instructions.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_jumps.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_mat_op_to_vec.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_named_interface_blocks.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_noise.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_offset_array.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_output_reads.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_packed_varyings.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_packing_builtins.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_ubo_reference.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_variable_index_to_cond_assign.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_vec_index_to_cond_assign.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_vec_index_to_swizzle.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_vector.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_vector_insert.cpp
    ${GLSL_OPTIMIZER}src/glsl/lower_vertex_id.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_algebraic.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_array_splitting.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_constant_folding.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_constant_propagation.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_constant_variable.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_copy_propagation.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_copy_propagation_elements.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_cse.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_dead_builtin_variables.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_dead_builtin_varyings.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_dead_code.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_dead_code_local.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_dead_functions.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_flatten_nested_if_blocks.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_flip_matrices.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_function_inlining.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_if_simplification.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_minmax.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_noop_swizzle.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_rebalance_tree.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_redundant_jumps.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_structure_splitting.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_swizzle_swizzle.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_tree_grafting.cpp
    ${GLSL_OPTIMIZER}src/glsl/opt_vectorize.cpp
    ${GLSL_OPTIMIZER}src/glsl/s_expression.cpp
    ${GLSL_OPTIMIZER}src/glsl/standalone_scaffolding.cpp
    ${GLSL_OPTIMIZER}src/glsl/strtod.c

    ${GLSL_OPTIMIZER}src/mesa/main/imports.c

    ${GLSL_OPTIMIZER}src/mesa/program/prog_hash_table.c
    ${GLSL_OPTIMIZER}src/mesa/program/symbol_table.c

    ${GLSL_OPTIMIZER}src/util/hash_table.c
    ${GLSL_OPTIMIZER}src/util/ralloc.c
)

target_include_directories(glsl_optimizer
    PUBLIC
        ${GLSL_OPTIMIZER}include
        ${GLSL_OPTIMIZER}src/glsl
    PRIVATE
        ${GLSL_OPTIMIZER}src
        ${GLSL_OPTIMIZER}src/mesa
        ${GLSL_OPTIMIZER}src/mapi
)

if(MSVC)
    target_include_directories(glsl_optimizer PRIVATE
        ${GLSL_OPTIMIZER}src/glsl/msvc
    )

    target_compile_definitions(glsl_optimizer PRIVATE
        __STDC__
        __STDC_VERSION__=199901L
        strdup=_strdup
        alloca=_alloca
        isascii=__isascii
    )

    target_compile_options(glsl_optimizer PRIVATE
        /wd4100 # error C4100: '' : unreferenced formal parameter
        /wd4127 # warning C4127: conditional expression is constant
        /wd4132 # warning C4132: 'deleted_key_value': const object should be initialized
        /wd4189 # warning C4189: 'interface_type': local variable is initialized but not referenced
        /wd4204 # warning C4204: nonstandard extension used: non-constant aggregate initializer
        /wd4244 # warning C4244: '=': conversion from 'const flex_int32_t' to 'YY_CHAR', possible loss of data
        /wd4245 # warning C4245: 'return': conversion from 'int' to 'unsigned int', signed/unsigned mismatch
        /wd4389 # warning C4389: '!=': signed/unsigned mismatch
        /wd4701 # warning C4701: potentially uninitialized local variable 'lower' used
        /wd4702 # warning C4702: unreachable code
        /wd4706 # warning C4706: assignment within conditional expression
        /wd4996 # warning C4996: 'strdup': The POSIX name for this item is deprecated. Instead, use the ISO C++ conformant name: _strdup.
    )
endif()

if(APPLE OR LINUX OR MINGW)
    target_compile_options(glsl_optimizer PRIVATE
        -fno-strict-aliasing # glsl-optimizer has bugs if strict aliasing is used.

        -Wno-implicit-fallthrough
        -Wno-parentheses
        -Wno-sign-compare
        -Wno-unused-function
        -Wno-unused-parameter

        -Wno-deprecated-register

        -Wno-misleading-indentation
    )
endif()

set_target_properties(glsl_optimizer PROPERTIES
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party/shaderc"
)


# ------------------------------------------------------------------------------
# FCPP
# ------------------------------------------------------------------------------

add_library(fcpp STATIC
    ${FCPP_DIR}cpp1.c
    ${FCPP_DIR}cpp2.c
    ${FCPP_DIR}cpp3.c
    ${FCPP_DIR}cpp4.c
    ${FCPP_DIR}cpp5.c
    ${FCPP_DIR}cpp6.c
    ${FCPP_DIR}cpp6.c
)

target_include_directories(fcpp PUBLIC
    ${FCPP_DIR}
)

if(MSVC)
    target_compile_options(fcpp PRIVATE
        /wd4055 # warning C4055: 'type cast': from data pointer 'void *' to function pointer 'void (__cdecl *)(char *,void *)'
        /wd4244 # warning C4244: '=': conversion from 'const flex_int32_t' to 'YY_CHAR', possible loss of data
        /wd4701 # warning C4701: potentially uninitialized local variable 'lower' used
        /wd4706 # warning C4706: assignment within conditional expression
    )
else()
    target_compile_options(fcpp PRIVATE
        -Wno-implicit-fallthrough
        -Wno-incompatible-pointer-types
        -Wno-parentheses-equality
    )
endif()

set_target_properties(fcpp PROPERTIES
    C_STANDARD 99
    C_EXTENSIONS OFF
    C_STANDARD_REQUIRED ON
    CXX_STANDARD 20
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    FOLDER "Third Party/shaderc"
)


# ------------------------------------------------------------------------------
# SHADERC EXECUTABLE
# ------------------------------------------------------------------------------

function(create_shaderc_target AS_EXECUTABLE)
    set(SHADERC_SOURCES
        ${bgfx_SOURCE_DIR}/src/shader.cpp
        ${bgfx_SOURCE_DIR}/src/shader_dx9bc.cpp
        ${bgfx_SOURCE_DIR}/src/shader_dxbc.cpp
        ${bgfx_SOURCE_DIR}/src/shader_spirv.cpp
        ${bgfx_SOURCE_DIR}/src/vertexlayout.cpp
        ${bgfx_SOURCE_DIR}/tools/shaderc/shaderc.cpp
        ${bgfx_SOURCE_DIR}/tools/shaderc/shaderc_glsl.cpp
        ${bgfx_SOURCE_DIR}/tools/shaderc/shaderc_hlsl.cpp
        ${bgfx_SOURCE_DIR}/tools/shaderc/shaderc_metal.cpp
        ${bgfx_SOURCE_DIR}/tools/shaderc/shaderc_pssl.cpp
        ${bgfx_SOURCE_DIR}/tools/shaderc/shaderc_spirv.cpp
    )

    if(${AS_EXECUTABLE})
        set(TARGET shaderc)

        add_executable(${TARGET} ${SHADERC_SOURCES})
    else()
        set(TARGET shaderclib)

        set(BGFX_SHADER_STR_DIR ${CMAKE_BINARY_DIR}/bgfx_shader_str)
        set(BGFX_SHADER_STR_FILE ${BGFX_SHADER_STR_DIR}/bgfx_shader_str.h)
        if(NOT EXISTS "${BGFX_SHADER_STR_FILE}")
            set(VAR_NAME "s_bgfx_shader_str")

            file(READ ${bgfx_SOURCE_DIR}/src/bgfx_shader.sh VAR_CONTENT)
            string(APPEND VAR_CONTENT "\"")
            string(PREPEND VAR_CONTENT "\"")
            string(REPLACE "\\" "\\\\" VAR_CONTENT "${VAR_CONTENT}")
            string(REPLACE "\n" "\\n\"\n\"" VAR_CONTENT "${VAR_CONTENT}")

            configure_file(src/file_to_string.h.in ${BGFX_SHADER_STR_FILE})
        endif()

        list(APPEND SHADERC_SOURCES
            src/shaderclib.cpp
        )

        add_library(${TARGET} STATIC ${SHADERC_SOURCES})

        target_link_libraries(${TARGET} PRIVATE bgfx)

        target_compile_definitions(${TARGET}
            PUBLIC
                WITH_SHADERC_LIBRARY
            PRIVATE
                fatal=fatal_shaderc
                g_allocator=g_allocator_shaderc
                getUniformTypeName=getUniformTypeName_shaderc
                main=main_shaderc
                nameToUniformTypeEnum=nameToUniformTypeEnum_shaderc
                s_uniformTypeName=s_uniformTypeName_shaderc
                TinyStlAllocator=TinyStlAllocator_shaderc
                trace=trace_shaderc
        )

        target_include_directories(${TARGET}
            PUBLIC
                src
            PRIVATE
                ${BGFX_SHADER_STR_DIR}
                ${bgfx_SOURCE_DIR}/tools/shaderc
        )
    endif()

    target_include_directories(${TARGET} PRIVATE
        ${bgfx_SOURCE_DIR}/3rdparty/webgpu/include
        ${bgfx_SOURCE_DIR}/3rdparty/dxsdk/include
        ${bgfx_SOURCE_DIR}/include
    )

    target_link_libraries(${TARGET} PRIVATE
        bimg
        bx
        fcpp
        glsl_optimizer
        glslang
        spirv_cross
        spirv_opt
    )

    if(WIN32)
        target_link_libraries(${TARGET} PRIVATE
            Psapi.lib
        )
    endif()

    if(APPLE)
        target_link_libraries(${TARGET} PRIVATE
            "-framework Cocoa"
        )
    endif()

    if(APPLE OR LINUX)
        set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
        set(THREADS_PREFER_PTHREAD_FLAG TRUE)

        find_package(Threads REQUIRED)

        target_link_libraries(${TARGET} PRIVATE
            Threads::Threads
        )
    endif()

    set_target_properties(${TARGET} PROPERTIES
        CXX_STANDARD 20
        CXX_EXTENSIONS OFF
        CXX_STANDARD_REQUIRED ON
        FOLDER "Third Party/shaderc"
    )

    if(APPLE)
        set(SHADERC_PLATFORM osx)
    elseif(WIN32)
        set(SHADERC_PLATFORM windows)
    else()
        message(FATAL_ERROR "Unsupported platform.")
    endif()

    if(${AS_EXECUTABLE})
        add_custom_command(
            TARGET shaderc
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:shaderc> "${CMAKE_SOURCE_DIR}/tools/shaderc/${SHADERC_PLATFORM}/$<TARGET_FILE_NAME:shaderc>"
        )
    endif()
endfunction() # create_shaderc_target


# ------------------------------------------------------------------------------
# SHADERC EXECUTABLE
# ------------------------------------------------------------------------------

if(NOT PREBUILT_SHADERC_AVAILABLE)
    create_shaderc_target(TRUE)
endif() # NOT PREBUILT_SHADERC_AVAILABLE


# ------------------------------------------------------------------------------
# SHADERC LIBRARY
# ------------------------------------------------------------------------------

if(WITH_SHADERC_LIBRARY)
    create_shaderc_target(FALSE)
endif() # WITH_SHADERC_LIBRARY