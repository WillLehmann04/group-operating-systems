test:
	./memsim report-traces/bzip.trace 4 lru quiet > report-output/bzip-4-lru.txt
	./memsim report-traces/bzip.trace 6 lru quiet > report-output/bzip-6-lru.txt
	./memsim report-traces/bzip.trace 8 lru quiet > report-output/bzip-8-lru.txt
	./memsim report-traces/gcc.trace 4 lru quiet > report-output/gcc-4-lru.txt
	./memsim report-traces/gcc.trace 6 lru quiet > report-output/gcc-6-lru.txt
	./memsim report-traces/gcc.trace 8 lru quiet > report-output/gcc-8-lru.txt
	./memsim report-traces/sixpack.trace 4 lru quiet > report-output/sixpack-4-lru.txt
	./memsim report-traces/sixpack.trace 6 lru quiet > report-output/sixpack-6-lru.txt
	./memsim report-traces/sixpack.trace 8 lru quiet > report-output/sixpack-8-lru.txt
	./memsim report-traces/swim.trace 4 lru quiet > report-output/swim-4-lru.txt
	./memsim report-traces/swim.trace 6 lru quiet > report-output/swim-6-lru.txt
	./memsim report-traces/swim.trace 8 lru quiet > report-output/swim-8-lru.txt

	./memsim report-traces/bzip.trace 4 fifo quiet > report-output/bzip-4-fifo.txt
	./memsim report-traces/bzip.trace 6 fifo quiet > report-output/bzip-6-fifo.txt
	./memsim report-traces/bzip.trace 8 fifo quiet > report-output/bzip-8-fifo.txt
	./memsim report-traces/gcc.trace 4 fifo quiet > report-output/gcc-4-fifo.txt
	./memsim report-traces/gcc.trace 6 fifo quiet > report-output/gcc-6-fifo.txt
	./memsim report-traces/gcc.trace 8 fifo quiet > report-output/gcc-8-fifo.txt
	./memsim report-traces/sixpack.trace 4 fifo quiet > report-output/sixpack-4-fifo.txt
	./memsim report-traces/sixpack.trace 6 fifo quiet > report-output/sixpack-6-fifo.txt
	./memsim report-traces/sixpack.trace 8 fifo quiet > report-output/sixpack-8-fifo.txt
	./memsim report-traces/swim.trace 4 fifo quiet > report-output/swim-4-fifo.txt
	./memsim report-traces/swim.trace 6 fifo quiet > report-output/swim-6-fifo.txt
	./memsim report-traces/swim.trace 8 fifo quiet > report-output/swim-8-fifo.txt

	./memsim report-traces/bzip.trace 4 clock quiet > report-output/bzip-4-clock.txt
	./memsim report-traces/bzip.trace 6 clock quiet > report-output/bzip-6-clock.txt
	./memsim report-traces/bzip.trace 8 clock quiet > report-output/bzip-8-clock.txt
	./memsim report-traces/gcc.trace 4 clock quiet > report-output/gcc-4-clock.txt
	./memsim report-traces/gcc.trace 6 clock quiet > report-output/gcc-6-clock.txt
	./memsim report-traces/gcc.trace 8 clock quiet > report-output/gcc-8-clock.txt
	./memsim report-traces/sixpack.trace 4 clock quiet > report-output/sixpack-4-clock.txt
	./memsim report-traces/sixpack.trace 6 clock quiet > report-output/sixpack-6-clock.txt
	./memsim report-traces/sixpack.trace 8 clock quiet > report-output/sixpack-8-clock.txt
	./memsim report-traces/swim.trace 4 clock quiet > report-output/swim-4-clock.txt
	./memsim report-traces/swim.trace 6 clock quiet > report-output/swim-6-clock.txt
	./memsim report-traces/swim.trace 8 clock quiet > report-output/swim-8-clock.txt

	./memsim report-traces/bzip.trace 4 rand quiet > report-output/bzip-4-rand.txt
	./memsim report-traces/bzip.trace 6 rand quiet > report-output/bzip-6-rand.txt
	./memsim report-traces/bzip.trace 8 rand quiet > report-output/bzip-8-rand.txt
	./memsim report-traces/gcc.trace 4 rand quiet > report-output/gcc-4-rand.txt
	./memsim report-traces/gcc.trace 6 rand quiet > report-output/gcc-6-rand.txt
	./memsim report-traces/gcc.trace 8 rand quiet > report-output/gcc-8-rand.txt
	./memsim report-traces/sixpack.trace 4 rand quiet > report-output/sixpack-4-rand.txt
	./memsim report-traces/sixpack.trace 6 rand quiet > report-output/sixpack-6-rand.txt
	./memsim report-traces/sixpack.trace 8 rand quiet > report-output/sixpack-8-rand.txt
	./memsim report-traces/swim.trace 4 rand quiet > report-output/swim-4-rand.txt
	./memsim report-traces/swim.trace 6 rand quiet > report-output/swim-6-rand.txt
	./memsim report-traces/swim.trace 8 rand quiet > report-output/swim-8-rand.txt

ALL: compile run clean

compile:
	@gcc -o memsim memsim.c

run: 
	@./memsim traces/trace1 4 REPL_CLOCK debug

clean:
	@rm -f memsim
