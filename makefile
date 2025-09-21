ALL: compile run clean

compile:
	@gcc -o memsim memsim.c

run: 
	@./memsim traces/trace1 4 REPL_CLOCK debug

clean:
	@rm -f memsim
