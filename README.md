# Ferrum
Vector operations on Apple Metal.

## Background
I started this project as a way to learn Metal. I wanted git so that I could have a history of what I'd written, in case I ever needed to go back, and Github was just an easy way to have an offsite backup.

However, as the project progressed and became more capable, I found that I was pushing through to something useful. The original plan was to integrate with [Neanderthal](https://github.com/uncomplicate/neanderthal), and this has guided development, but it may not be the final form for this project. Meanwhile, it can still be considered a learning exercise.

## Structure
The purpose of this project is to provide Apple Metal access to linear algebra operations in Clojure, for the purpose of Neural Network operations. As such, there are multiple layers.

### Clojure
The Clojure layers are currently very thin. These will be expanded on, but I expect to reimplement Neanderthal engines, and that structure has been guiding my efforts.

### Java
The path from Clojure to native access is via either [JNA](https://github.com/java-native-access/jna) or [JNI](https://docs.oracle.com/en/java/javase/22/docs/specs/jni/index.html). JNA is much simpler and more portable, but JNI still has an edge in lower overhead, and is used throughout the JDK itself. Since the whole point of accessing Apple APIs is for speed, JNI is the appropriate mechanism to use.

Several Linear Algebra APIs define their own datatypes for vectors and matrices, which has benefits for memory management and reduced copying. I expect that this will be desirable in the future, but for the moment this project uses Java array types, which can be passed across to JNI, and can be allocated on the native side such that they can be returned to the user without additional wrapping.

The Java classes being used here are very thin, and only provide a mechanism for Clojure to call into "native" code.

### C++
While JNI can be implemented in anything with C bindings, C++ has several benefits. It conforms to the C bindings easily, offers a good standard library, and performs very well.

One disadvantage of C++ is that Apple provides all of its APIs via [ObjectiveC](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html) APIs instead. While this shares a number of features with C++, it has a very different syntax for object APIs.

Simplifying things a little, classes in C++ are defined as a block of memory containing data for a class instance, and functions that are attached to this definition. Such functions are referred to as the classes "methods". Instantiating a class into an object allocates memory to be used for the object. Calling methods on the object means that one of the functions attached to the class will be called, and the address of the object instance will be implicitly passed as an invisible first parameter. This mechanism allows method calls to be very fast.

While Objective-C does support this mechanism of calling functions with the data structure passed as the first argument, this is not how classes and methods work in that language. Objective-C sends "messages" to objects, packaging method arguments into the message. Creating an object means sending a message to a static object representing the class, and once you have the object handle you can send messages to it as well. The syntax for Objective-C is very different from anything in C++, as it uses square brackets to send a message, and labels arguments with names.

This may seem completely incompatible with C++, but it isn't since everything still has to happen via the `objc_msgSend` function entry point.

### Foundation Classes
In trying to learn how to code in Metal, I followed [sample code from Apple](https://developer.apple.com/metal/sample-code/) and discovered that it was all in C++. This is enabled by a set of open-source C++ headers for integrating with the Foundation Classes in MacOS. While they don't cover everything, they provide a sufficient roadmap for full and efficient integration of the Objective-C APIs with C++ code.

### Metal
Like the Foundation Classes, the Metal APIs are all available via C++ classes that wrap the Objective-C APIs. This allows the selection and configuration of a GPU device, setting up compute pipelines, loading code into the GPU (this code is called a "Shader") and executing it with appropriate parameters.

"Metal" is also the name given to the language used for coding shaders. This is a variation of C++ as well, with the primary difference being extra annotations to describe function parameters.

While Metal code is often included inside a program, and is compiled and loaded into the GPU on the fly, it can also be pre-compiled. Since the implementation of the linear algebra operations in Neanderthal is typically small and simple, the Metal code has been placed into its own file and loaded into a binary library.

## Future
While I want to get this finished and integrated into Neanderthal, it has provided me with the necessary background to move past this and into [Apple's Core ML](https://developer.apple.com/documentation/coreml) API. This provides an abstraction for Neural Networks without needing to build them by hand from linear algebra. However, linear algebra operations are still available, and these are provided via a system that incorporates both the Metal subsystem and also Apple's Neural Processing Units, which operate similarly to GPUs. This is a more compelling target, as it offers greater scope for hardware acceleration, while also providing more complex operations.
