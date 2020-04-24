#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <emmintrin.h>
#include <time.h>
#include <unistd.h>

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

int main(int argc, char *argv[])
{
    if (argc < 4)
    {
        printf("Error\n");
        printf("Usage: %s [ArraySIze] [number warmup repets] [number measure repets] \n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int i, j, k;

    unsigned long long int arr_size = atoi(argv[1]); // Size of array
    unsigned long long int repwarm = atoi(argv[2]);  // Number of warmup repetitions
    unsigned long long int repmeas = atoi(argv[3]);  // Number of measure repetitions

    uint64_t *tab_rdtsc = (uint64_t *)malloc(sizeof(uint64_t) * NB_META);          // médianes RDTSC pour un warmup
    uint64_t *tab_medianes_rdtsc = (uint64_t *)malloc(sizeof(uint64_t) * repwarm); // NBRE_META médianes pour tous les warmup
    FILE *fp;

    fp = fopen("find_good_warmups_values.txt", "w");
    for (k = 1; k <= repwarm; k += 10)
    {

        int current_repwarm = k;
        for (j = 0; j < NB_META; j++)
        {
            double(*a)[arr_size] = malloc(arr_size * arr_size * sizeof a[0][0]);
            srand(0);
            init_array(arr_size, a);

            /* warmup (repw repetitions in first meta, 1 repet in next metas) */

            for (i = 0; i < current_repwarm; i++)
                baseline(arr_size, a);

            double time_spent = 0.0;

            clock_t begin = clock();

            /* measure repm repetitions */
            uint64_t t1 = rdtsc();
            for (i = 0; i < repmeas; i++)
                baseline(arr_size, a);
            uint64_t t2 = rdtsc();

            clock_t end = clock();
            //printf("---------------------------\n");
            /* print performance */
            //printf("%.2f cycles/itérations\n",
              //     (t2 - t1) / ((float)arr_size * arr_size * repmeas));

            time_spent += (double)(end - begin) / CLOCKS_PER_SEC;

            //printf("Time with clock() = %f\n", time_spent);

            tab_rdtsc[j] = t2 - t1;
            //printf("RDTSC = %ld\n", tab_rdtsc[j]);

            // free array
            free(a);
            usleep(100 * 1000);
        }
        sort(tab_rdtsc, NB_META);
        //printf("[Stabilité des mesures = %f%%] mediane=%ld min = %ld max = %ld INDEX_mediane = %d\n", (float)((float)(tab_rdtsc[(int)(NB_META / 2)] - tab_rdtsc[0]) / tab_rdtsc[0]), tab_rdtsc[(int)(NB_META / 2)], tab_rdtsc[0], tab_rdtsc[NB_META - 1], (int)(NB_META / 2));
        //printf("RDTSC sur mediane = %ld\n", tab_rdtsc[(int)(NB_META / 2)]);
        tab_medianes_rdtsc[k] = tab_rdtsc[(int)(NB_META / 2)];
        printf("Mediane RDTSC sur repw = %d = %ld\n", current_repwarm, tab_medianes_rdtsc[k]);
        fprintf(fp, "%d | %ld\n", k, tab_medianes_rdtsc[k]);
    }

    fclose(fp);
    return EXIT_SUCCESS;
}

static void init_array(int n, double a[n][n])
{
    int i, j;

    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
            a[i][j] = (double)rand() / RAND_MAX;
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
