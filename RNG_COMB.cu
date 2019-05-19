#include "RNG_COMB.hu"

__host__ __device__  RNG_COMB::RNG_COMB(int Sa, int Sb, int Sc, int Sd) {
    Taus1 = new RNG_TAUS(Sa, 13, 19, 12, 4294967294UL);
    Taus2 = new RNG_TAUS(Sb, 2, 25, 4, 4294967288UL);
    Taus3 = new RNG_TAUS(Sc, 3, 11, 17, 4294967280UL);
    Lcg = new RNG_LCG(Sd);
}


__host__ __device__ double RNG_COMB::get_uniform(){
    return 2.3283064365387e-10 * ( (unsigned int)(Taus1->get_uniform()) ^ (unsigned int)(Taus2->get_uniform()) ^ (unsigned int)(Taus3->get_uniform()) ^ (unsigned int)(Lcg->get_uniform()) ); //    unsigned int perche i double sono più lunghi e magari se lo converti in int va a prendere INT_MIN perche eccedono INT_MAX
}
