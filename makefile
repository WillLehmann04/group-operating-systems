CC       := gcc
CFLAGS   := -o

SRC      := memsim.c
BIN      := memsim

compile:
	$(CC) $(CFLAGS) $(BIN) $(SRC)

clean:
	rm -f $(BIN)

ALL: