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
#define NB 31

typedef unsigned long long u64;

double **InitAndFillMatrix(unsigned n);
void displayMAtrix(int n, double **tab);
extern uint64_t rdtsc ();
extern float baseline(unsigned n, double *a[]);



int main(int argc, char *argv[])
{
    if (argc != 4)
    {
        printf("Error\n");
        printf("Usage: %s [ArraySIze] [number warmup repets] [number measure repets] \n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int i, j;

   
   unsigned long long int size = atoi (argv[1]); // Size
   unsigned long long int repw = atoi (argv[2]); // Number of repetitions 
   unsigned long long int repm = atoi (argv[3]); // Number of measure repetitions
    //double **a= InitAndFillMatrix(0);
   for (j=0; j < NB; j++) {
      //Dynamic allocation
     // double (*a)[size] = malloc (size * size * sizeof a[0][0]);

      srand(0);
      double **a=InitAndFillMatrix (size);

      /* warmup (repw repetitions in first meta, 1 repet in next metas) */
      if (j == 0) {
         for (i=0; i<repw; i++)
            baseline (size, a);
      } else {
         baseline (size, a);
      }

      /* measure repm repetitions */
      uint64_t t1 = rdtsc();
      for (i=0; i<repm; i++)
         baseline (size, a);
      uint64_t t2 = rdtsc();

      /* print performance */
      printf ("%.2f cycles/FMA\n",
              (t2 - t1) / ((float) size * size * size * repm));

      // free array
      free (a);
   }

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
