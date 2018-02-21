/*
  Vector addition
*/
#include <stdio.h>
#define N 128
__global__ void add( int *a, int *b, int *c ) {
  int tid = threadIdx.x;
  if(tid > N-1) return;
  c[tid] = a[tid] + b[tid];
}
int main() {
  int host_a[N], host_b[N], host_c[N];
  int *dev_a, *dev_b, *dev_c;
  for (int i=0; i<N; i++) { host_a[i] = i * i; host_b[i] = - i; }
  cudaMalloc( (void**)&dev_a, N * sizeof(int) );
  cudaMalloc( (void**)&dev_b, N * sizeof(int) );
  cudaMalloc( (void**)&dev_c, N * sizeof(int) );
  cudaMemcpy( dev_a, host_a, N * sizeof(int), cudaMemcpyHostToDevice );
  cudaMemcpy( dev_b, host_b, N * sizeof(int), cudaMemcpyHostToDevice );
  add<<<1,N>>>( dev_a, dev_b, dev_c );
  cudaMemcpy( host_c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost ) ;
  for (int i=0; i<N; i++) { printf( "%d + %d = %d\n", host_a[i], host_b[i], host_c[i] ); }
  cudaFree( dev_a ); cudaFree( dev_b ); cudaFree( dev_c );
  return 0;
}