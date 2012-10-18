// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <platform.h>
#include <stdio.h>

#include "ps2.h"

on stdcore[0]: port ps2_clock = XS1_PORT_1A;
on stdcore[0]: port ps2_data = XS1_PORT_1L;

int core0main(streaming chanend c) {
    unsigned action, key, modifier;
    struct ps2state state;

    ps2HandlerInit(ps2_clock, state);

	// Loop
    while (1) {
        ps2Handler(ps2_clock, ps2_data, 0, state);
        {action, modifier, key} = ps2Interpret(state);
        if (action == PS2_PRESS || action == PS2_RELEASE) {
            c <: (unsigned char) action;
            c <: (unsigned char) modifier;
            c <: (unsigned char) key;
        }
    }
    return 0;
}

int core1main(streaming chanend c) {
    unsigned char k, x, y, z;

	// Loop
    while (1) {
    c :> x;
    c :> y;
    c :> z;
        k = ps2ASCII(y, z);
        if (x == PS2_PRESS) {
            printf("Modifiers 0x%02x press %d - %d\n", y, z, k);
        } else if (x == PS2_RELEASE) {
            printf("Modifiers 0x%02x release %d - %d\n", y, z, k);
        }
    }
    return 0;
}

int main(void) {
    streaming chan c;
    par {
        on stdcore[0]: core0main(c);
        on stdcore[1]: core1main(c);
    }
    return 0;
}
