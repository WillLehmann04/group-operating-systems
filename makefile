test:
	./memsim report-traces/bzip.trace 4 lru quiet > report-output/bzip-4-lru.txt
	./memsim report-traces/bzip.trace 8 lru quiet > report-output/bzip-8-lru.txt
	./memsim report-traces/bzip.trace 16 lru quiet > report-output/bzip-16-lru.txt
	./memsim report-traces/gcc.trace 4 lru quiet > report-output/gcc-4-lru.txt
	./memsim report-traces/gcc.trace 8 lru quiet > report-output/gcc-8-lru.txt
	./memsim report-traces/gcc.trace 16 lru quiet > report-output/gcc-16-lru.txt
	./memsim report-traces/sixpack.trace 4 lru quiet > report-output/sixpack-4-lru.txt
	./memsim report-traces/sixpack.trace 8 lru quiet > report-output/sixpack-8-lru.txt
	./memsim report-traces/sixpack.trace 16 lru quiet > report-output/sixpack-16-lru.txt
	./memsim report-traces/swim.trace 4 lru quiet > report-output/swim-4-lru.txt
	./memsim report-traces/swim.trace 8 lru quiet > report-output/swim-8-lru.txt
	./memsim report-traces/swim.trace 16 lru quiet > report-output/swim-16-lru.txt

	./memsim report-traces/bzip.trace 4 fifo quiet > report-output/bzip-4-fifo.txt
	./memsim report-traces/bzip.trace 8 fifo quiet > report-output/bzip-8-fifo.txt
	./memsim report-traces/bzip.trace 16 fifo quiet > report-output/bzip-16-fifo.txt
	./memsim report-traces/gcc.trace 4 fifo quiet > report-output/gcc-4-fifo.txt
	./memsim report-traces/gcc.trace 8 fifo quiet > report-output/gcc-8-fifo.txt
	./memsim report-traces/gcc.trace 16 fifo quiet > report-output/gcc-16-fifo.txt
	./memsim report-traces/sixpack.trace 4 fifo quiet > report-output/sixpack-4-fifo.txt
	./memsim report-traces/sixpack.trace 8 fifo quiet > report-output/sixpack-8-fifo.txt
	./memsim report-traces/sixpack.trace 16 fifo quiet > report-output/sixpack-16-fifo.txt
	./memsim report-traces/swim.trace 4 fifo quiet > report-output/swim-4-fifo.txt
	./memsim report-traces/swim.trace 8 fifo quiet > report-output/swim-8-fifo.txt
	./memsim report-traces/swim.trace 16 fifo quiet > report-output/swim-16-fifo.txt

	./memsim report-traces/bzip.trace 4 clock quiet > report-output/bzip-4-clock.txt
	./memsim report-traces/bzip.trace 8 clock quiet > report-output/bzip-8-clock.txt
	./memsim report-traces/bzip.trace 16 clock quiet > report-output/bzip-16-clock.txt
	./memsim report-traces/gcc.trace 4 clock quiet > report-output/gcc-4-clock.txt
	./memsim report-traces/gcc.trace 8 clock quiet > report-output/gcc-8-clock.txt
	./memsim report-traces/gcc.trace 16 clock quiet > report-output/gcc-16-clock.txt
	./memsim report-traces/sixpack.trace 4 clock quiet > report-output/sixpack-4-clock.txt
	./memsim report-traces/sixpack.trace 8 clock quiet > report-output/sixpack-8-clock.txt
	./memsim report-traces/sixpack.trace 16 clock quiet > report-output/sixpack-16-clock.txt
	./memsim report-traces/swim.trace 4 clock quiet > report-output/swim-4-clock.txt
	./memsim report-traces/swim.trace 8 clock quiet > report-output/swim-8-clock.txt
	./memsim report-traces/swim.trace 16 clock quiet > report-output/swim-16-clock.txt

	./memsim report-traces/bzip.trace 4 rand quiet > report-output/bzip-4-rand.txt
	./memsim report-traces/bzip.trace 8 rand quiet > report-output/bzip-8-rand.txt
	./memsim report-traces/bzip.trace 16 rand quiet > report-output/bzip-16-rand.txt
	./memsim report-traces/gcc.trace 4 rand quiet > report-output/gcc-4-rand.txt
	./memsim report-traces/gcc.trace 8 rand quiet > report-output/gcc-8-rand.txt
	./memsim report-traces/gcc.trace 16 rand quiet > report-output/gcc-16-rand.txt
	./memsim report-traces/sixpack.trace 4 rand quiet > report-output/sixpack-4-rand.txt
	./memsim report-traces/sixpack.trace 8 rand quiet > report-output/sixpack-8-rand.txt
	./memsim report-traces/sixpack.trace 16 rand quiet > report-output/sixpack-16-rand.txt
	./memsim report-traces/swim.trace 4 rand quiet > report-output/swim-4-rand.txt
	./memsim report-traces/swim.trace 8 rand quiet > report-output/swim-8-rand.txt
	./memsim report-traces/swim.trace 16 rand quiet > report-output/swim-16-rand.txt

ALL: compile run clean

compile:
	@gcc -o memsim memsim.c

run: 
	@./memsim traces/trace1 4 REPL_CLOCK debug

clean:
	@rm -f memsim
