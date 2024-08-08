#!/usr/bin/env bash

javac -cp src -sourcepath src -d classes -h headers src/ferrum/FerrumEngine.java

gcc -c -fPIC -I"$JAVA_HOME/include" -I"$JAVA_HOME/include/darwin" -I"./headers" -o obj/ferrum_FerrumEngine.o src/ferrum/ferrum.cpp
g++ -dynamiclib -o classes/libferrum.dylib obj/ferrum_FerrumEngine.o -lc


