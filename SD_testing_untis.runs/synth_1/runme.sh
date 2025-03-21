#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/tools/Xilinx/Vitis/2024.2/bin:/tools/Xilinx/Vivado/2024.2/ids_lite/ISE/bin/lin64:/tools/Xilinx/Vivado/2024.2/bin
else
  PATH=/tools/Xilinx/Vitis/2024.2/bin:/tools/Xilinx/Vivado/2024.2/ids_lite/ISE/bin/lin64:/tools/Xilinx/Vivado/2024.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/dongyunlee/Desktop/SD_unit_testing/SD_testing_untis/SD_testing_untis.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log top_level.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source top_level.tcl
