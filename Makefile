CC=clang
GITREV:=$(shell git rev-parse HEAD)
BINARY=boilerplate

_CFLAGS+=-Wall -Wextra -Werror -Wshadow -Winline -D_GNU_SOURCE -std=c99 -g
override CFLAGS+=$(_CFLAGS) -O0 -DGITREV=$(GITREV) -fno-omit-frame-pointer
DEBUG_CFLAGS=$(CFLAGS)
RELEASE_CFLAGS=$(_CFLAGS) -O2 -DNDEBUG -fomit-frame-pointer
TEST_CFLAGS=$(RELEASE_CFLAGS)
COV_CFLAGS=$(CFLAGS) --coverage

SRC_DIR=$(CURDIR)/src
BIN_DIR=$(CURDIR)/bin
BUILD_DIR=$(CURDIR)/build
DEPS_DIR=$(CURDIR)/deps

INCLUDES=-I$(CURDIR) -I$(SRC_DIR)
#INCLUDES+=-I$(BUILD_DIR)/somedep/include

LIB_PATHS=
#LIB_PATHS=-L$(BUILD_DIR)/somedep/lib

LIBS=
#LIBS=-lsomedep

UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S),Linux)
	#LIBS+=-Wl,-Bdynamic -lrt -luuid -lssl -lcrypto
else ifeq ($(UNAME_S),Darwin)
	#LIBS+=-framework CoreServices
endif

.PHONY: all
all: debug

.PHONY: dist
dist: $(BIN_DIR)/$(BINARY)

.PHONY: debug
debug: $(BIN_DIR)/$(BINARY)_debug

.PHONY: cov
cov: $(BIN_DIR)/$(BINARY)_cov
	rm -rf *.gcda
	$(BIN_DIR)/$(BINARY)_cov
	@gcov -f $(notdir $(filter-out %_test.c,$(filter %.c,$(TEST_SOURCES)))) \
		2> /dev/null | ruby $(CURDIR)/scripts/gcov_pretty_print.rb

.PHONY: test
test: $(BIN_DIR)/$(BINARY)_test
	valgrind --leak-check=full --show-reachable=yes $(BIN_DIR)/$(BINARY)_test \
		2>&1 | ruby $(CURDIR)/scripts/valgrind_pretty_print.rb

.PHONY: prereqs
prereqs: submodules deps

.PHONY: submodules
submodules:
	git submodule sync
	git submodule init
	git submodule update | cut -d\' -f2 | xargs -t -I{} rm -f $(BUILD_DIR)/{} 2>&1

.PHONY: deps
deps:
	$(MAKE) -C $(DEPS_DIR)

_SOURCES=$(shell find src -type f -iname '*.[ch]')
SOURCES=$(filter-out %_test.c,$(_SOURCES))
TEST_SOURCES=$(filter-out %main.c,$(_SOURCES))

$(BIN_DIR)/$(BINARY): prereqs $(SOURCES)
	-mkdir -p $(BIN_DIR)
	$(CC) $(RELEASE_CFLAGS) -o $@ $(filter %.c,$^) $(INCLUDES) $(LIB_PATHS) $(LIBS)

$(BIN_DIR)/$(BINARY)_debug: prereqs $(SOURCES)
	-mkdir -p $(BIN_DIR)
	$(CC) $(DEBUG_CFLAGS) -o $@ $(filter %.c,$^) $(INCLUDES) $(LIB_PATHS) $(LIBS)

$(BIN_DIR)/$(BINARY)_cov: prereqs $(TEST_SOURCES)
	-mkdir -p $(BIN_DIR)
	$(CC) $(COV_CFLAGS) -o $@ $(filter %.c,$^) $(INCLUDES) $(LIB_PATHS) $(LIBS)

$(BIN_DIR)/$(BINARY)_test: prereqs $(TEST_SOURCES)
	-mkdir -p $(BIN_DIR)
	$(CC) $(TEST_CFLAGS) -o $@ $(filter %.c,$^) $(INCLUDES) $(LIB_PATHS) $(LIBS)

.PHONY: _clean
_clean:
	rm -rf $(BIN_DIR)/*
	rm -rf *.gcno *.gcda *.gcov

.PHONY: clean
clean: _clean
	@echo make distclean if you want to clean all dependencies

.PHONY: distclean
distclean: _clean
	cd $(DEPS_DIR) && $(MAKE) clean
	rm -rf $(BUILD_DIR)/*
