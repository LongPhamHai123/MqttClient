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
$(OBJECTS_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
create:
	@echo CREATE $(OBJECTS_DIR) folder
	@mkdir -p $(OBJECTS_DIR)
all: create build
build: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
clean:
	rm -f $(OBJECTS) build

