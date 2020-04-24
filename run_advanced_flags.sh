#!/bin/bash

echo -e "[BEGIN]\n"
#GCC FLAGS
echo -e "Setting cpupower to 4600000\n"
cpupower frequency-set -u 4600000

echo -e "Settinng cpu high performance\n"
cpupower frequency-set -g performance
#GCC FLAGS
FLAG[0]="-O3 -Ofast -march=native"
FLAG[1]="-O3 -Ofast -march=native -fprefetch-loop-arrays"
FLAG[2]="-O3 -Ofast -march=native -funroll-loops -floop-parallelize-all"
echo -e "Running GCC ADVANCED FLAGS\n"
for i in {0..5}
do
    #
    mkdir -p "GCC_OPT_ADV"$i
    echo -e "****## Running with flag: ${FLAG[$i]}"
    echo -e "***\nmaqao results for this flag is in directry: GCC_OPT_ADV$i"
    echo -e "\Calling make"
	
	#Compile variant
	make OPT="OPT$i" CC=gcc OPTFLAGS="${FLAG[$i]}"

    #   RAM
    echo -e "Runnning likwid for this flag on RAM"
    likwid-perfctr -g MEM ./app 172 300 600 taskset -c S0:0 > "GCC_OPT_ADV"$i/likwid_MEM_results.txt
    echo -e "Runnning maqao for this flag on LRAM"
    maqao oneview --create-report=one binary=app -xp="GCC_OPT_ADV$i/maqao_RAM_RESULTS" lprof_params="--use-OS-timers"  run_command="<binary>  172 300 600" pinning_command="taskset -c 0"
    
    
done

#ICC FLAGS
FLAG[0]="-O3 -Ofast -xSSE4.2 -axAVX,CORE-AVX2 -x86 -c -parallel"
FLAG[1]="-O3 -Ofast -fp-model fast=2 -qopt-prefetch"
echo -e "Running ICC ADVANCED FLAGS\n"
for i in {0..2}
do
#
    mkdir -p "ICC_OPT_ADV"$i
    echo -e "****## Running with flag: ${FLAG[$i]}"
    echo -e "***\nmaqao results for this flag is in directry: ICC_OPT_ADV$i"
    echo -e "\Calling make"
	
	#Compile variant
    if [[ $i -eq 0 ]]
    then
        make OPT="OPT$i" CC=icl OPTFLAGS="${FLAG[$i]}"
    else
        if [[ $i -eq 1 ]]
            then
                make OPT="OPT$i" CC=icpc OPTFLAGS="${FLAG[$i]}"
            else
                make OPT="OPT$i" CC=icc OPTFLAGS="${FLAG[$i]}"
        fi
    fi
	

    #   RAM
    echo -e "Runnning likwid for this flag on RAM"
    likwid-perfctr -g MEM ./app 172 300 600 taskset -c S0:0 > "ICC_OPT_ADV"$i/likwid_MEM_results.txt
    echo -e "Runnning maqao for this flag on LRAM"
    maqao oneview --create-report=one binary=app -xp="ICC_OPT_ADV$i/maqao_RAM_RESULTS" run_command="<binary>  172 300 600" pinning_command="taskset -c 0"
    
done
#
make clean

echo -e "\n[DONE]"