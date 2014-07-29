BUILD_DIR=$(CURDIR)/../build

DEPS=
#DEPS+=somedep
DEP_TARGETS=$(patsubst %,$(BUILD_DIR)/%,$(DEPS))

.PHONY: all
all: $(DEP_TARGETS)

#.PHONY: somedep
#somedep: #(BUILD_DIR)/somedep
	#cd somedep && ./autogen.sh && ./configure --prefix=$@ && $(MAKE) && $(MAKE) install

.PHONY: clean
clean:
	@echo FIXME (don't know how to clean these deps)
