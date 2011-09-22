// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "ps2.h"

static char ps2lookupUSB[0x85] = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x2b, 0x35, 0x00,
    0x00, 0xe0, 0x02, 0x00, 0x39, 0x14, 0x1e, 0x00,
    0x00, 0x00, 0x1d, 0x16, 0x04, 0x1a, 0x1f, 0x00,
    0x00, 0x06, 0x1b, 0x07, 0x08, 0x21, 0x20, 0x00,
    0x00, 0x2c, 0x19, 0x09, 0x17, 0x15, 0x22, 0x00,
    0x00, 0x11, 0x05, 0x0b, 0x0a, 0x1c, 0x23, 0x00,
    0x00, 0x00, 0x10, 0x0d, 0x18, 0x24, 0x25, 0x00,
    0x00, 0x36, 0x0E, 0x0C, 0x12, 0x27, 0x26, 0x00,
    0x00, 0x37, 0x38, 0x0F, 0x33, 0x13, 0x2D, 0x00,
    0x00, 0x00, 0x34, 0x00, 0x2F, 0x2E, 0x00, 0x00,
    0xE4, 0xE5, 0x28, 0x30, 0x00, 0x31, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2A, 0x00,
    0x00, 0x59, 0x00, 0x5C, 0x5F, 0x00, 0x00, 0x00,
    0x62, 0x63, 0x5A, 0x5D, 0x5E, 0x60, 0x53, 0x54,
    0x00, 0x58, 0x5B, 0x85, 0x57, 0x61, 0x55, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x56,
};

static char ps2lookupASCII[0x85] = {
    0
    // todo: ascii lookup table
};

int ps2USB(unsigned int value) {
    return value < sizeof(ps2lookupUSB) ? ps2lookupUSB[value] : -1;
}

int ps2ASCII(unsigned int modifier, unsigned int value) {
    // todo: modifier interpretation
    return value < sizeof(ps2lookupASCII) ? ps2lookupASCII[value] : -1;
}
