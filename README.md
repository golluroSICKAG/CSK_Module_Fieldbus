# CSK_Module_Fieldbus

Module to provide field bus access. It is intended for field bus slave devices and allows them exchange data with a PLC. It currently only implements PROFINET and EtherNet/IP. 

![](./docu/media/UI_Screenshot.png)

## How to Run

The app includes an intuitive GUI to setup the fieldbus communication.  
For further information check out the [documentation](https://raw.githack.com/golluroSICKAG/CSK_Module_Fieldbus/main/docu/CSK_Module_Fieldbus.html) in the folder "docu".

## Information

Tested on:
|Device|Firmware|Module version|
|--|--|--|
|SIM 2x00|V1.8.0|V1.0.0|
|SIM 2x00|V1.8.0|V0.1.1|
|SIM 2x00|V1.5.0|V0.1.0|

This module is part of the SICK AppSpace Coding Starter Kit developing approach.  
It is programmed in an object-oriented way. Some of the modules use kind of "classes" in Lua to make it possible to reuse code / classes in other projects.  
In general, it is not neccessary to code this way, but the architecture of this app can serve as a sample to be used especially for bigger projects and to make it easier to share code.  
Please check the [documentation](https://github.com/SICKAppSpaceCodingStarterKit/.github/blob/main/docu/SICKAppSpaceCodingStarterKit_Documentation.md) of CSK for further information.  

## Topics

Coding Starter Kit, CSK, Module, SICK-AppSpace, Fieldbus, Profinet, EtherCat, Ethernet/IP, PLC
