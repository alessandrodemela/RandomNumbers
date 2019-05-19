#include "RNG_LCG.hu"

__host__ __device__  RNG_LCG::RNG_LCG(int seed): _a(1664525), _b(1013904223), _m(2147483648){
    _seed = seed;
};

__host__ __device__ double RNG_LCG::get_uniform(){
    int Si = (_a * _seed + _b) % _m;
    _seed = Si;
    return Si;
}

