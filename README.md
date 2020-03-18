# Alpha0_CPU

Sujet 12
Etudier et optimiser la fonction C suivante: ´
float baseline (unsigned n , double a [ n ][ n ]) {
unsigned i , j ;
float s = 0.0;
for ( j =0; j < n ; j ++)
for ( i =0; i < n ; i ++)
s += a [ i ][ j ];
return s ;
}
Compilateur et options de r´ef´erence: gcc -O2 ou gcc -O3.
<br><br>

Pour compiler le projet utilisant le Makefile il faut exécuter la commande suivante : make OPT={NOOPT, OPT1 ...}
