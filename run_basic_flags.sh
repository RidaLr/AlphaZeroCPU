#!/bin/bash

echo -e "[BEGIN]\n"
#GCC FLAGS
echo -e "Setting cpupower to 4600000\n"
cpupower frequency-set -u 4600000

echo -e "Settinng cpu high performance\n"
cpupower frequency-set -g performance

FLAG[0]="-O2"
FLAG[1]="-O3"
FLAG[2]="-O3 -march=native"
echo -e "Running GCC FLAGS\n"
for i in {0..2}
do
    #
    mkdir -p "GCC_OPT"$i
    echo -e "****## Running with flag: ${FLAG[$i]}"
    echo -e "***\nmaqao results for this flag is in directry: GCC_OPT$i"
    echo -e "\Calling make"
	
	#Compile variant
	make OPT="OPT$i" CC=gcc OPTFLAGS="${FLAG[$i]}"

    #   L1
    echo -e "Runnning likwid for this flag on L1 (You may need to type password)"
    sudo likwid-perfctr -g TLB_INSTR ./app 172 300 600 taskset -c S0:0 > "GCC_OPT"$i/likwid_L1_results
    echo -e "Runnning maqao for this flag on L1"
    maqao oneview --create-report=one binary=app -xp="GCC_OPT$i/maqao_L1_RESULTS" lprof_params="--use-OS-timers"  run_command="<binary>  172 300 600" pinning_command="taskset -c 0"
    
    
    #   L2
    echo -e "Runnning likwid for this flag on L2"
    sudo likwid-perfctr -g L2CACHE ./app 324 300 600 taskset -c S0:0 > "GCC_OPT"$i/likwid_L2_results.txt
    echo -e "Runnning maqao for this flag on L2"
    maqao oneview --create-report=one binary=app -xp="GCC_OPT$i/maqao_L2_RESULTS" lprof_params="--use-OS-timers"  run_command="<binary>  324 300 600" pinning_command="taskset -c 0"

    #   L3
    echo -e "Runnning likwid for this flag on L3"
    likwid-perfctr -g L3CACHE ./app 724 300 600 taskset -c S0:0 > "GCC_OPT"$i/likwid_L3_results.txt
    echo -e "Runnning maqao for this flag on L3"
    maqao oneview --create-report=one binary=app -xp="GCC_OPT$i/maqao_L3_RESULTS" lprof_params="--use-OS-timers"  run_command="<binary>  724 300 600" pinning_command="taskset -c 0"

    #   RAM
    echo -e "Runnning likwid for this flag on RAM"
    likwid-perfctr -g MEM ./app 14654 5 10 11 taskset -c S0:0 > "GCC_OPT"$i/likwid_MEM_results.txt
    echo -e "Runnning maqao for this flag on LRAM"
    maqao oneview --create-report=one binary=app -xp="GCC_OPT$i/maqao_RAM_RESULTS" lprof_params="--use-OS-timers"  run_command="<binary>  14654 5 10 11" pinning_command="taskset -c 0"
    
    
done

#ICC FLAGS
FLAG[0]="-O2"
FLAG[1]="-O3"
FLAG[2]="-O3 -xHost"
echo -e "Running ICC FLAGS\n"
for i in {0..2}
do
#
    mkdir -p "ICC_OPT"$i
    echo -e "****## Running with flag: ${FLAG[$i]}"
    echo -e "***\nmaqao results for this flag is in directry: ICC_OPT$i"
    echo -e "\Calling make"
	
	#Compile variant
	make OPT="OPT$i" CC=icc OPTFLAGS="${FLAG[$i]}"

    #   L1
    echo -e "Runnning likwid for this flag on L1 (You may need to type password)"
    sudo likwid-perfctr -g TLB_INSTR ./app 172 300 600 taskset -c S0:0 > "ICC_OPT"$i/likwid_L1_results
    echo -e "Runnning maqao for this flag on L1"
    maqao oneview --create-report=one binary=app -xp="ICC_OPT$i/maqao_L1_RESULTS" run_command="<binary>  172 300 600" pinning_command="taskset -c 0"
    
    
    #   L2
    echo -e "Runnning likwid for this flag on L2"
    sudo likwid-perfctr -g L2CACHE ./app 324 300 600 taskset -c S0:0 > "ICC_OPT"$i/likwid_L2_results.txt
    echo -e "Runnning maqao for this flag on L2"
    maqao oneview --create-report=one binary=app -xp="ICC_OPT$i/maqao_L2_RESULTS" run_command="<binary>  324 300 600" pinning_command="taskset -c 0"

    #   L3
    echo -e "Runnning likwid for this flag on L3"
    likwid-perfctr -g L3CACHE ./app 724 300 600 taskset -c S0:0 > "ICC_OPT"$i/likwid_L3_results.txt
    echo -e "Runnning maqao for this flag on L3"
    maqao oneview --create-report=one binary=app -xp="ICC_OPT$i/maqao_L3_RESULTS" run_command="<binary>  724 300 600" pinning_command="taskset -c 0"

    #   RAM
    echo -e "Runnning likwid for this flag on RAM"
    likwid-perfctr -g MEM ./app 14654 5 10 11 taskset -c S0:0 > "ICC_OPT"$i/likwid_MEM_results.txt
    echo -e "Runnning maqao for this flag on LRAM"
    maqao oneview --create-report=one binary=app -xp="ICC_OPT$i/maqao_RAM_RESULTS" run_command="<binary>  14654 5 10 11" pinning_command="taskset -c 0"
    
done
#
make clean

echo -e "\n[DONE]"