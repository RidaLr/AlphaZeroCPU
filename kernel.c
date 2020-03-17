#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <time.h>
#include <emmintrin.h>

typedef unsigned long long u64;
float baseline(unsigned n, double *a[]);
float OPT1(unsigned n, double *a[]);
float OPT2(unsigned n, double *a[]);
double **InitAndFillMatrix(unsigned n);
void displayMAtrix(int n, double **tab);

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

/* baseline version */
float baseline(unsigned n, double *a[])
{
    unsigned i, j;
    float s = 0.0;
    for (j = 0; j < n; j++)
        for (i = 0; i < n; i++)
            s += a[i][j];
    return s;
}

/* loop unrolling OPTIMIZATION */
float OPT1(unsigned n, double *a[])
{
    unsigned i, j, k, l;
    float s = 0.0;
    u64 new_n = n - (n%2);
    for (j = 0; j < n; j+=4)
        for (i = 0; i < n; i++)
            
            s += a[i][j] + a[i][j+1] + a[i][j+2] + a[i][j+3]; printf("i j\n");

    for (k = new_n; k < n; k++)
        for (l = new_n; l < n; l++)
            s += a[k][l]; 
            printf("new_n = %lld \n",new_n);
    return s;
}

/* OPT2 */
float OPT2(unsigned n, double *a[])
{
    unsigned i, j;
    float s = 0.0;
    //TODO
    return s;
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
