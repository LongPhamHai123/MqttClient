CC = gcc
NAME_MODULE = example/example
CFLAGS += -Wall -Werror -g
CFLAGS += -I/usr/local/include
LDFLAGS += -L/usr/local/lib
LDLIBS += -lpaho-mqtt3c
OBJECTS_DIR = build
SOURCES = main.c
SOURCES_= $(notdir $(SOURCES))
OBJECTS = $(addprefix $(OBJECTS_DIR)/, $(SOURCES_:.c=.o))
# OBJECTS = $(SOURCES:.c=.o)

create:
# 	$(Print) CREATE $(OBJECTS_DIR) folder
	@echo CREATE $(OBJECTS_DIR) folder
	@mkdir -p $(OBJECTS_DIR)
all: create $(NAME_MODULE)
$(OBJECTS_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
$(NAME_MODULE): $(OBJECTS)
	$(Print) $(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
clean:
	rm -rf $(OBJECTS_DIR) $(OBJECTS)

