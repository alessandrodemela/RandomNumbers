#COMPILE=gcc
COMPILE=NVCC

random: random.o RNG_TAUS.o RNG_COMB.o RNG_LCG.o
	$(COMPILE) -dc -o $@ $^ 
%.o: %.cu %.hu
	$(COMPILE) -dc $< -I.
random.o: random.cu 
	$(COMPILE) -dc $< -I.

clean:
	rm *.o

