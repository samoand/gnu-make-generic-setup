include build_include.mk
include build_auto_dep.mk

.PHONY: all clean
all: $(exe_out_pathnames)

# START generate rules for executable targets
# 1: executable
# 2: .o files in the module to which this executable belongs
define EXE_MAKE_template
$(1): $(2)
	$(CC) $(cpp_extras) -o $(1) $(2)
endef

$(foreach exe_module,$(exe_modules),$(eval $(call EXE_MAKE_template,$(out)/$(exe_module)/$(exe_module),$($(out)/$(exe_module)/$(exe_module)_dependencies))))
# END


# START generate .o dependencies. Use variables generated in build_auto_dep
define D_template
$(1): $(2)
endef

$(foreach object,$(out_pathnames),$(eval $(call \
  D_template,$(object),$($(object)_dependencies))))

# END

# START generate .o build rules
# dependencies already generated at this point
# just a dependency to create target dir
# if it doesn't exist (rule below)
define OBJECT_MAKE_template
$(1): | $$(dir $(1))/
	$(CC) $(cpp_extras) -c -o $(1) $(2) -I$(src)
endef

$(foreach src_pathname,$(src_pathnames),$(eval $(call \
  OBJECT_MAKE_template,$(call src_to_o,$(src_pathname)),$(src_pathname),\
)))
# END
$(out)/%/:
	mkdir -p $@

clean:
	rm -rf $(out)
