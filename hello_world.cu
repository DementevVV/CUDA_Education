#include <stdio.h>
/*
  Hello world program with Device Code
*/
__global__ void mykernel(void) {
}

int main(void) {
  mykernel<<<1,1>>>();
  printf("Hello Cuda!\n");
  return 0;
}
