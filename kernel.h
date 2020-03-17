#ifndef KERNEL_H
#define KERNEL_H


#define MIB 1048576 // 1 Mib = 1024 Kib = 1024 B * 1024 B = 1048576 B
#define KIB 1024 // 1 Kib = 1024 B
 
float baseline(unsigned n, double *a[]);
double **InitAndFillMatrix(unsigned n);
void displayMAtrix(int n, double **tab);

#endif

