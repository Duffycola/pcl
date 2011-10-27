
set(PCL_SUBSYSTEMS_MODULES ${PCL_SUBSYSTEMS})
list(REMOVE_ITEM PCL_SUBSYSTEMS_MODULES tools global_tests apps)

set(PCLCONFIG_AVAILABLE_COMPONENTS)
set(PCLCONFIG_AVAILABLE_COMPONENTS_LIST)
set(PCLCONFIG_INTERNAL_DEPENDENCIES)
set(PCLCONFIG_EXTERNAL_DEPENDENCIES)
set(PCLCONFIG_OPTIONAL_DEPENDENCIES)
foreach(_ss ${PCL_SUBSYSTEMS_MODULES})
    PCL_GET_SUBSYS_STATUS(_status ${_ss})
    if(_status)
        set(PCLCONFIG_AVAILABLE_COMPONENTS "${PCLCONFIG_AVAILABLE_COMPONENTS} ${_ss}")
        set(PCLCONFIG_AVAILABLE_COMPONENTS_LIST "${PCLCONFIG_AVAILABLE_COMPONENTS_LIST}\n# - ${_ss}")
        GET_IN_MAP(_deps PCL_SUBSYS_DEPS ${_ss})
        if(_deps)
            set(PCLCONFIG_INTERNAL_DEPENDENCIES "${PCLCONFIG_INTERNAL_DEPENDENCIES}set(pcl_${_ss}_int_dep ")
            foreach(_dep ${_deps})
                set(PCLCONFIG_INTERNAL_DEPENDENCIES "${PCLCONFIG_INTERNAL_DEPENDENCIES}${_dep} ")
            endforeach(_dep)
            set(PCLCONFIG_INTERNAL_DEPENDENCIES "${PCLCONFIG_INTERNAL_DEPENDENCIES})\n")
        endif(_deps)
        GET_IN_MAP(_ext_deps PCL_SUBSYS_EXT_DEPS ${_ss})
        if(_ext_deps)
            set(PCLCONFIG_EXTERNAL_DEPENDENCIES "${PCLCONFIG_EXTERNAL_DEPENDENCIES}set(pcl_${_ss}_ext_dep ")
            foreach(_ext_dep ${_ext_deps})
                set(PCLCONFIG_EXTERNAL_DEPENDENCIES "${PCLCONFIG_EXTERNAL_DEPENDENCIES}${_ext_dep} ")
            endforeach(_ext_dep)
            set(PCLCONFIG_EXTERNAL_DEPENDENCIES "${PCLCONFIG_EXTERNAL_DEPENDENCIES})\n")
        endif(_ext_deps)	
        GET_IN_MAP(_opt_deps PCL_SUBSYS_OPT_DEPS ${_ss})
        if(_opt_deps)
            set(PCLCONFIG_OPTIONAL_DEPENDENCIES "${PCLCONFIG_OPTIONAL_DEPENDENCIES}set(pcl_${_ss}_opt_dep ")
            foreach(_opt_dep ${_opt_deps})
                set(PCLCONFIG_OPTIONAL_DEPENDENCIES "${PCLCONFIG_OPTIONAL_DEPENDENCIES}${_opt_dep} ")
            endforeach(_opt_dep)
            set(PCLCONFIG_OPTIONAL_DEPENDENCIES "${PCLCONFIG_OPTIONAL_DEPENDENCIES})\n")
        endif(_opt_deps)
    endif(_status)
endforeach(_ss)

# apped range_image_border_extractor
PCL_GET_SUBSYS_STATUS(_status features)
if(_status)
    set(PCLCONFIG_AVAILABLE_COMPONENTS "${PCLCONFIG_AVAILABLE_COMPONENTS} range_image_border_extractor")
    set(PCLCONFIG_AVAILABLE_COMPONENTS_LIST "${PCLCONFIG_AVAILABLE_COMPONENTS_LIST}\n# - range_image_border_extractor")
    set(PCLCONFIG_INTERNAL_DEPENDENCIES "${PCLCONFIG_INTERNAL_DEPENDENCIES}set(pcl_range_image_border_extractor_int_dep common kdtree range_image)\n")
endif(_status)

configure_file("${PCL_SOURCE_DIR}/PCLConfig.cmake.in"
               "${PCL_BINARY_DIR}/PCLConfig.cmake" @ONLY)
configure_file("${PCL_SOURCE_DIR}/PCLConfigVersion.cmake.in"
               "${PCL_BINARY_DIR}/PCLConfigVersion.cmake" @ONLY)
install(FILES
        "${PCL_BINARY_DIR}/PCLConfig.cmake"
        "${PCL_BINARY_DIR}/PCLConfigVersion.cmake"
        COMPONENT pclconfig
        DESTINATION ${PCLCONFIG_INSTALL_DIR})
