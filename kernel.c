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
#elif defined OPT2

/* OPT2 */
float baseline(unsigned n, double a[n][n])
{
    //TODO
    return n;
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
