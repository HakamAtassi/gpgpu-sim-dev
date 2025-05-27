#include <stdio.h>

__global__ void hello(){
    printf("Hello, Docker!\n");
}

int main(){
    hello<<<1,1>>>();

}