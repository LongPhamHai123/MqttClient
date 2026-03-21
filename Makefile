CC = gcc
CFLAGS += -Wall -Werror -g
CFLAGS += -I/usr/local/include
LDFLAGS += -L/usr/local/lib
LDLIBS += -lpaho-mqtt3c
OBJECTS_DIR = build
SOURCES += main.c
SOURCES_= $(notdir $(SOURCES))
OBJECTS += $(addprefix $(OBJECTS_DIR)/, $(SOURCES_:.c=.o))
# OBJECTS = $(SOURCES:.c=.o)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
all: build
build: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
clean:
	rm -f $(OBJECTS) build

