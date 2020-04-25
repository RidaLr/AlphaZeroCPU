#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <time.h>
#include <assert.h>

typedef unsigned long long u64;

#ifdef RAM_UNROLL
/* RAM loop unrolling OPTIMIZATION */
float baseline(unsigned n, double a[n][n])
{
    unsigned i, j;
    double s = 0.0;
    for (j = 0; j < n; j++)
    {

        for (i = 0; i < 12; i ++)
            s += a[i][j];
        for (i = 12; i < n; i += 64)
        {
            s += a[i][j];
            s += a[i + 1][j];
            s += a[i + 2][j];
            s += a[i + 3][j];
            s += a[i + 4][j];
            s += a[i + 5][j];
            s += a[i + 6][j];
            s += a[i + 7][j];
            s += a[i + 8][j];
            s += a[i + 9][j];
            s += a[i + 10][j];
            s += a[i + 11][j];
            s += a[i + 12][j];
            s += a[i + 13][j];
            s += a[i + 14][j];
            s += a[i + 15][j];
            s += a[i + 16][j];
            s += a[i + 17][j];
            s += a[i + 18][j];
            s += a[i + 19][j];
            s += a[i + 20][j];
            s += a[i + 21][j];
            s += a[i + 22][j];
            s += a[i + 23][j];
            s += a[i + 24][j];
            s += a[i + 25][j];
            s += a[i + 26][j];
            s += a[i + 27][j];
            s += a[i + 28][j];
            s += a[i + 29][j];
            s += a[i + 30][j];
            s += a[i + 31][j];
            s += a[i + 32][j];
            s += a[i + 33][j];
            s += a[i + 34][j];
            s += a[i + 35][j];
            s += a[i + 36][j];
            s += a[i + 37][j];
            s += a[i + 38][j];
            s += a[i + 39][j];
            s += a[i + 40][j];
            s += a[i + 41][j];
            s += a[i + 42][j];
            s += a[i + 43][j];
            s += a[i + 44][j];
            s += a[i + 45][j];
            s += a[i + 46][j];
            s += a[i + 47][j];
            s += a[i + 48][j];
            s += a[i + 49][j];
            s += a[i + 50][j];
            s += a[i + 51][j];
            s += a[i + 52][j];
            s += a[i + 53][j];
            s += a[i + 54][j];
            s += a[i + 55][j];
            s += a[i + 56][j];
            s += a[i + 57][j];
            s += a[i + 58][j];
            s += a[i + 59][j];
            s += a[i + 60][j];
            s += a[i + 61][j];
            s += a[i + 62][j];
            s += a[i + 63][j];
        }
    }

    return (float)s;
}
#elif defined OPENMP
/* loop unrolling OPTIMIZATION */
float baseline(unsigned n, double a[n][n])
{
    omp_set_num_threads(8);
    unsigned i, j, k, l;
    double s = 0.0, s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0, s6 = 0.0, s7 = 0.0, s8 = 0.0;
    u64 new_n = n - (n%8);
    #pragma omp parallel for private (j)
    for (j = 0; j < new_n; j++)
    {
        for (i = 0; i < new_n; i+=8)
        {       
            s0 += a[i][j];
            s1 += a[i][j+1];
            s2 += a[i][j+2];
            s3 += a[i][j+3];
            s3 += a[i][j+4];
            s3 += a[i][j+5];
            s3 += a[i][j+6];
        }
    }
    
    #pragma omp parallel for
    for (k = new_n; k < n; k++){
        for (l = new_n; l < n; l++)
            s8 += a[k][l]; 
    }
    s = s0+s1+s2+s3+s4+s5+s6+s7+s8;
    return (float)s;
}
#elif defined RAM_LOOP_BLOCK
/* RAM loop loop blocking OPTIMIZATION */
float baseline(unsigned n, double a[n][n])
{
    unsigned ii, jj, i, j;
    double s = 0.0;
    #define TILE 2
assert(n%TILE == 0);
for (ii=0; ii<n; ii+=TILE)
    for (jj=0; jj<n; jj+=TILE)
        for(i=ii; i<ii+TILE; i++)
            for(j=jj; j<jj+TILE; j++)
                s += a[i][j];
return (float) s;
}
#else
/* baseline version */
float baseline(unsigned n, double a[n][n])
{
    unsigned i, j;
    double s = 0.0;
    for (j = 0; j < n; j++)
        for (i = 0; i < n; i++)
            s += a[i][j];
    return (float)s;
}
#endif
