CC       := gcc
CFLAGS   := -o

SRC      := memsim.c
BIN      := memsim

comp:
	$(CC) $(CFLAGS) $(BIN) $(SRC)

clean:
	rm -f $(BIN)