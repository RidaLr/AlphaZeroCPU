#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <emmintrin.h>
#include <time.h>

// Le nombre de Méta-repetitions
#define NB_META 31

typedef unsigned long long u64;

// Initialiser un tableau
static void init_array(int n, double a[n][n]);

//Afficher un tableau
void displayMAtrix(int n, double **tab);

//Permet de calculer le nombre de cycles par itérations
extern uint64_t rdtsc();

//Le noyau
extern float baseline(unsigned n, double a[n][n]);

//Permet de trier un tableau
void sort(uint64_t *a, int n);
void sort_f(float *a, int n);

int main(int argc, char *argv[])
{
    if (argc < 4)
    {
        printf("Error\n");
        printf("Usage: %s [ArraySIze] [number warmup repets] [number measure repets] \n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int i, j;

    unsigned long long int arr_size = atoi(argv[1]); // Size of array
    unsigned long long int repwarm = atoi(argv[2]);  // Number of repetitions
    unsigned long long int repmeas = atoi(argv[3]);  // Number of measure repetitions

    uint64_t *tab_rdtsc = (uint64_t *)malloc(sizeof(uint64_t) * NB_META);
    float *cycles_iter = (float *)malloc(sizeof(uint64_t) * NB_META);

    FILE *data_file = NULL;
    FILE *medianes_file = NULL;
    data_file = fopen("data_results", "w");
    medianes_file = fopen("L1_results/GCC/L1_medianes", "a");//***************************************************mmlkj

    if (data_file == NULL)
    {
        perror("Cant create ouput data file !\n");
        exit(EXIT_FAILURE);
    }
    for (j = 0; j < NB_META; j++)
    {
        double(*a)[arr_size] = malloc(arr_size * arr_size * sizeof a[0][0]);
        srand(0);
        init_array(arr_size, a);

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

        /* measure repm repetitions */
        float res = 0.0;
        uint64_t t1 = rdtsc();
        for (i = 0; i < repmeas; i++)
            res = baseline(arr_size, a);
        uint64_t t2 = rdtsc();
        printf("res = %lf\n", res);
        tab_rdtsc[j] = t2 - t1;
        /* print performance */
        printf("%.2f cycles/itérations META N° %d | rdtsc = %ld\n \n",
               (t2 - t1) / ((float)arr_size * arr_size * repmeas), j, tab_rdtsc[j]);

        //write result in file
        fprintf(data_file, "%d; %f\n", j, (t2 - t1) / ((float)arr_size * arr_size * repmeas));
        cycles_iter[j] = (t2 - t1) / ((float)arr_size * arr_size * repmeas);
        // free array
        free(a);
    }

    sort(tab_rdtsc, NB_META);
    sort_f(cycles_iter, NB_META);
    printf("[Stabilité des mesures = %f%%] mediane=%ld min = %ld max = %ld INDEX_mediane = %d\n", (float)((float)(tab_rdtsc[(int)(NB_META / 2)] - tab_rdtsc[0]) / tab_rdtsc[0]), tab_rdtsc[(int)(NB_META / 2)], tab_rdtsc[0], tab_rdtsc[NB_META - 1], (int)(NB_META / 2));
    printf("cycles/iter sur mediane = %f\n", cycles_iter[(int)(NB_META / 2)]);
    fprintf(medianes_file, "%f\n", cycles_iter[(int)(NB_META / 2)]);
    fclose(data_file);
    fclose(medianes_file);

    return EXIT_SUCCESS;
}

static void init_array(int n, double a[n][n])
{
    int i, j;

    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++){
            a[i][j] = 1.0f;//(double)rand() / RAND_MAX;
        }
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
void sort_f(float *a, int n)
{
    for (uint64_t i = 0; i < n; i++)
        for (uint64_t j = i + 1; j < n; j++)
            if (a[i] > a[j])
            {
                float tmp = a[i];

                a[i] = a[j];
                a[j] = tmp;
            }
}
