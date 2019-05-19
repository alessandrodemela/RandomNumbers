#include <iostream>
#include <cstdlib>
#include <ctime>
#include <vector>
#include "RNG_LCG.hu"
#include "RNG_TAUS.hu"
#include "RNG.hu"
#include "RNG_COMB.hu"

using namespace std;

#define N_PASSI 5 //N_PASSI indica quanti numeri casuali genera ogni thread

struct thread_seed{
    double a, b, c, d;

    thread_seed(){
        a = rand();
        b = rand();
        c = rand();
        d = rand();
    }
};
/*
__global__ void CombinedGenerator(thread_seed* v_thread_seed, double* dev_average_thread){
    unsigned int tid = blockIdx.x * blockDim.x + threadIdx.x;

    RNG* rng_Comb = new RNG_COMB(v_thread_seed[tid].a, v_thread_seed[tid].b, v_thread_seed[tid].c, v_thread_seed[tid].d);

	double sum = 0;
    for(int i=0; i<N_PASSI; i++){
        sum += rng_Comb->get_uniform();
    }
	dev_average_thread[tid] = sum/N_PASSI;
}
*/

int main(int argc, char**argv){
    int N = atoi(argv[1]);                     //N e' il numero di scenari generato
    srand(time(0));

    thread_seed* v_thread_seed = new thread_seed[N];
    RNG* rng_Lcg1 = new RNG_LCG(v_thread_seed[0].a);
    RNG* rng_Lcg2 = new RNG_LCG(v_thread_seed[0].b);
    RNG* rng_Lcg3 = new RNG_LCG(v_thread_seed[0].c);
    RNG* rng_Lcg4 = new RNG_LCG(v_thread_seed[0].d);
  
    thread_seed* dev_v_thread_seed = new thread_seed[N];

    double average_thread[N];             //Vettore di medie per ogni thread
    double* dev_average_thread;

    for(int i=0; i<N; i++){
        v_thread_seed[i].a = rng_Lcg1->get_uniform();
        v_thread_seed[i].b = rng_Lcg2->get_uniform();
        v_thread_seed[i].c = rng_Lcg3->get_uniform();
        v_thread_seed[i].d = rng_Lcg4->get_uniform();
    }

    int THREADS_PER_BLOCK = 1024;
    int N_BLOCK = N/1024 + 1;
    
/*  SIMULAZIONE KERNEL FUNZIONA SU CPU */
	double average_thread[N];
    RNG* rng_Comb;
    for(int tid = 0; tid<N; tid++){
		rng_Comb = new RNG_COMB(v_thread_seed[tid].a, v_thread_seed[tid].b, v_thread_seed[tid].c, v_thread_seed[tid].d);

		double sum = 0;
		for(int i=0; i<N_PASSI; i++){
		    sum += rng_Comb->get_uniform();
		}
		average_thread[tid] = sum/N_PASSI;
	}

/*
    cudaMalloc((void**)&dev_v_thread_seed,N*sizeof(thread_seed));
    cudaMalloc((void**)&dev_average_thread,N*sizeof(double));

    cudaMemcpy(dev_v_thread_seed,v_thread_seed,N*sizeof(thread_seed),cudaMemcpyHostToDevice);

    CombinedGenerator<<<N_BLOCK,THREADS_PER_BLOCK>>>(dev_v_thread_seed, dev_average_thread);

    cudaMemcpy(average_thread,dev_average_thread,N*sizeof(double),cudaMemcpyDeviceToHost);


    for(int i=0; i<N; i++){
            cout<<average_thread[i]<<" "<<endl;
    }

	cudaFree(dev_v_thread_seed);
	cudaFree(dev_average_thread);
*/
}


