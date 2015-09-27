/* nfd.c ***************************************************************************
**
** Normalized Frequency Difference calculator for two discrete ranked distributions
** 
** @param: v1 (uint32_t) the first distribution
** @param: v2 (uint32_t) the second distribution
** @param: v1s (uint32_t) length of the first distribution
** @param: v2s (uint32_t) length of the second distribution
** @return: (float) the normalized frequency difference
**
** @author: dimitris alikaniotis (da352@cam.ac.uk)
** @@
************************************************************************************/

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <R.h>

#define MAX(x, y) x>=y ? x : y
#define MIN(x, y) x<=y ? x : y

void nfd(int *v1, int *v2, int *v1s, int *v2s, int *vec, double *ans) {
  int a, sumvec=0;
  int min = MIN(*v1s, *v2s);
  int max = MAX(*v2s, *v2s);
  int sum = 0;
  
  for (a=0; a<min; a++) {
    vec[a] = abs(v1[a] - v2[a]);
    sum += (v1[a] + v2[a]);
    sumvec += sum;
  }
  
  if (*v1s > *v2s) {
    for (; a<*v1s; a++) {
      vec[a] = v1[a];
      sum += v1[a];
      sumvec += vec[a];
    }
  } else {
    for (; a<*v2s; a++) {
      vec[a] = v2[a];
      sum += v2[a];
      sumvec += vec[a];
    }
  }

  *ans = (double) sumvec / sum;
}
