test:
	./memsim report-traces/bzip.trace 4 lru quiet
	./memsim report-traces/bzip.trace 8 lru quiet
	./memsim report-traces/bzip.trace 16 lru quiet
	./memsim report-traces/gcc.trace 4 lru quiet
	./memsim report-traces/gcc.trace 8 lru quiet
	./memsim report-traces/gcc.trace 16 lru quiet
	./memsim report-traces/sixpack.trace 4 lru quiet
	./memsim report-traces/sixpack.trace 8 lru quiet
	./memsim report-traces/sixpack.trace 16 lru quiet
	./memsim report-traces/swim.trace 4 lru quiet
	./memsim report-traces/swim.trace 8 lru quiet
	./memsim report-traces/swim.trace 16 lru quiet

ALL: compile run clean

compile:
	@gcc -o memsim memsim.c

run: 
	@./memsim traces/trace1 4 REPL_CLOCK debug

clean:
	@rm -f memsim
