# Compiler and tool variables
JAVAC = javac
GCC = gcc
GXX = g++
JAVA_HOME = $(shell /usr/libexec/java_home)

# Directories
SRC_DIR = Sources
OBJ_DIR = obj
CLASS_DIR = classes
HEADER_DIR = headers

# Java source and class files
JAVA_SRC = $(SRC_DIR)/numbertest/NumberTest.java
JAVA_CLASS = $(CLASS_DIR)/numbertest/NumberTest.class

# C++ source and object files
CPP_SRC = $(SRC_DIR)/native/numbertest.cpp
CPP_OBJ = $(OBJ_DIR)/numbertest_NumberTest.o

# Dynamic library
DYLIB = $(CLASS_DIR)/libnumbertest.dylib

# Test program
TEST_SRC = $(SRC_DIR)/numbertest/main.cpp
TEST_PROG = main

# Flags and includes
CFLAGS = -c -fPIC
JAVA_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/darwin" -I"$(HEADER_DIR)"
CPP_INCLUDES = -Iapple-headers
CPP_FLAGS = -std=c++11 -Wno-c++11-extensions -Wno-c++11-extra-semi -Wno-c++17-extensions
FRAMEWORKS = -framework Foundation -framework Metal

# Targets
all: $(JAVA_CLASS) $(DYLIB) $(TEST_PROG)

# Compile Java class
$(JAVA_CLASS): $(JAVA_SRC)
	$(JAVAC) -cp $(SRC_DIR) -sourcepath $(SRC_DIR) -d $(CLASS_DIR) -h $(HEADER_DIR) $<

# Compile C++ implementation
$(CPP_OBJ): $(CPP_SRC)
	$(GCC) $(CFLAGS) $(JAVA_INCLUDES) -o $@ $<

# Link dynamic library
$(DYLIB): $(CPP_OBJ)
	$(GXX) -dynamiclib -o $@ $< -lc

# Build test program
$(TEST_PROG): $(TEST_SRC)
	$(GXX) $(CPP_INCLUDES) $(CPP_FLAGS) $< -o $@ $(FRAMEWORKS)

# Clean target
clean:
	rm -f $(JAVA_CLASS) $(CPP_OBJ) $(DYLIB) $(TEST_PROG)
	rm -f $(HEADER_DIR)/*.h

# Phony targets
.PHONY: all clean
