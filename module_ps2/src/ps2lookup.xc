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
		0, //                        
		0, // F9                     
		0, //                        
		0, // F5    
		0, // F3                     
		0, // F1                     
		0, // F2                     
		0, // F12                    
		0, //                        
		0, // F10                    
		0, // F8                     
		0, // F6                     
		0, // F4                     
		0x09, // TAB                    
		0x60, // ` or |                        
		0, //                        
		0, //                        
		0, // Left ALT               
		0, //PS2_SHIFT, // Left SHIFT               
		0, //                        
		0, //PS2_CTRL, // Left Ctrl                 
		'q', // Q                              
		'1', // 1 or !                         
		0, //                        
		0, //                        
		0, //                        
		'z', // Z                              
		's', // S                              
		'a', // A                              
		'w', // W                              
		'2', // 2 or @                         
		0, //                        
		0, //                        
		'c', // C                              
		'x', // X                              
		'd', // D                              
		'e', // E                              
		'4', // 4 or $                         
		'3', // 3 or ¬£                         
		0, //                        
		0, //                        
		' ', // Space                          
		'v', // V                              
		'f', // F                              
		't', // T                              
		'r', // R                              
		'5', // 5 or %                         
		0, //                        
		0, //                        
		'n', // N                              
		'b', // B                              
		'h', // H                              
		'g', // G                              
		'y', // Y                              
		'6', // 6 or ^                         
		0, //                        
		0, //                        
		0, //                        
		'm', // M                              
		'j', // J                              
		'u', // U                              
		'7', // 7 or &                         
		'8', // 8 or *                         
		0, //                        
		0, //                        
		',', // , or <                         
		'k', // K                              
		'i', // I                              
		'o', // o                        
		'0', // 0 or ) 
		'9', // 9 or (                                    
		0, //                                      
		0, //                         
		'.', // . or >
		'/', // / or ?
		'l', // L                                              
		';', // ; or :                              
		'p', // p                         
		'-', // - or _                     
		0, //                        
		0, //                        
		0, // 
		0x27,        //  ' or @                                          
		0, //                        
		'[', // [ or {                         
		'=', // = OR +                         
		0, //                        
		0, // Caps Lock                      
		0, //PS2_CAPS, 
		0, //PS2_SHIFT, // Right Shift 
		0x0D, // Enter                     
		']', // ] or }                                     
		0, // 
		'#', // # or |                                 
		0, //                        
		0, //                        
		0, //
		'\\',        // \ or | UK KEYBOARD                                    
		0, //                        
		0, //                        
		0, //                        
		0, //
		0x08, // Backspace                                  
		0, //                        
		0, // NUM - 1 or END         
		'1', //                        
		0, // NUM - 4 or LEFT        
		'4', // NUM - 7 or HOME        
		'7', //                        
		0, //                        
		0, //                         
		'.', // NUM - . or DEL
		'0', // NUM - 0 or INS         
		'.', // NUM - 2 or DOWN        
		'2', // NUM - 5                
		'5', // NUM - 6 or RIGHT       
		'6', // NUM - 8 or UP          
		'8', // F11                       
		0x1B, // ESC    76                   
		0, //PS2_NUM, // NUM LOCK                    
		0, // NUM - + (Plus)         
		'+', // NUM 3 or PAGE DOWN     
		'3', // NUM - - (Minus)        
		'-', // NUM - *                
		'*', // NUM - 9 or PAGE UP     
		'9', // SCROLL LOCK            
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, // F7                     
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0, //                        
		0
};

int ps2USB(unsigned int value) {
    return value < sizeof(ps2lookupUSB) ? ps2lookupUSB[value] : -1;
}

int ps2ASCII(unsigned int modifier, unsigned int value) {
    value = value < sizeof(ps2lookupASCII) ? ps2lookupASCII[value] : -1;
    if (modifier & PS2_MODIFIER_SHIFT) {
        if (value >= 'a' && value <= 'z') {
            return value - 0x20;
        }
        if (value >= '1' && value <= '0') {
            return value - 0x10;
        }
        return value;
    } else if (modifier & PS2_MODIFIER_SHIFT) {
        if (value >= 'a' && value <= 'z') {
            return value - 0x60;
        }
    }
    return value;
}
