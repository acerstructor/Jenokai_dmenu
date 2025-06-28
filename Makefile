# dmenu - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk
BIN_DIR :=bin
MAN_DIR :=man

# dmenu files and directories configuration
DMENU_SRC_DIR :=dmenu/src
DMENU_OBJ_DIR :=dmenu.obj

# Find all .c files inside SRC_DIR and its subdirectories
DMENU_SRC_SUBDIRS =$(wildcard $(DMENU_SRC_DIR)/*/ $(DMENU_SRC_DIR)/*/*/)
DMENU_SRC         =$(wildcard $(DMENU_SRC_DIR)/*.c $(DMENU_SRC_DIR)/*/*.c $(DMENU_SRC_DIR)/*/*/*.c)

# Define corresponding .o files in OBJ_DIR
DMENU_OBJ_SUBDIRS =$(patsubst $(DMENU_SRC_DIR)/%, $(DMENU_OBJ_DIR)/%, $(DMENU_SRC_SUBDIRS))
DMENU_OBJ         =$(patsubst $(DMENU_SRC_DIR)/%.c, $(DMENU_OBJ_DIR)/%.o, $(DMENU_SRC))

# stest
STEST_SRC_DIR :=stest/src
STEST_OBJ_DIR :=stest.obj

STEST_SRC      =$(wildcard $(STEST_SRC_DIR)/*.c $(STEST_SRC_DIR)/*/*.c $(STEST_SRC_DIR)/*/*/*.c)
STEST_OBJ      =$(patsubst $(STEST_SRC_DIR)/%.c, $(STEST_OBJ_DIR)/%.o, $(STEST_SRC))

all: options stest dmenu

options:
	@echo dmenu build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

$(DMENU_OBJ): $(DMENU_OBJ_DIR)/%.o : $(DMENU_SRC_DIR)/%.c | $(DMENU_OBJ_DIR) $(DMENU_OBJ_SUBDIRS)
	$(CC) -c $< -o $@ $(CFLAGS)

$(STEST_OBJ): $(STEST_OBJ_DIR)/%.o : $(STEST_SRC_DIR)/%.c | $(STEST_OBJ_DIR)
	$(CC) -c $< -o $@ $(CFLAGS)

dmenu: $(DMENU_OBJ)
	$(CC) -o $(BIN_DIR)/$@ $(DMENU_OBJ) $(LDFLAGS)

stest: $(STEST_OBJ)
	$(CC) -o $(BIN_DIR)/$@ $(STEST_OBJ) $(LDFLAGS)

# Create obj directory if it doesn't exist
$(STEST_OBJ_DIR):
	@mkdir -p $@

$(DMENU_OBJ_DIR):
	@mkdir -p $@

$(DMENU_OBJ_SUBDIRS):
	@mkdir -p $@

clean:
	rm -rf $(BIN_DIR)/dmenu $(BIN_DIR)/stest $(DMENU_OBJ_DIR) $(STEST_OBJ_DIR)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(BIN_DIR)/* $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_run
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(PREFIX_MAN)/man1
	sed "s/VERSION/$(VERSION)/g" < $(MAN_DIR)/dmenu.1 > $(DESTDIR)$(PREFIX_MAN)/man1/dmenu.1
	sed "s/VERSION/$(VERSION)/g" < $(MAN_DIR)/stest.1 > $(DESTDIR)$(PREFIX_MAN)/man1/dmenu.1
	chmod 644 $(DESTDIR)$(PREFIX_MAN)/man1/dmenu.1
	chmod 644 $(DESTDIR)$(PREFIX_MAN)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dmenu\
		$(DESTDIR)$(PREFIX)/bin/dmenu_path\
		$(DESTDIR)$(PREFIX)/bin/dmenu_run\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(PREFIX_MAN)/man1/dmenu.1\
		$(DESTDIR)$(PREFIX_MAN)/man1/stest.1

.PHONY: all options clean install uninstall
