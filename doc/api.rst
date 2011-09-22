Basic PS/2 interface
--------------------

API
===

.. doxygentype:: ps2state

.. doxygenfunction:: ps2HandlerInit

.. doxygenfunction:: ps2Handler

.. doxygenfunction:: ps2Interpret

.. doxygenfunction:: ps2USB

.. doxygenfunction:: ps2ASCII



Example
=======


An example program is shown below::

  on stdcore[0]: port ps2_clock = XS1_PORT_1A;
  on stdcore[0]: port ps2_data = XS1_PORT_1L;

  int main(void) {
    unsigned action, key, modifier;
    struct ps2state state;

    ps2HandlerInit(state);

    while (1) {
        ps2Handler(ps2_clock, ps2_data, state);
        {action, modifier, key} = ps2Interpret(state);
        if (action == PS2_PRESS) {
            printf("Modifiers 0x%02x press %d\n", modifier, key);
        } else if (action == PS2_RELEASE) {
            printf("Modifiers 0x%02x release %d\n", modifier, key);
        }
    }
  }

