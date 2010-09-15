///////////////////////////////////////////////////////////////-*-C-*-
//
// Copyright (c) 2006 Xilinx, Inc.  All rights reserved.
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

#ifndef __XCOPE_H__
#define __XCOPE_H__

#include "xbasic_types.h"

// Basic data types
typedef char    uint8_t;
typedef Xuint16 uint16_t;
typedef Xuint32 uint32_t;

// Raw address and processing data types
typedef unsigned xc_raw_addr_t;
typedef unsigned xc_word_t;

// Read-only address data type
typedef xc_raw_addr_t xc_r_addr_t;
// Write-only address data type
typedef xc_raw_addr_t xc_w_addr_t;
// Read-Write address data type
typedef xc_raw_addr_t xc_addr_t;

typedef uint32_t xc_status_t;
// error codes between +1023 and -1024 are reserved for XCOPE use
#define XC_SUCCESS 0    // non-negative values denote ok
#define XC_FAILURE -1   // negative values denote error

typedef struct {
    int n_bits;
    xc_word_t raw_bits[0];
} xc_bits_t;

typedef struct {
    int bin_pt;
    uint32_t attr;
    xc_bits_t bits;
} xc_fix_t;

typedef uint16_t xc_id_t;

typedef struct {
    xc_r_addr_t dout;
    uint32_t  n_bits;
    uint32_t  bin_pt;
    // uint32_t  attr;
} xc_from_reg_t;

typedef struct {
    xc_addr_t din;
    uint32_t  n_bits;
    uint32_t  bin_pt;
    // uint32_t  attr;
} xc_to_reg_t;

typedef struct {
    xc_r_addr_t dout;
    xc_r_addr_t percentfull;
    xc_r_addr_t empty;
    uint32_t  n_bits;
    uint32_t  bin_pt;
    // uint32_t  attr;
} xc_from_fifo_t;

typedef struct {
    xc_w_addr_t din;
    xc_r_addr_t percentfull;
    xc_r_addr_t full;
    uint32_t  n_bits;
    uint32_t  bin_pt;
    // uint32_t  attr;
} xc_to_fifo_t;

typedef struct {
    xc_addr_t addr;
    // xc_r_addr_t *grant;
    // xc_w_addr_t *req;
    uint32_t  n_bits;
    uint32_t  bin_pt;
    // uint32_t  attr;
} xc_shram_t;

typedef struct {
    xc_from_reg_t  *from_regs;
    xc_to_reg_t    *to_regs;
    xc_from_fifo_t *from_fifos;
    xc_to_fifo_t   *to_fifos;
    xc_shram_t     *shrams;
} xc_memmap_t;

struct struct_xc_iface_t {
    uint32_t version;
    // function pointers to low-level drivers
    xc_status_t (*xc_create)(struct struct_xc_iface_t **, void *);
    xc_status_t (*xc_release)(struct struct_xc_iface_t **);
    xc_status_t (*xc_open)(struct struct_xc_iface_t *);
    xc_status_t (*xc_close)(struct struct_xc_iface_t *);
    xc_status_t (*xc_read)(struct struct_xc_iface_t *, xc_r_addr_t, uint32_t *);
    xc_status_t (*xc_write)(struct struct_xc_iface_t *, xc_w_addr_t, const uint32_t);
    xc_status_t (*xc_get_shmem)(struct struct_xc_iface_t *, const char *, void **);
    xc_from_reg_t  *from_regs;
    xc_to_reg_t    *to_regs;
    xc_from_fifo_t *from_fifos;
    xc_to_fifo_t   *to_fifos;
    xc_shram_t     *shrams;
    // optional device-specific data fields
    xc_word_t data[0];
};

typedef struct struct_xc_iface_t xc_iface_t;

// XCOPE functions
static inline xc_status_t xc_create(xc_iface_t** iface, void* config_table) {
    return ((xc_iface_t *) config_table)->xc_create(iface, config_table);
}

static inline xc_status_t xc_get_shmem(xc_iface_t* iface, const char* name, void** shmem) {
    return iface->xc_get_shmem(iface, name, shmem);
}

static inline xc_status_t xc_write(xc_iface_t* iface, xc_w_addr_t w_addr, const uint32_t data) {
    return iface->xc_write(iface, w_addr, data);
}

static inline xc_status_t xc_read(xc_iface_t* iface, xc_r_addr_t r_addr, uint32_t* data) {
    return iface->xc_read(iface, r_addr, data);
}

// XCOPE helper functions
static inline xc_raw_addr_t xc_get_addr(xc_raw_addr_t addr, uint32_t offset) {
    return addr + sizeof(xc_raw_addr_t) * offset;
}

#endif
