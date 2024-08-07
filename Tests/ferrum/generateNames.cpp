#define NS_PRIVATE_IMPLEMENTATION
#define MTL_PRIVATE_IMPLEMENTATION

// include the std namespace so we can use the std::cout and std::getenv
#include <iostream>
#include <fstream>

#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>
#include <simd/simd.h>

#include "FoundationEx.hpp"

const char* LIB_NAME = "ferrum";
const char* LIB_TYPE = "metallib";
const char* FERRUM_LIB = "FERRUM_LIB";

inline NS::String* nsStr(const char* str) {
  return NS::String::string(str, NS::UTF8StringEncoding);
}

const char* str(const NS::String* s) {
  return (s != nullptr) ? s->utf8String() : "<null>";
}

NS::String* metalExt = nsStr(LIB_TYPE);
NS::String* ferrumName = nsStr(LIB_NAME);

NS::String* getEnv(const char* name) {
  const char* value = std::getenv(name);
  return value != nullptr ? nsStr(value) : nullptr;
}

const NS::String* getLibPath(const char* path) {
  NS::String* resource = (path == nullptr) ? ferrumName : nsStr(path);
  // check in the bundle
  NS::BundleEx* mainBundle = NS::BundleEx::mainBundle();
  if (mainBundle != nullptr && mainBundle->bundlePath() != nullptr) {
    const NS::String* resource_path = mainBundle->pathForResource(resource, metalExt);
    if (resource_path != nullptr) {
      return resource_path;
    }
  }

  // not in the bundle, so check if the path points to the file
  bool isDir = false;
  NS::FileManager* fileManager = NS::FileManager::defaultManager();

  if (path != nullptr) {
    if (fileManager != nullptr && fileManager->fileExistsAtPath(resource, &isDir)) {
      // if it's not a directory, then it's the file
      if (!isDir) {
        return resource;
      }
      // it's a directory, so check if the file is in that directory
      const NS::String* lib_path = NS::StringEx::asStringEx(resource)
                                       ->stringByAppendingPathComponent(ferrumName)
                                       ->stringByAppendingPathExtension(metalExt);
      if (fileManager->fileExistsAtPath(lib_path, &isDir)) {
        if (!isDir) {
          return lib_path;
        }
      }
    }
    return nullptr;
  }

  NS::StringEx* resource_path = NS::StringEx::asStringEx(getEnv(FERRUM_LIB));
  if (resource_path != nullptr) {
    resource_path = NS::StringEx::asStringEx(resource_path)
                        ->stringByAppendingPathComponent(ferrumName)
                        ->stringByAppendingPathExtension(metalExt);
  } else {
    resource_path = NS::StringEx::asStringEx(nsStr("./lib"))
                        ->stringByAppendingPathComponent(ferrumName)
                        ->stringByAppendingPathExtension(metalExt);
  }
  if (fileManager != nullptr && fileManager->fileExistsAtPath(resource_path, &isDir)) {
    if (!isDir) {
      return resource_path;
    }
  }
  return nullptr;
}

MTL::Library* loadLibrary(const char* path) {
  NS::Array* devices = MTL::CopyAllDevices();
  int length = devices != nullptr ? devices->count() : 0;
  if (length == 0) {
    std::cerr << "Metal is not supported on this device" << std::endl;
    return nullptr;
  }
  MTL::Device* device = devices->object<MTL::Device>(0);
  std::cout << "Running on device: " << device->name()->utf8String() << std::endl;

  MTL::CommandQueue* commandQueue = device->newCommandQueue();

  const NS::String* libPath = getLibPath(path);
  if (libPath == nullptr) {
    std::cerr << "Error: Failed to find library" << std::endl;
    return nullptr;
  }
  NS::URL* url = NS::URL::fileURLWithPath(libPath);
  if (url == nullptr) {
    std::cerr << "Error: Failed to create URL for: " << str(libPath) << std::endl;
    return nullptr;
  }

  NS::Error* pError = nullptr;
  MTL::Library* library = device->newLibrary(url, &pError);

  if (pError != nullptr) {
    std::cerr << "Error: Loading library: " << str(pError->localizedDescription()) << std::endl;
    std::cerr << "     : Library file: " << url->fileSystemRepresentation() << std::endl;
    return nullptr;
  } else if (library == nullptr) {
    std::cerr << "Error: Failed to create library from: " << url->fileSystemRepresentation() << std::endl;
    return nullptr;
  }

  return library;
}

void printCode(std::vector<std::string>& names, const char* header, const char* cpp) {
  std::ofstream headerFile(header);
  if (!headerFile.is_open()) {
    std::cerr << "Error: Failed to open file: " << header << std::endl;
    return;
  }

  headerFile << "#pragma once\n" << std::endl;
  headerFile << "#ifndef _FUNCTIONS_H" << std::endl;
  headerFile << "#define _FUNCTIONS_H\n" << std::endl;
  headerFile << "enum Function {" << std::endl;
  int index = 0;
  for (const std::string& fn : names) {
    headerFile << "  " << fn << " = " << index;
    if (++index < names.size()) {
      headerFile << ",";
    }
    headerFile << std::endl;
  }
  headerFile << "};\n" << std::endl;
  headerFile << "#endif _FUNCTIONS_H" << std::endl;
  headerFile.close();

  std::ofstream sourceFile(cpp);
  if (!sourceFile.is_open()) {
    std::cerr << "Error: Failed to open file: " << cpp << std::endl;
    return;
  }
  sourceFile << "#include \"" << header << "\"\n" << std::endl;
  sourceFile << "#include <unordered_map>\n" << std::endl;
  sourceFile << "std::unordered_map<std::string, Function> functionMap;\n" << std::endl;
  sourceFile << "__attribute__((constructor))" << std::endl;
  sourceFile << "void initFunctionMap() {" << std::endl;
  for (const std::string& fn : names) {
    sourceFile << "  functionMap[\"" << fn << "\"] = " << fn << ";" << std::endl;
  }
  sourceFile << "}\n" << std::endl;
  sourceFile.close();
}

int main(void) {
  MTL::Library* library = loadLibrary(nullptr);
  if (library == nullptr) {
    std::cerr << "Error: Failed to load library" << std::endl;
    return -1;
  }
  std::cout << "Successfully loaded library" << std::endl;

  NS::Array* functions = library->functionNames();
  int length = functions != nullptr ? functions->count() : 0;
  if (length == 0) {
    std::cerr << "Error: No functions found in library" << std::endl;
    return -1;
  }
  std::vector<std::string> names;
  for (int i = 0; i < length; i++) {
    NS::String* name = static_cast<NS::String*>(functions->object(i));
    names.push_back(name->utf8String());
  }
  std::sort(names.begin(), names.end());
  printCode(names, "functions.hpp", "functions.cpp");
  return 0;
}

