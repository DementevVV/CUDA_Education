#include <stdio.h>
#include <iostream>
// размер грида
#define DGX 4
#define DGY 8

// размер блока
#define DBX 2
#define DBY 2
#define DBZ 2

// общее количество параллельных процессов: 4*8*2*2*2 = 256
#define N (DBX*DBY*DBZ*DGX*DGY)

__global__ void kern( float *a ) {
  int bs = blockDim.x*blockDim.y*blockDim.z;
  int idx = threadIdx.x + threadIdx.y*blockDim.x + threadIdx.z*(blockDim.x*blockDim.y) + blockIdx.x*bs + blockIdx.y*bs*gridDim.x ;
  if(idx > N-1) return;
  a[idx] -= 0.5f;
}

int main() {
  float host_a[N], host_c[N];
  float *dev_a;
  srand((unsigned int)time(NULL));
  for(int i=0; i<N; i++) {
    host_a[i] = (float)rand()/(float)RAND_MAX - 0.5f;
  }
  cudaMalloc((void**)&dev_a, N * sizeof(float));
  cudaMemcpy(dev_a, host_a, N * sizeof(float), cudaMemcpyHostToDevice);
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  dim3  blocks(DGX,DGY);
  dim3  threads(DBX,DBY,DBZ);
  cudaEventRecord(start);
  kern<<<blocks,threads>>>( dev_a );
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  cudaMemcpy(host_c, dev_a, N * sizeof(float), cudaMemcpyDeviceToHost);
  for (int i=0; i<N; i++) {
    if(host_a[i]-0.5f != host_c[i]) printf( "[%d]\t %.2f -> %.2f\n",i, host_a[i], host_c[i] );
  }
  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);
  std::cout << "CUDA time simple (ms): " << milliseconds << std::endl;
  cudaFree( dev_a ) ; return 0;
}
