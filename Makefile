CFLAGS=-Wall
OBJS=driver.o kernel.o rdtsc.o

all:	app

app:	$(OBJS)
	$(CC) -o $@ $^

kernel.o: kernel.c
	$(CC) $(OPTFLAGS) $(CFLAGS) -D $(OPT) -c $< -o $@

clean:
	rm -rf $(OBJS) app