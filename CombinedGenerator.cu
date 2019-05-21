#include <header.hu>
__global__ void CombinedGenerator(thread_seed* dev_v_thread_seed, double* dev_average_thread){
    unsigned int tid = blockIdx.x * blockDim.x + threadIdx.x;

    RNG* rng_Comb = new RNG_COMB(dev_v_thread_seed[tid].a, dev_v_thread_seed[tid].b, dev_v_thread_seed[tid].c, dev_v_thread_seed[tid].d);

    double sum = 0.;
    for(int i=0; i<N_PASSI; i++){
        sum += rng_Comb->get_uniform();
    }
    dev_average_thread[tid] = sum/N_PASSI;

    delete(rng_Comb);
}
