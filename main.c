#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
float baseline(unsigned n, double *a[]);
double **InitAndFillMatrix(unsigned n);
void displayMAtrix(int n, double **tab);
int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Error\n");
        printf("Usage: %s [ArraySIze]\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    unsigned long long int taille;
    taille = atoi(argv[1]);    
    double **tab = InitAndFillMatrix(taille);
    float sum = baseline(taille, tab);
    displayMAtrix(taille, tab);
    printf("SUM = %f", sum);

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
            double randed = (rand() % 100) * 50.5;
            array[i][j] = 1.0;
        }
    }
    return array;
}
float baseline(unsigned n, double *a[])
{
    unsigned i, j;
    float s = 0.0;
    for (j = 0; j < n; j++)
        for (i = 0; i < n; i++)
            s += a[i][j];
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
