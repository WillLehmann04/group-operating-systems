test:
	./memsim report-traces/bzip.trace 16 rand quiet
	./memsim report-traces/gcc.trace 16 rand quiet
	./memsim report-traces/sixpack.trace 16 rand quiet
	./memsim report-traces/swim.trace 16 rand quiet

ALL: compile run clean

compile:
	@gcc -o memsim memsim.c

run: 
	@./memsim traces/trace1 4 REPL_CLOCK debug

clean:
	@rm -f memsim
