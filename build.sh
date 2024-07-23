#!/usr/bin/env bash

javac -cp Sources -sourcepath Sources -d classes -h headers Sources/numbertest/NumberTest.java

gcc -c -fPIC -I"$JAVA_HOME/include" -I"$JAVA_HOME/include/darwin" -I"./headers" -o obj/numbertest_NumberTest.o Sources/native/numbertest.cpp
g++ -dynamiclib -o classes/libnumbertest.dylib obj/numbertest_NumberTest.o -lc


