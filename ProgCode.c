//*********************    File : ProgCode.c (program main test of dll, with load implicit)   *****************
// #define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include "DllCode.h"

int main(int argc, char** argv)
{
	int  aa,bb,cc;
	aa = 42;
	bb = 7;

	printf("Debut des operations avec des entiers.\n");
	
	cc = Add(aa, bb);

	printf("La somme de %i plus %i vaut %i.  (from application %s)\n", aa, bb, cc, argv[0]);

	cc = Multiply(aa, bb);

	printf("Le produit de %i par %i vaut %i. (from application %s)\n", aa, bb, cc, argv[0]);

	return EXIT_SUCCESS;
}
// ****************************************   End file : ProgCode.c   *********************************************
