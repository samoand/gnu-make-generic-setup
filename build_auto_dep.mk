include build_include.mk

.SECONDEXPANSION:
# which sources/objects represent executable files to be built
exe_src_pathnames ?= $(strip $(foreach ext,$(src_exts),\
  $(foreach module,$(modules),\
    $(wildcard $(src)/$(module)/$(module).$(ext)))))
exe_object_pathnames ?= $(foreach ext,$(src_exts),\
  $(filter %.o,$(exe_src_pathnames:$(src)%.$(ext)=$(out)%.o)))
exe_out_pathnames ?= $(exe_object_pathnames:%.o=%)


# $(info ********************* exe_src_pathnames *********************)
# $(info $(exe_src_pathnames))
# $(info ********************* exe_object_pathnames *********************)
# $(info $(exe_object_pathnames))
# $(info ********************* exe_out_pathnames *********************)
# $(info $(exe_out_pathnames))
# $(info ******************************************************************)

# name is *_exe but the filenames indeed don't have .exe because this targets flavors of unix/linux
src_to_o = $(filter %.o,$(foreach ext,$(src_exts),$(patsubst %.$(ext),%.o,$(patsubst $(src)/%,$(out)/%,$(1)))))
src_to_exe = $(patsubst %.o,%,$(call src_to_o,$(1)))

# produce entire *.o: ..." statement as it would appear in .d file
src_to_d_statement = $(shell $(CC) -M $(CPPFLAGS) $(1)) # $(1): name of .c file out: entire dependency statement as gen-ed by$(CC) -M...
# extract list of dependencies from target statement which would appear in .d file
d_statement_to_d_list = $(shell echo $(1) | sed 's,.*: *,,') # $(1): entire dependency statement as gen-ed by $(CC) -M... out: the dependency part of the statement (list of dependency files)

define DEP_VAR_ASSIGN_template
$(1)_dependencies = $(2)
endef

# below generates ...o_dependencies = <list of dependencies> variable definitions
$(foreach src_el,$(src_pathnames),$(eval $(call DEP_VAR_ASSIGN_template,\
  $(call src_to_o,$(src_el)),\
  $(call d_statement_to_d_list,$(call src_to_d_statement,$(src_el))))))
# Another step generates make rules for each object file. It uses variables generated above
# These two steps could be done in one step, but two steps make it easier to debug

# *** utils for module dependencies ***
#
# Find all modules which contain an executable (legend: module/module.$(ext) exists)
exe_modules ?= $(foreach exe_path,$(exe_out_pathnames),$(lastword $(subst /, ,$(exe_path))))

# Find all source files in a module
define srcs_in_a_module
$(call find_files,$(src)/$(1),$(src_exts))
endef

# for a given module, get all target object files (relative pathnames).
define objs_in_a_module
$(strip $(foreach ext,$(src_exts),\
  $(strip $(filter %.o,\
    $(patsubst $(src)%.$(ext),$(out)%.o,\
    $(call srcs_in_a_module,$(1)))))))
endef

# for each module that contains an executable,
# generate <module-name>_module_dependencies = ...
# list of dependencies. Note: this assumes that the module is valid,
# i.e. there's an executable exists in proper place.
$(foreach exe_module,$(exe_modules),\
  $(eval $(call DEP_VAR_ASSIGN_template,\
    $(out)/$(exe_module)/$(exe_module),\
    $(call objs_in_a_module,$(exe_module)))))

# end of scaffolding for module dependencies
