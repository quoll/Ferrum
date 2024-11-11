# Ferrum
Vector operations on Apple Metal.

## Background
I started this project as a way to learn Metal. I wanted git so that I could have a history of what I'd written, in case I ever needed to go back, and Github was just an easy way to have an offsite backup.

However, as the project progressed and became more capable, I found that I was pushing through to something useful. The original plan was to integrate with [Neanderthal](https://github.com/uncomplicate/neanderthal), and this has guided development, but it may not be the final form for this project. Meanwhile, it can still be considered a learning exercise.

## Structure
The purpose of this project is to provide Apple Metal access to linear algebra operations in Clojure, for the purpose of Neural Network operations. As such, there are multiple layers.

### Clojure
The Clojure layers are currently very thin. These will be expanded on, but I expect to implement Neanderthal engines, and that structure has been guiding my efforts.

### Java
The path from Clojure to native access is via either [JNA](https://github.com/java-native-access/jna) or [JNI](https://docs.oracle.com/en/java/javase/22/docs/specs/jni/index.html). JNA is much simpler and more portable, but JNI still has an edge in lower overhead, and is used throughout the JDK itself. Since the whole point of accessing Apple APIs is for speed, I think that JNI is the appropriate mechanism.

Several Linear Algebra APIs define their own datatypes for vectors and matrices, which has benefits for memory management and reduced copying. I expect that this will be desirable in the future, but for the moment this project uses Java array types, which can be passed across to JNI, and can be allocated on the native side such that they can be returned to the user without additional wrapping. There are performance costs to this, but it allows for maximum flexibility.

The Java classes being used here are very thin, and only provide a mechanism for Clojure to call into "native" code.

### C++
While JNI can be implemented in anything with C bindings, C++ has several benefits. It conforms to the C bindings easily, offers a good standard library, and performs very well.

One disadvantage of C++ is that Apple provides all of its APIs via [ObjectiveC](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html) APIs instead. While this shares a number of features with C++, it has a very different syntax for object APIs.

Simplifying things a little, classes in C++ are defined both as a block of memory containing data for a class instance, and also as a set of functions that are attached to this definition. Such functions are referred to as the class's "methods". Instantiating a class into an object allocates memory for the object's data. Calling methods on the object means that one of the functions attached to the class will be called, and the address of the object instance will be implicitly passed as an invisible first parameter (That parameter can be referenced with the keyword `this`). This mechanism allows method calls to be very fast.

While Objective-C does support this mechanism of calling functions with the data structure passed as the first argument, that's not how this language manages classes and methods. Objective-C sends "messages" to objects, packaging method arguments into the message. Creating an object is also done differently. Objective-C has a static object for representing the class, which it can send a `create` message to, and receive a new object handle back. Once you have the object handle you then send it messages to call its methods. The syntax for Objective-C is very different from anything in C++, as it uses square brackets to send a message, and labels arguments with names.

This may seem incompatible with C++, but that is just because everything is being hidden by Objective-C syntax. All of these messages are sent via the `objc_msgSend` function entry point, which C++ can call directly.

### Foundation Classes
After starting to code in Metal with Swift, I discovered [sample Metal code from Apple](https://developer.apple.com/metal/sample-code/) that is all implemented in C++. This is accomplished with a set of open-source C++ headers for integrating with the Foundation Classes in MacOS. While they don't cover everything, they provide a sufficient roadmap for full and efficient integration of the Objective-C APIs with C++ code, leading me to implement extensions that provide access to whichever part of the Objective-C APIs may be needed. See [FoundationEx.hpp](https://github.com/quoll/Ferrum/blob/main/include/FoundationEx.hpp) for more.

#### Overview
Using a series of macros for easy and consistent declarations, the Foundation headers create a static array of object and method handles that the programmer needs to access. The original examples only included those objects and method identifiers needed by that code, so if anything else is required then these need to be added to the static list.

A set of macros are used to define which messages and arguments should be passed to a common function that uses `msgSend` to do the actual method dispatch.

Creating objects is done via static methods that also dispatch through the `msgSend` function. The result is an opaque handle that can only be used for sending messages to. This is where the C++ code gets tricky: it does a static cast of these handles, claiming that they are a pointer to an instance of their associated C++ class. This would be disastrous if the code actually tried to access memory through one of these pointers. However, the classes are described entirely as a set of non-virtual methods, with no data at all. Consequently, when a method is called on the class, the compiler knows where the method implementations are, and does not need to dereference the object pointer. (Virtual methods would require memory in the object).

The `msgSend` function then takes the object pointer, casts it back to a handle, and sends it a message. This leaves the compiler in charge of keeping track of the methods for the object handle. The end result is a set of C++ classes with a standard-looking API, despite everything being handled as Objective-C messages in the background.

Since I needed more object types and classes than had been brought in by the Apple C++ library, I extended it via the code found in `include/FoundationEx.hpp`.

### Metal
Like the Foundation Classes, the Metal APIs are all available via C++ classes that wrap the Objective-C APIs. This allows the selection and configuration of a GPU device, setting up compute pipelines, loading "Shader" code into the GPU, and executing it with appropriate parameters.

"Metal" is also the name given to the language used for coding shaders. This is a variation of C++, with the primary difference being extra annotations to describe function parameters.

Metal code is often included inside a program as text, where it can then be compiled and loaded into the GPU on the fly. However, Metal can also be pre-compiled and loaded as a binary object. Since the implementation of the linear algebra operations in Neanderthal is typically small and simple, this project has placed the Metal code into its own file where it gets compiled into a binary library.

I've ported most of the Neanderthal CUDA code into Metal, and hope to finish the rest soon. While this is mostly about changing the structure for each shader function, Neanderthal also includes functions for every CUDA operation, which is a much more extensive mathematics library than Metal offers. I've implemented the missing functions using [Taylor Series](https://en.wikipedia.org/wiki/Taylor_series) expansions, which is how these operations are typically performed.

## Build

Due to the many parts of this project, it is built using make. This happens in a few phases, which relates to the structure of the library.

### Metal Compilation

### Metal Library Object Embedding

### Utility Code Generation

### C++ Compilation

### Linking


## Future
While I want to get this finished and integrated into Neanderthal, it has provided me with the necessary background to move past this and into [Apple's Core ML](https://developer.apple.com/documentation/coreml) API. This provides an abstraction for Neural Networks without needing to build them by hand from linear algebra. However, linear algebra operations are still available, and these are provided via a system that incorporates both the Metal subsystem and also Apple's Neural Processing Units, which operate similarly to GPUs. This is a more compelling target, as it offers greater scope for hardware acceleration, while also providing more complex operations.
