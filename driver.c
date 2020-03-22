#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <emmintrin.h>
#include <time.h>

#define MIB 1048576 // 1 Mib = 1024 Kib = 1024 B * 1024 B = 1048576 B
#define KIB 1024    // 1 Kib = 1024 B


typedef unsigned long long u64;

double **fillMatrix(double **array, int n);
void displayMAtrix(int n, double **tab);
extern uint64_t rdtsc();
extern float baseline(unsigned n, double *a[]);
void sort(uint64_t *a, int n);
int main(int argc, char *argv[])
{
    if (argc < 5)
    {
        printf("Error\n");
        printf("Usage: %s [ArraySIze] [number warmup repets] [number measure repets] [number metas] \n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int i, j;

    unsigned long long int arr_size = atoi(argv[1]); // Size
    unsigned long long int repwarm = atoi(argv[2]);  // Number of repetitions
    unsigned long long int repmeas = atoi(argv[3]);  // Number of measure repetitions
    unsigned long long int repmetas = atoi(argv[4]);  // Number of meta repetitions (real)

    uint64_t *tab_rdtsc = (uint64_t *)malloc(sizeof(uint64_t) * repmetas);
   double **a = (double **)malloc(sizeof(double *) * arr_size);;
    fillMatrix(a, arr_size);
    for (j = 0; j < repmetas; j++)
    {

        srand(0);

        /* warmup (repw repetitions in first meta, 1 repet in next metas) */
        if (j == 0)
        {
            for (i = 0; i < repwarm; i++)
                baseline(arr_size, a);
        }
        else
        {
            baseline(arr_size, a);
        }

        double time_spent = 0.0;

        clock_t begin = clock();
        /* measure repm repetitions */
        uint64_t t1 = rdtsc();
        for (i = 0; i < repmeas; i++)
            baseline(arr_size, a);
        uint64_t t2 = rdtsc();
        clock_t end = clock();
        /* print performance */
        printf("%.2f cycles/FMA\n",
               (t2 - t1) / ((float)arr_size * arr_size * repmeas));
        time_spent += (double)(end - begin) / CLOCKS_PER_SEC;
        printf("Time with clock() = %f\n", time_spent);
        tab_rdtsc[j] = t2 - t1;
    }
    
    sort(tab_rdtsc, repmetas);
    printf("[Stabilité des mesures = %f%%] mediane=%ld min = %ld max = %ld INDEX_mediane = %d\n", (float)((float)(tab_rdtsc[(int)(repmetas/2)+1] - tab_rdtsc[0]) / tab_rdtsc[0]), tab_rdtsc[(int)(repmetas/2)+1], tab_rdtsc[0], tab_rdtsc[repmetas - 1], (int)(repmetas/2)+1);
// free array
    for (int i = 0; i < arr_size; i++)
    {
        free(a[i]);
    }
    free(a);
    a = NULL;
    return 0;
}

double **fillMatrix(double **array, int n)
{
    
    for (unsigned i = 0; i < n; i++)
    {
        array[i] = (double *)malloc(sizeof(double) * n);

        for (unsigned j = 0; j < n; j++)
            array[i][j] = 1.0;
        //array[i][j] = (double) rand() / RAND_MAX + (rand() % 100);
    }
    return array;
}

void displayMAtrix(int n, double **tab)
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            printf("TAB[%d][%d] = %lf\n", i, j, tab[i][j]);
        }
    }
}
void sort(uint64_t *a, int n)
{
    for (uint64_t i = 0; i < n; i++)
        for (uint64_t j = i + 1; j < n; j++)
            if (a[i] > a[j])
            {
                uint64_t tmp = a[i];

                a[i] = a[j];
                a[j] = tmp;
            }
}