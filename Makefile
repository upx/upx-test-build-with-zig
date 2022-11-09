CMAKE = cmake
PKG_CMAKE_BUILD_FLAGS += --parallel
ifneq ($(VERBOSE),)
  PKG_CMAKE_BUILD_FLAGS += --verbose
endif

#***********************************************************************
# default
#***********************************************************************

__check_cache = $(if $(wildcard $1/CMakeCache.txt),@true,)
run_config = $(call __check_cache,$1) $(CMAKE) -S . -B $1 $(PKG_CMAKE_CONFIG_FLAGS) -DCMAKE_BUILD_TYPE=$2
run_build  =                          $(CMAKE) --build $1 $(PKG_CMAKE_BUILD_FLAGS) --config $2

.DEFAULT_GOAL = build/release

build/debug: PHONY
	$(call run_config,$@,Debug)
	$(call run_build,$@,Debug)

build/release: PHONY
	$(call run_config,$@,Release)
	$(call run_build,$@,Release)

# shortcuts
debug: build/debug
release: build/release

#***********************************************************************
# some pre-defined build configurations
#***********************************************************************

# force building with gcc/g++
build/%-gcc: export CC=gcc
build/%-gcc: export CXX=g++
build/debug-gcc: PHONY
	$(call run_config,$@,Debug)
	$(call run_build,$@,Debug)
build/release-gcc: PHONY
	$(call run_config,$@,Release)
	$(call run_build,$@,Release)

# force building with clang/clang++
build/%-clang: export CC=clang
build/%-clang: export CXX=clang++
build/debug-clang: PHONY
	$(call run_config,$@,Debug)
	$(call run_build,$@,Debug)
build/release-clang: PHONY
	$(call run_config,$@,Release)
	$(call run_build,$@,Release)

.PHONY: PHONY

#***********************************************************************
# misc support
#***********************************************************************

clang-format: CLANG_FORMAT_FILES = $(shell find src -type f -name '*.c' -o -name '*.cpp' -o -name '*.h')
clang-format: PHONY
	ulimit -v 1048576; clang-format -style=file -i $(CLANG_FORMAT_FILES)

lint-clang-tidy: CLANG_TIDY_FILES = $(shell find src -type f -name '*.c' -o -name '*.cpp')
lint-clang-tidy: PHONY
	ulimit -v 1048576; clang-tidy $(CLANG_TIDY_FILES)
