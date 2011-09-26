// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <print.h>
#include <stdio.h>
#include "ps2.h"


#define INT_PS2_NOTAKEY    (0xFF)
#define INT_PS2_SHIFT      (89)
#define INT_PS2_CTRL       (20)

#define INT_PS2_RELEASE    (0xF0)
#define INT_PS2_EXT        (0xE0)
#define INT_PS2_PAUSE      (0xE1)

enum {
    START_BIT = 0,
    BIT0,
    BIT1,
    BIT2,
    BIT3,
    BIT4,
    BIT5,
    BIT6,
    BIT7,
    PARITY_BIT,
    STOP_BIT
} ;

void ps2HandlerInit(struct ps2state &state) {
    state.overrunErrors = 0;
    state.parityErrors = 0;
    state.stopErrors = 0;
    state.valid = 0;
    state.bits = 0;
    state.mode = START_BIT;
    state.clockValue = 1;
    state.modifier = 0;
    state.released = 0;
}

select ps2Handler(port ps2_clock, port ps2_data, struct ps2state &state) {
case ps2_clock when pinseq(state.clockValue) :> void:
    if (state.clockValue == 0) { // seen rising edge
        ps2_data :> state.bit;
        switch(state.mode) {
        case START_BIT: 
            if (state.bit == 0) {
                state.mode = BIT0;
            }
            break;
        case BIT0:
        case BIT1:
        case BIT2:
        case BIT3:
        case BIT4:
        case BIT5:
        case BIT6:
        case BIT7:
            state.bits >>= 1;
            if (state.bit) state.bits |= 0x80;
            state.mode++;
            break;
        case PARITY_BIT:
        {
            unsigned int parity;
            parity = state.bits | state.bit<<8;
            crc32(parity, 0x1, 0);
        
            if (parity == 1) {
                state.mode = STOP_BIT;
            } else {
                state.parityErrors++;
                state.mode = START_BIT;
            }
        }
            break;
        case STOP_BIT: 
            if (state.bit == 1) {
                if (state.valid) {
                    state.overrunErrors++;
                }
                state.value = state.bits;
                state.valid = 1;
            } else {
                state.stopErrors++;
            }
            state.mode = START_BIT;
            break;
        }
    }
    state.clockValue = !state.clockValue;
    break;
}

{unsigned,unsigned,unsigned} ps2Interpret(struct ps2state &state) {
    int key, result;
    if (!state.valid) {
        return {PS2_NONE, 0, 0};
    }
    state.valid = 0;
    key = state.value;
    if (key == INT_PS2_RELEASE) {
        state.released = 1;
        result = PS2_NONE;
    } else if (key == INT_PS2_EXT) {
        state.ext = 1;
        result = PS2_NONE;
    } else {
        switch (key) {
        case INT_PS2_SHIFT:
            if (state.released) {
                state.modifier &= ~PS2_MODIFIER_SHIFT;
            } else {
                state.modifier |= PS2_MODIFIER_SHIFT;
            }
            result = PS2_NONE;
            break;
        case INT_PS2_CTRL:
            if (state.released) {
                state.modifier &= ~PS2_MODIFIER_CTRL;
            } else {
                state.modifier |= PS2_MODIFIER_CTRL;
            }
            result = PS2_NONE;
            break;
/*        case INT_PS2_EXT:
            if (state.released) {
                state.modifier &= ~PS2_MODIFIER_EXT;
            } else {
                state.modifier |= PS2_MODIFIER_EXT;
            }
            result = PS2_NONE;
            break;*/
        default:
            if (state.released) {
                result = PS2_RELEASE;
            } else {
                result = PS2_PRESS;
            }
            break;
        }
        state.released = 0;
    }
    return {result,state.modifier,key};
}
