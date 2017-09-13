source /opt/Xilinx/Vivado/2015.4/settings64.sh

cp ./ccc-hw.runs/impl_1/ccc_design_wrapper.bit .

echo $? "Bit stream copied..."

cp ./ccc-hw.sdk/FSBL/Debug/FSBL.elf .

echo $? "FSBL copied..."

bootgen -w -image ccc-zybo.bif -o i BOOT.bin

echo $? "BOOT.bin generated !"
