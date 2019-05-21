#COMPILE=gcc
COMPILE=nvcc

random: random.o RNG_TAUS.o RNG_COMB.o RNG_LCG.o CombinedGenerator.o
	nvcc -o $@ $^ 
%.o: %.cu %.hu
	$(COMPILE) -dc $< -I.
random.o: random.cu 
	$(COMPILE) -dc $< -I.
CombinedGenerator.o: CombinedGenerator.cu
	$(COMPILE) -dc $< -I.

clean:
	rm *.o

