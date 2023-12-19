/* calc.c

   Demonstrates using the function imported from the DLL.
*/

#include <stdlib.h>
#include <stdio.h>
#include "calcdll.h"

int main() {
  int a, b, c, d;
  
  a = Add(10, 5);
  printf("L'addition de 10 plus 5 vaut :       %d\n", a);

  b = Subtract(10, 5);
  printf("La soustraction de 10 moins 5 vaut : %d\n", b);

  c = Divide(10, 5);
  printf("Là division de 10 par 5 vaut :       %d\n", c);

  d = Multiply(10, 5);
  printf("La multiplication de 10 par 5 vaut : %d\n", d);

  return 0;
}