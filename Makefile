CFLAGS=-g -Wall 

OFLAGS=-march=native

BASELINE:
	$(CC) -DBASELINE=1 $(CFLAGS) $(O) driver.c kernel.c rdtsc.c -o app -lm
ram_unrolled:
	$(CC) -DRAM_UNROLL=1 $(CFLAGS) $(O) driver.c kernel.c rdtsc.c -o app -lm
ram_loop_blocking:
	$(CC) -DRAM_LOOP_BLOCK=1 $(CFLAGS) $(O) driver.c kernel.c rdtsc.c -o app -lm

clean:
	rm -Rf *~ app
