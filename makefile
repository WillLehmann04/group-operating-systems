ALL: compile run clean

compile:
	@gcc -o memsim memsim.c

run: 
	@./memsim traces/trace1 4 rand debug

clean:
	@rm -f memsim
