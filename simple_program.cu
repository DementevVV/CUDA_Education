__global__ void kern() {
  // do nothing
}
int main() {
  kern <<< 1, 1 >>> (); 
  return 0;
}