#CPUS ?= $(getconf _NPROCESSORS_ONLN)
CPUS ?= $(shell nproc)
MAKEFLAGS += --jobs=$(CPUS)


UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	OPENSCAD="openscad"
endif
ifeq ($(UNAME_S),MINGW64_NT-10.0)
	OPENSCAD="C:/Program Files/OpenSCAD/openscad.com"
endif

OPENSCAD_FLAGS=
OPENSCADPATH=$(shell pwd)

SCAD_FILES = $(wildcard *.scad)

BUILDDIR = out
OUTPUTDIR = out

default: all

define def_parts
# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard $(BUILDDIR)/*.deps)

.SECONDARY: $(BUILDDIR)/$2.scad
# define a new target for a temporary "build file" that only calls the part module
$(BUILDDIR)/$2.scad: $1 | dir_build dir_output
	@/bin/echo -n -e 'use <../$(1)>\npart_$(2)();' > $(BUILDDIR)/$2.scad

$(OUTPUTDIR)/$2.stl: $(BUILDDIR)/$2.scad
	@echo Building $2
	@OPENSCADPATH=$(OPENSCADPATH) $(OPENSCAD) $(OPENSCAD_FLAGS) -m make -D is_build=true -o $(OUTPUTDIR)/$2.stl -d $(BUILDDIR)/$2.deps $(BUILDDIR)/$2.scad

.PHONY: all
all:: $(OUTPUTDIR)/$2.stl
endef

define find_parts
# use sed to find all openscad modules that begin with part_
$(eval PARTS := $(shell  sed -n -e 's/^module part_\(.*\)().*/\1/p' $1))
# define a new build target for each found part
$(foreach part,$(PARTS),$(eval $(call def_parts,$1,$(part))))
endef

# Find all parts in all scad files
$(foreach file,$(SCAD_FILES),$(eval $(call find_parts,$(file))))

.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

.SECONDARY: dir_build
dir_build:
	@mkdir -p $(BUILDDIR)

.SECONDARY: dir_output
dir_output:
	@mkdir -p $(OUTPUTDIR)

clean:
	@rm -rf $(BUILDDIR)
	@rm -rf $(OUTPUTDIR)

gui:
	@OPENSCADPATH=$(OPENSCADPATH) $(OPENSCAD) $(OPENSCAD_FLAGS)
