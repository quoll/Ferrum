# Compiler and tool variables
JAVA = java
JAVAC = javac
GCC = gcc
GXX = g++
JAVA_HOME = $(shell /usr/libexec/java_home)

# Directories
SRC_DIR = Sources
MTL_DIR = Metal
OBJ_DIR = obj
LIB_DIR = lib
CLASS_DIR = classes
INCLUDE_DIR = include
TEST_DIR = Tests

# Java source and class files
JAVA_SRC = $(SRC_DIR)/ferrum/FerrumEngine.java
JAVA_CLASS = $(CLASS_DIR)/ferrum/FerrumEngine.class

# C++ source and object files
CPP_SRC = $(wildcard $(SRC_DIR)/ferrum/*.cpp)
CPP_OBJ = $(patsubst $(SRC_DIR)/ferrym/*.cpp,$(OBJ_DIR)/%.o,$(CPP_SRC))

# Metal source and object files
MTL_SRC = $(wildcard $(MTL_DIR)/ferrum/*.metal)
# Metal intermediate files are generated in the obj directory
MTL_OBJ = $(patsubst $(MTL_DIR)/ferrum/%.metal,$(OBJ_DIR)/%.ir,$(MTL_SRC))

# Dynamic library
DYLIB = $(LIB_DIR)/libferrum.dylib

# Metal library
MTL_LIB = $(LIB_DIR)/ferrum.metallib

# Test programs
TEST_SRC_FILES = $(wildcard $(TEST_DIR)/ferrum/*.cpp)
TEST_PROG = $(TEST_SRC_FILES:.cpp=)
JAVA_TEST_FILES = $(wildcard $(TEST_DIR)/ferrum/*.java)
JAVA_TEST_CLASS = $(patsubst $(TEST_DIR)/ferrum/%.java,$(CLASS_DIR)/ferrum/%.class,$(JAVA_TEST_FILES))

# Flags and includes
CFLAGS = -c -fPIC
JAVA_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/darwin"
CPP_INCLUDES = -Iapple-include -I"$(INCLUDE_DIR)"
CPP_FLAGS = -std=c++11 -Wno-c++11-extensions -Wno-c++11-extra-semi -Wno-c++17-extensions
FRAMEWORKS = -framework Foundation -framework Metal

# Targets
all: $(MTL_LIB) $(JAVA_CLASS) $(JAVA_TEST_CLASS) $(DYLIB) $(TEST_PROG)

# Compile Java class
$(JAVA_CLASS): $(JAVA_SRC)
	@mkdir -p $(CLASS_DIR)
	$(JAVAC) -cp $(SRC_DIR) -sourcepath $(SRC_DIR) -d $(CLASS_DIR) -h $(INCLUDE_DIR) $<

# Compile C++ implementations
$(CPP_JAVA_OBJ): $(CPP_JAVA_SRC) $(CPP_MTL_SRC)
	@mkdir -p $(OBJ_DIR)
	$(GCC) $(CFLAGS) $(JAVA_INCLUDES) $(CPP_INCLUDES) $(CPP_FLAGS) -o $@ $<

# Link dynamic library
$(DYLIB): $(CPP_JAVA_OBJ)
	@mkdir -p $(LIB_DIR)
	$(GXX) -dynamiclib -o $@ $< -lc

# Compile Metal shaders
$(OBJ_DIR)/%.ir: $(MTL_DIR)/ferrum/%.metal
	@mkdir -p $(OBJ_DIR)
	metal -o $@ -c $<

# Link Metal library
$(MTL_LIB): $(MTL_OBJ)
	@mkdir -p $(LIB_DIR)
	metallib -o $(MTL_LIB) $(MTL_OBJ)

# Build c++ test program
$(TEST_DIR)/ferrum/%: $(TEST_DIR)/ferrum/%.cpp
	$(GXX) $(CPP_INCLUDES) $(CPP_FLAGS) $< -o $@ $(FRAMEWORKS)

# Build java test program
$(CLASS_DIR)/ferrum/%.class: $(TEST_DIR)/ferrum/%.java | $(CLASS_DIR)/ferrum
	@mkdir -p $(CLASS_DIR)
	$(JAVAC) -cp $(CLASS_DIR) -sourcepath $(TEST_DIR) -d $(CLASS_DIR) $<

# Clean target
clean:
	rm -f $(JAVA_CLASS) $(CPP_JAVA_OBJ) $(DYLIB) $(TEST_PROG)
	rm -f $(CLASS_DIR)/ferrum/*
	rm -f $(OBJ_DIR)/*
	rm -f $(LIB_DIR)/*
	rm -f $(INCLUDE_DIR)/*.h

# Phony targets
.PHONY: all clean
