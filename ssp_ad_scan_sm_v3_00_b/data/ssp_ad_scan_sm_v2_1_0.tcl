##############################################################################
##
## ***************************************************************************
## **                                                                       **
## ** Copyright (c) 1995-2006 Xilinx, Inc.  All rights reserved.            **
## **                                                                       **
## ** You may copy and modify these files for your own internal use solely  **
## ** with Xilinx programmable logic devices and Xilinx EDK system or       **
## ** create IP modules solely for Xilinx programmable logic devices and    **
## ** Xilinx EDK system. No rights are granted to distribute any files      **
## ** unless they are distributed in Xilinx programmable logic devices.     **
## **                                                                       **
## ***************************************************************************
##
## Modified:
## June 20 2006: Added html elaboration step
## July 8  2006: Fixed for edk export, added pcore version elaboration
## Aug  15 2007: Fixed bug where drivers are not generated when multiple 
##               identical pcores are added.
##############################################################################

proc generate {drv_handle} {
    # Get a handle to HW Instances using this driver
    set hw_insts [xget_periphs $drv_handle]

    set numinsts [llength $hw_insts]
    
    # String used when there are multiple instances of pcores that use this driver
    set muldocstr ""
    set listvars ""

    # for each hw instance, inflate driver customized to that instance's name
    foreach one_hw_inst $hw_insts {
	set listvars [inflate_driver $one_hw_inst $drv_handle $numinsts]
	set hw_inst_name [lindex $listvars 0]
	set muldocstr [concat $muldocstr "<a href=\"${hw_inst_name}_index.html\">${hw_inst_name} documentation</a><br/>"]
    }

    set hw_inst_name [lindex $listvars 0]
    set ipver [lindex $listvars 1]
    set pcorename [lindex $listvars 2]
    set userrep "c:/edk_user_repository/MyProcessorIPLib"
    if {$numinsts > 1} {
	expand_Template_File "${userrep}/pcores/${pcorename}_v${ipver}/doc/html/api/multipleindex.template" "${userrep}/pcores/${pcorename}_v${ipver}/doc/html/api/index.html" $hw_inst_name $muldocstr "" $pcorename 1
    }
}
    
proc inflate_driver {hw_inst_handle drv_handle numtotalinsts} {
     # Get the HW instance name
     set hw_inst_name [xget_hw_name $hw_inst_handle]
     puts "Inflating device drivers for ${hw_inst_name}  ... "

     # Get the name of the pcore (not the HW Instance name)
     set pcorename [xget_sw_parameter_value $drv_handle "DRIVER_NAME"]

     # Get driver version number for HTML inflation. Ver should be e.g. 1.00.a
     set drv_ver_handle [xget_sw_parameter_handle $drv_handle "DRIVER_VER"]
     set ipver_t [xget_value $drv_ver_handle "value"]    
     regsub -all {\.} $ipver_t "_" ipver

     # Add defines to xparameter
     sg_add_to_xparameters $hw_inst_handle $drv_handle

     # Extract the FSL index used for this hw instance
     set ws [get_fsl_writeslot $hw_inst_name $pcorename]
     set rs [get_fsl_readslot $hw_inst_name $pcorename]

     # Inflate template .c and .h files
     expand_Template_File "src/proc.templateh" "src/${hw_inst_name}.h" $hw_inst_name $ws $rs $pcorename 0
     expand_Template_File "src/proc.templatec" "src/${hw_inst_name}.c" $hw_inst_name $ws $rs $pcorename 0
     expand_Template_File "src/Makefile" "src/Makefile" $hw_inst_name $ws $rs $pcorename 0
     set userrep "c:/edk_user_repository/MyProcessorIPLib"
    
     # Inflate template htm api index file
     # This code for HTML currently has a bug. HTML is customized for only 1 pcore. MemMap info is
     # correct, but function prefix and #include info is inaccurate.
     if {$numtotalinsts > 1} {
	 expand_Template_File "${userrep}/pcores/${pcorename}_v${ipver}/doc/html/api/index.template" "${userrep}/pcores/${pcorename}_v${ipver}/doc/html/api/${hw_inst_name}_index.html" $hw_inst_name $ws $rs $pcorename 1
     } else {
	 expand_Template_File "${userrep}/pcores/${pcorename}_v${ipver}/doc/html/api/index.template" "${userrep}/pcores/${pcorename}_v${ipver}/doc/html/api/index.html" $hw_inst_name $ws $rs $pcorename 1
     }
   
     return [list $hw_inst_name $ipver $pcorename]

 }


proc get_fsl_writeslot {core_name ipname} {
    if {[string compare -nocase "none" $core_name] != 0} {
	set sw_prochandle [xget_libgen_proc_handle]
	set ip_handle [xget_sw_ipinst_handle_from_processor $sw_prochandle $core_name]
	set mhs_handle [xget_handle $ip_handle "parent"]
	
	set mfsl_name [xget_value $ip_handle "BUS_INTERFACE" "MFSL"]
	if {$mfsl_name != ""} {
	    set mfsl_slave [xget_hw_connected_busifs_handle $mhs_handle $mfsl_name "slave"]
	    set mfsl_index [xget_value $mfsl_slave "NAME"]
	    set mfsl_index [string toupper $mfsl_index]
	    set mfsl_index [string map {SFSL ""} $mfsl_index]
	    return $mfsl_index;
	}
    }
    return 0
}

proc get_fsl_readslot {core_name ipname} {
    if {[string compare -nocase "none" $core_name] != 0} {
	set sw_prochandle [xget_libgen_proc_handle]
	set ip_handle [xget_sw_ipinst_handle_from_processor $sw_prochandle $core_name]
	set mhs_handle [xget_handle $ip_handle "parent"]
	
	set sfsl_name [xget_value $ip_handle "BUS_INTERFACE" "SFSL"]
	if {$sfsl_name != ""} {
	    set sfsl_master [xget_hw_connected_busifs_handle $mhs_handle $sfsl_name "master"]
	    set sfsl_index [xget_value $sfsl_master "NAME"]
	    set sfsl_index [string toupper $sfsl_index]
	    set sfsl_index [string map {MFSL ""} $sfsl_index]
	    return $sfsl_index;
	}
    }
    return 0
}

proc sg_add_to_xparameters {hw_inst_handle drv_handle} {
    set hw_inst_name [xget_hw_name $hw_inst_handle]   
    set hw_inst_name_caps [string toupper $hw_inst_name]
    set usepolling [xget_sw_parameter_value $drv_handle "SG_USEPOLLING"]

    set conffile  [xopen_include_file "xparameters.h"]
    puts  $conffile "#define ${hw_inst_name_caps}_SG_ENABLE_FSL_ERROR_CHECK"
    if { ${usepolling} == true } {
      puts  $conffile "#define ${hw_inst_name_caps}_SG_ENABLE_POLLING_FSL_DRIVERS"
    }    
    puts  $conffile ""
    puts  $conffile "/******************************************************************/"
    puts  $conffile ""
    close $conffile 
   
}


proc expand_Template_File {filename saveasname core_name ws rs drvname isdoc} {
    set fn "$filename"
    set tn "sgtemp.tmp"
    set core_name_caps [string toupper $core_name]
    

    set fh [open $fn r]
    set wfh [open $tn w]
   
    if { $isdoc==1 } {
	while { [gets $fh line] >= 0 } {
	    regsub -all {\[HWINST\]} $line $core_name_caps match
	    regsub -all {\[hwinst\]} $match $core_name outstr
	    regsub -all {\[drvname\]} $outstr $drvname outstr
	    regsub -all {\[body\]} $outstr $ws outstr
	    puts $wfh $outstr
	}
    } else {
	while { [gets $fh line] >= 0 } {
	    regsub -all {<HWINST>} $line $core_name_caps match
	    regsub -all {<hwinst>} $match $core_name outstr
	    regsub -all {<WRITESLOTID>} $outstr $ws outstr
	    regsub -all {<READSLOTID>} $outstr $rs outstr
	    regsub -all {<drvname>} $outstr $drvname outstr
	    puts $wfh $outstr
	}
    }
    close $fh
    close $wfh

    file rename -force $tn "${saveasname}"
    file delete -force $wfh
}