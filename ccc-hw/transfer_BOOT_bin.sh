#!/bin/bash

if [ "$1" != "" ]; then
    echo "Updating bitstream on ZYNQ device @ $1 ... "
    scp BOOT.bin root@$1:/media/BOOT/
else
    echo "ERROR: Provide IP address of ZYNQ device."
fi