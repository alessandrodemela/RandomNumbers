#include "header.hu"


int main(int argc, char**argv){
    int N = atoi(argv[1]);                     //N e' il numero di scenari generato
    srand(time(0));

    thread_seed* v_thread_seed = new thread_seed[N];
    RNG* rng_Lcg = new RNG_LCG(rand());

    for(int i=0; i<N; i++){
        v_thread_seed[i].a = rng_Lcg->get_uniform();
        v_thread_seed[i].b = rng_Lcg->get_uniform();
        v_thread_seed[i].c = rng_Lcg->get_uniform();
        v_thread_seed[i].d = rng_Lcg->get_uniform();
    }

    thread_seed* dev_v_thread_seed = new thread_seed[N];

    double average_thread[N];             //Vettore di medie per ogni thread
    double* dev_average_thread;

    int THREADS_PER_BLOCK = 1024;
    int N_BLOCK = N/1024 + 1;

/*  SIMULAZIONE KERNEL FUNZIONA SU CPU
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
*/

    cudaMalloc((void**)&dev_v_thread_seed,N*sizeof(thread_seed));
    cudaMalloc((void**)&dev_average_thread,N*sizeof(double));

    cudaMemset(dev_average_thread,0,N*sizeof(double));

    cudaMemcpy(dev_v_thread_seed,v_thread_seed,N*sizeof(thread_seed),cudaMemcpyHostToDevice);

    int N_BLOCK = N/THREADS_PER_BLOCK + 1;
    CombinedGenerator<<<N_BLOCK,THREADS_PER_BLOCK>>>(dev_v_thread_seed, dev_average_thread);

    cudaMemcpy(average_thread,dev_average_thread,N*sizeof(double),cudaMemcpyDeviceToHost);


    for(int i=0; i<N; i++){
            cout<<average_thread[i]<<" "<<endl;
    }

	cudaFree(dev_v_thread_seed);
	cudaFree(dev_average_thread);

    delete[](v_thread_seed);
    delete(rng_Lcg);

}


