#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <emmintrin.h>

#define MIB 1048576 // 1 Mib = 1024 Kib = 1024 B * 1024 B = 1048576 B
#define KIB 1024 // 1 Kib = 1024 B

typedef unsigned long long u64;

extern float OPT1(unsigned n, double *a[]);
extern float OPT2(unsigned n, double *a[]);
double **InitAndFillMatrix(unsigned n);
void displayMAtrix(int n, double **tab);
extern uint64_t rdtsc ();
extern float baseline(unsigned n, double *a[]);



int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Error\n");
        printf("Usage: %s [ArraySIze] \n", argv[0]);
        exit(EXIT_FAILURE);
    }
    unsigned long long int taille;
    taille = atoi(argv[1]);   


    /*  BASELINE  */
    clock_t start, end, startU, endU;
    double time_elapsed,time_elapsedU;

    double **tab = InitAndFillMatrix(taille);

    start = clock();
    float sum = baseline(taille, tab);
    end = clock();
    time_elapsed = ((double) (end - start)) / CLOCKS_PER_SEC;
    //displayMAtrix(taille, tab);

    /*  OPTIMIZATION WITH UNROLLING LOOP  */
    /*startU = clock();
    float sumU = OPT1(taille, tab);
    printf("here////\n");
    endU = clock();
    time_elapsedU = ((double) (endU - startU)) / CLOCKS_PER_SEC;*/
    
    //displayMAtrix(taille, tab);
    printf("SUM      = %f \n", sum);
   // printf("SUMOPT 1 = %f \n", sumU);
    printf("TIME ELAPSED ORIGINAL VERSION IS  %f\n",time_elapsed);
    //printf("TIME ELAPSED UNROLLING VERSION IS %f\n",time_elapsedU);

    return 0;
}

double **InitAndFillMatrix(unsigned n)
{
    double **array = (double **)malloc(sizeof(double *) * n);
    for (unsigned i = 0; i < n; i++)
    {
        array[i] = (double *)malloc(sizeof(double) * n);

        for (unsigned j = 0; j < n; j++)
        {
            double randed = (double) rand() / RAND_MAX + (rand() % 100);
            array[i][j] = randed;
        }
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
