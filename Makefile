# Compiler and tool variables
JAVAC = javac
GCC = gcc
GXX = g++
JAVA_HOME = $(shell /usr/libexec/java_home)

# Directories
SRC_DIR = Sources
OBJ_DIR = obj
LIB_DIR = lib
CLASS_DIR = classes
INCLUDE_DIR = include
TEST_DIR = Tests

# Java source and class files
JAVA_SRC = $(SRC_DIR)/ferrum/FerrumEngine.java
JAVA_CLASS = $(CLASS_DIR)/ferrum/FerrumEngine.class

# C++ source and object files
CPP_JAVA_SRC = $(SRC_DIR)/native/ferrum.cpp
CPP_JAVA_OBJ = $(OBJ_DIR)/ferrum_FerrumEngine.o



# Dynamic library
DYLIB = $(LIB_DIR)/libferrum.dylib

# Test programs
TEST_SRC_FILES = $(wildcard $(TEST_DIR)/ferrum/*.cpp)
TEST_PROG = $(TEST_SRC_FILES:.cpp=)

# Flags and includes
CFLAGS = -c -fPIC
JAVA_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/darwin" -I"$(INCLUDE_DIR)"
CPP_INCLUDES = -Iapple-include -I"$(INCLUDE_DIR)"
CPP_FLAGS = -std=c++11 -Wno-c++11-extensions -Wno-c++11-extra-semi -Wno-c++17-extensions
FRAMEWORKS = -framework Foundation -framework Metal

# Targets
all: $(JAVA_CLASS) $(DYLIB) $(TEST_PROG)

# Compile Java class
$(JAVA_CLASS): $(JAVA_SRC)
	$(JAVAC) -cp $(SRC_DIR) -sourcepath $(SRC_DIR) -d $(CLASS_DIR) -h $(INCLUDE_DIR) $<

# Compile C++ implementation
$(CPP_JAVA_OBJ): $(CPP_JAVA_SRC)
	$(GCC) $(CFLAGS) $(JAVA_INCLUDES) -o $@ $<

# Link dynamic library
$(DYLIB): $(CPP_JAVA_OBJ)
	$(GXX) -dynamiclib -o $@ $< -lc

# Build test program
$(TEST_DIR)/ferrum/%: $(TEST_DIR)/ferrum/%.cpp
	$(GXX) $(CPP_INCLUDES) $(CPP_FLAGS) $< -o $@ $(FRAMEWORKS)

# Clean target
clean:
	rm -f $(JAVA_CLASS) $(CPP_JAVA_OBJ) $(DYLIB) $(TEST_PROG)
	rm -f $(INCLUDE_DIR)/*.h

# Phony targets
.PHONY: all clean
