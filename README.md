# Alpha0_CPU

# Pour tester le programme
- chmod +x run_basic_flags.sh
- chmod +x run_advanced_flags.sh

# Set cpupower to {max_perf}
cpupower frequency-set -u [max_perf_on_your_pc]

# Set cpu high performance
cpupower frequency-set -g performance

# lunch mesures
./run_basic_flags.sh
./run_advanced_flags.sh

Sujet 12
Etudier et optimiser la fonction C suivante: ´
float baseline(unsigned n, double a[n][n])
{
    unsigned i, j;
    double s = 0.0;
    for (j = 0; j < n; j++)
        for (i = 0; i < n; i++)
            s += a[i][j];
    return (float)s;
}
Compilateur et options de r´ef´erence: gcc -O2 ou gcc -O3.
<br><br>
