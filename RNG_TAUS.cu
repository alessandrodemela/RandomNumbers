#include "RNG_TAUS.hu"

__host__ __device__ RNG_TAUS::RNG_TAUS(int seed, unsigned int K1, unsigned int K2, unsigned int K3, unsigned int M): _K1(K1), _K2(K2), _K3(K3), _M(M){
    _seed = seed + 128;
}


__host__ __device__ double RNG_TAUS::get_uniform(){
    unsigned int b = (((_seed << _K1) ^ _seed) >> _K2);
    unsigned int Si = (((_seed & _M) << _K3) ^ b);
    _seed = Si;
    return Si;
}
