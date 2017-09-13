onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -pli "/opt/Xilinx/Vivado/2015.4/lib/lnx64.o/libxil_vsim.so" -lib xil_defaultlib ccc_design_opt

do {wave.do}

view wave
view structure
view signals

do {ccc_design.udo}

run -all

quit -force
