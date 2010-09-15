///////////////////////////////////////////////////////////////-*-C-*-
//
// Copyright (c) 2007 Xilinx, Inc.  All rights reserved.
//
// Xilinx, Inc.  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
// "AS IS" AS  A COURTESY TO YOU.  BY PROVIDING  THIS DESIGN, CODE, OR
// INFORMATION  AS  ONE   POSSIBLE  IMPLEMENTATION  OF  THIS  FEATURE,
// APPLICATION OR  STANDARD, XILINX  IS MAKING NO  REPRESENTATION THAT
// THIS IMPLEMENTATION  IS FREE FROM  ANY CLAIMS OF  INFRINGEMENT, AND
// YOU ARE  RESPONSIBLE FOR OBTAINING  ANY RIGHTS YOU MAY  REQUIRE FOR
// YOUR  IMPLEMENTATION.   XILINX  EXPRESSLY  DISCLAIMS  ANY  WARRANTY
// WHATSOEVER  WITH RESPECT  TO  THE ADEQUACY  OF THE  IMPLEMENTATION,
// INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR REPRESENTATIONS THAT
// THIS IMPLEMENTATION  IS FREE  FROM CLAIMS OF  INFRINGEMENT, IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
// 
//////////////////////////////////////////////////////////////////////

#include "ssp_ad_scan_plbw.h"
#include "xparameters.h"
#include "xcope.h"

inline xc_status_t xc_ssp_ad_scan_plbw_create(xc_iface_t **iface, void *config_table)
{
    // set up iface
    *iface = (xc_iface_t *) config_table;

#ifdef XC_DEBUG
    SSP_AD_SCAN_PLBW_Config *_config_table = config_table;

    if (_config_table->xc_create == NULL) {
        print("config_table.xc_create == NULL\r\n");
        exit(1);
    }
#endif

    // does nothing
    return XC_SUCCESS;
}

inline xc_status_t xc_ssp_ad_scan_plbw_release(xc_iface_t **iface) 
{
    // does nothing
    return XC_SUCCESS;
}

inline xc_status_t xc_ssp_ad_scan_plbw_open(xc_iface_t *iface)
{
    // does nothing
    return XC_SUCCESS;
}

inline xc_status_t xc_ssp_ad_scan_plbw_close(xc_iface_t *iface)
{
    // does nothing
    return XC_SUCCESS;
}

inline xc_status_t xc_ssp_ad_scan_plbw_read(xc_iface_t *iface, xc_r_addr_t addr, uint32_t *value)
{
    *value = *((uint32_t *) addr);
    return XC_SUCCESS;
}

inline xc_status_t xc_ssp_ad_scan_plbw_write(xc_iface_t *iface, xc_w_addr_t addr, const uint32_t value)
{
    *((uint32_t *) addr) = value;
    return XC_SUCCESS;
}

xc_status_t xc_ssp_ad_scan_plbw_getshmem(xc_iface_t *iface, const char *name, void **shmem)
{
    SSP_AD_SCAN_PLBW_Config *_config_table = (SSP_AD_SCAN_PLBW_Config *) iface;

    if (strcmp("Control", name) == 0) {
        *shmem = (void *) & _config_table->Control;
    } else if (strcmp("NAvg", name) == 0) {
        *shmem = (void *) & _config_table->NAvg;
    } else if (strcmp("NetSamples", name) == 0) {
        *shmem = (void *) & _config_table->NetSamples;
    } else if (strcmp("TriggerLevel", name) == 0) {
        *shmem = (void *) & _config_table->TriggerLevel;
    } else if (strcmp("NCoadd", name) == 0) {
        *shmem = (void *) & _config_table->NCoadd;
    } else if (strcmp("SrcSignal", name) == 0) {
        *shmem = (void *) & _config_table->SrcSignal;
    }
    else { *shmem = NULL; return XC_FAILURE; }

    return XC_SUCCESS;
}
