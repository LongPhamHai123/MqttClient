CC = gcc
CFLAGS += -Wall -Werror -g
CFLAGS += -I/usr/local/include
LDFLAGS += -L/usr/local/lib
LDLIBS += -lpaho-mqtt3a
SOURCES = main.c
OBJECTS = $(SOURCES:.c=.o)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ $(LDFLAGS) $(LDLIBS)
all: mqtt_client
mqtt_client: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
clean:
	rm -f $(OBJECTS) mqtt_client

