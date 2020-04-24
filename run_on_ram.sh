#!/bin/bash
echo -e "[BEGIN]\n"
#GCC FLAGS
echo -e "Setting cpupower to 4600000\n"
sudo cpupower frequency-set -u 4600000

echo -e "Settinng cpu high performance\n"
sudo cpupower frequency-set -g performance

FLAG[0]="-O2"
FLAG[1]="-O3"
FLAG[2]="-O3 -march=native"
echo -e "Running GCC FLAGS\n"
mkdir -p "RAM_results/GCC/data"
for i in 0  # {0..2}
do
    echo -e "****## Running with flag: ${FLAG[$i]}"

    for new_variant in ram_loop_blocking
        do
        echo -e "****## VARIANT: $new_variant"
            #
            
            
            #echo -e "***\nmaqao results for this flag is in directry: GCC_OPT$i"
            echo -e "\Calling make"
            
            #Compile variant
            make $new_variant CC=gcc OPTFLAGS="${FLAG[$i]}"

            #   RAM
            #echo -e "Runnning likwid for this flag on RAM"
            #likwid-perfctr -g MEM ./app 6476 201 1 taskset -c S0:0 > "GCC_OPT"$i/likwid_MEM_results.txt
            #echo -e "Runnning maqao for this flag on LRAM"
            #maqao oneview --create-report=one binary=app -xp="GCC_OPT$i/maqao_RAM_RESULTS" lprof_params="--use-OS-timers"  run_command="<binary>  6476 201 1" pinning_command="taskset -c 0"
            ./app  6476 201 1
            mv data_results RAM_results/GCC/data/"$new_variant${FLAG[$i]}"
            make clean
        done
    #gnuplot -c "plot_inv_all.gp" > "plot_all.png" 
    
    
done
exit 1
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

   
    #   RAM
    echo -e "Runnning likwid for this flag on RAM"
    likwid-perfctr -g MEM ./app 6476 201 1 taskset -c S0:0 > "ICC_OPT"$i/likwid_MEM_results.txt
    echo -e "Runnning maqao for this flag on LRAM"
    maqao oneview --create-report=one binary=app -xp="ICC_OPT$i/maqao_RAM_RESULTS" run_command="<binary>  6476 201 1" pinning_command="taskset -c 0"
    
done
#
make clean

echo -e "\n[DONE]"
