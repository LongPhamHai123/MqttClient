CC = gcc
NAME_MODULE = example/example

CFLAGS += -Wall -Werror -g
CFLAGS += -I/usr/local/include

LDFLAGS += -L/usr/local/lib
LDLIBS += -lpaho-mqtt3cs \
		  -lcjson \
		  -lcjson_utils

OBJECTS_DIR = build

# Nếu có nhiều file thì thêm vào đây
SOURCES = main.c
# ví dụ:
# SOURCES = src/main.c src/utils.c

OBJECTS = $(addprefix $(OBJECTS_DIR)/, $(SOURCES:.c=.o))

all: create $(NAME_MODULE)

create:
	@echo CREATE $(OBJECTS_DIR) folder
	@mkdir -p $(OBJECTS_DIR)
	@mkdir -p example   # tạo luôn folder output
	@echo $(SOURCES)
	@echo $(OBJECTS)
# RULE QUAN TRỌNG
$(OBJECTS_DIR)/%.o: %.c
	@echo CC 	$<
	$(CC) $(CFLAGS) -c $< -o $@

$(NAME_MODULE): $(OBJECTS)
	@echo ---------- START LINK EXAMPLE ----------
	@echo CC 	$^ -o $@
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	rm -rf $(OBJECTS_DIR) $(NAME_MODULE)