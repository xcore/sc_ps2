PS2 functions
.............

:Stable release:  unreleased

:Status: draft

:Maintainer:  http://github.com/henkmuller

:Description:  This repo contains functions to interface to ps2 devices


Key Features
============

* Functions to interpret PS2 keyboard data.

To Do
=====

* PS2 to ASCII translation
* PS2 mice

Firmware Overview
=================

This repo contains a set of functions to interface PS2 devices (this
software acts as the PC, it can talk to, for example, a keyboard).
Three levels of interface are provided: a bit banging select function,
a function that interprets the PS2 keyboard press/release protocol,
and tranlsation functions from PS2 keycodes to USB keycodes.

Known Issues
============

* needs testing.

Required Repositories
================

* xcommon git\@github.com:xcore/xcommon.git

Support
=======

Raise an issue, or fork and do a pull-request.
