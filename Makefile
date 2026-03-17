CC = gcc
CFLAGS += -Wall -Werror -g
CFLAGS += -I/usr/local/include
LDFLAGS += -L/usr/local/lib
LDLIBS += -lpaho-mqtt3c
SOURCES = main.c
OBJECTS = $(SOURCES:.c=.o)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
all: build
build: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
clean:
	rm -f $(OBJECTS) build

