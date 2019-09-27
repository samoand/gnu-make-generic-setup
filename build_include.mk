# root_dir := $(CURDIR)
src ?= src
out ?= out
src_exts ?= c cpp

# find all files under dir $(1) with given extensions $(2)
define find_files
$(strip $(foreach ext,$(2),$(strip $(shell find $(1) -name *.$(ext)))))
endef

src_pathnames ?= $(call find_files,$(src),$(src_exts))

out_pathnames ?= $(strip $(foreach ext,$(src_exts),\
  $(filter %.o,\
    $(patsubst $(src)%.$(ext),$(out)%.o,$(src_pathnames)))))

modules ?= $(patsubst src/%/,%,$(shell ls -d $(src)/*/))

$(info $(exe_out_pathnames))

CC = g++-8
#CC = clang
# C++ extra flags
#cpp_extras = -std=c++1z
cpp_extras = -std=c++17

# $(info BEGIN INCLUDE VARS)
# $(info ********************* src *********************)
# $(info $(src))
# $(info ********************* out *********************)
# $(info $(out))
# $(info ********************* src_pathnames *********************)
# $(info $(src_pathnames))
# $(info ********************* out_pathnames *********************)
# $(info $(out_pathnames))
# $(info ********************* modules *********************)
# $(info $(modules))
# $(info ******************************************************************)
