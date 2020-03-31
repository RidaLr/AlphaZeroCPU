#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <time.h>


typedef unsigned long long u64;

#ifdef OPT1
/* loop unrolling OPTIMIZATION */
float baseline(unsigned n, double a[n][n])
{
    unsigned i, j, k, l;
    double s = 0.0;
    u64 new_n = n - (n%2);
    for (j = 0; j < new_n; j+=4)
        for (i = 0; i < new_n; i++)
            
            s += a[i][j] + a[i][j+1] + a[i][j+2] + a[i][j+3]; printf("i j\n");

    for (k = new_n; k < n; k++)
        for (l = new_n; l < n; l++)
            s += a[k][l]; 
            printf("new_n = %lld \n",new_n);
    return (float)s;
}
#elif defined OPT2


/* OPT2 */
float baseline(unsigned n, double a[n][n])
{
    unsigned i, j;
    float s = 0.0;
    //TODO
    return s;
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
