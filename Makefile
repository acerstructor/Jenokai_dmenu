# dmenu - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk
BIN_DIR :=bin
SRC_DIR :=src
OBJ_DIR :=obj

# Find all .c files inside SRC_DIR and its subdirectories
SRC_SUBDIRS =$(wildcard $(SRC_DIR)/*/ $(SRC_DIR)/*/*/)
SRC         =$(wildcard $(SRC_DIR)/*.c $(SRC_DIR)/*/*.c $(SRC_DIR)/*/*/*.c)

# Define corresponding .o files in OBJ_DIR
OBJ_SUBDIRS =$(patsubst $(SRC_DIR)/%, $(OBJ_DIR)/%, $(SRC_SUBDIRS))
OBJ         =$(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC))

all: options dmenu

options:
	@echo dmenu build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

$(OBJ): $(OBJ_DIR)/%.o : $(SRC_DIR)/%.c | $(OBJ_DIR) $(OBJ_SUBDIRS)
	$(CC) -c $< -o $@ $(CFLAGS)

dmenu: $(OBJ)
	$(CC) -o $(BIN_DIR)/$@ $(OBJ) $(LDFLAGS)

# Create obj directory if it doesn't exist
$(OBJ_DIR):
	@mkdir -p $@

$(OBJ_SUBDIRS):
	@mkdir -p $@

clean:
	rm -rf $(BIN_DIR)/dmenu $(OBJ_DIR)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dmenu dmenu_path dmenu_run $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_run
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < man/dmenu.1 > $(DESTDIR)$(MANPREFIX)/man1/dmenu.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dmenu.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dmenu\
		$(DESTDIR)$(PREFIX)/bin/dmenu_path\
		$(DESTDIR)$(PREFIX)/bin/dmenu_run\
		$(DESTDIR)$(MANPREFIX)/man1/dmenu.1

.PHONY: all options clean install uninstall
