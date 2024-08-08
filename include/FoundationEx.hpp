#pragma once

#ifndef FNDN_EX_HPP
#define FNDN_EX_HPP

#include <Foundation/Foundation.hpp>

namespace NS {

    class BundleEx : public Bundle, public Referencing<BundleEx> {
        public:
            static BundleEx* asBundleEx(Bundle* obj);
            static BundleEx* mainBundle();
            String* pathForResource(const class String* name, const class String* Ex);
    };

    class StringEx : public String, public Referencing<StringEx>{
        public:
            static StringEx* asStringEx(String* obj);
            StringEx* stringByAppendingPathComponent(const String* str);
            StringEx* stringByAppendingPathExtension(const String* str);
    };

    class FileManager : public Referencing<FileManager> {
        public:
            static FileManager* defaultManager();
            bool fileExistsAtPath(const String* path, bool* isDir);
    };

    class DataEx : public Data, public Referencing<DataEx> {
        public:
            static DataEx* asDataEx(Data* obj);
            DataEx* dataCreateWithBytesNoCopy(const void* data, size_t length);
    };

    namespace Private {
        namespace Class {
            _NS_PRIVATE_DEF_CLS(NSFileManager);
            _NS_PRIVATE_DEF_CLS(NSData);
        } // Class


        namespace Selector {
            _NS_PRIVATE_DEF_SEL(pathForResource_ofType_, "pathForResource:ofType:");
            _NS_PRIVATE_DEF_SEL(stringByAppendingPathComponent_, "stringByAppendingPathComponent:");
            _NS_PRIVATE_DEF_SEL(stringByAppendingPathExtension_, "stringByAppendingPathExtension:");
            _NS_PRIVATE_DEF_SEL(defaultManager, "defaultManager");
            _NS_PRIVATE_DEF_SEL(fileExistsAtPath_isDirectory_, "fileExistsAtPath:isDirectory:");
            _NS_PRIVATE_DEF_SEL(dataWithBytesNoCopy_length_, "dataWithBytesNoCopy:length:");
        } // Selector
    } // Private

} // NS

// NS::BundleEx methods

_NS_INLINE NS::BundleEx* NS::BundleEx::asBundleEx(NS::Bundle* bundle) {
    return static_cast<BundleEx*>(bundle);
}

_NS_INLINE NS::BundleEx* NS::BundleEx::mainBundle() {
    return Object::sendMessage<BundleEx*>(_NS_PRIVATE_CLS(NSBundle), _NS_PRIVATE_SEL(mainBundle));
}

_NS_INLINE NS::String* NS::BundleEx::pathForResource(const NS::String* name, const NS::String* Ex) {
    return Object::sendMessage<String*>(this, _NS_PRIVATE_SEL(pathForResource_ofType_), name, Ex);
}

// NS::StringEx methods

_NS_INLINE NS::StringEx* NS::StringEx::asStringEx(NS::String* str) {
    return static_cast<StringEx*>(str);
}

_NS_INLINE NS::StringEx* NS::StringEx::stringByAppendingPathComponent(const NS::String* str) {
    return Object::sendMessage<StringEx*>(this, _NS_PRIVATE_SEL(stringByAppendingPathComponent_), str);
}

_NS_INLINE NS::StringEx* NS::StringEx::stringByAppendingPathExtension(const NS::String* str) {
    return Object::sendMessage<StringEx*>(this, _NS_PRIVATE_SEL(stringByAppendingPathExtension_), str);
}

// NS::FileManager methods

_NS_INLINE NS::FileManager* NS::FileManager::defaultManager() {
    return Object::sendMessage<FileManager*>(_NS_PRIVATE_CLS(NSFileManager), _NS_PRIVATE_SEL(defaultManager));
}

_NS_INLINE bool NS::FileManager::fileExistsAtPath(const NS::String* path, bool* isDir) {
    return Object::sendMessage<bool>(this, _NS_PRIVATE_SEL(fileExistsAtPath_isDirectory_), path, isDir);
}

// NS::DataEx methods

_NS_INLINE NS::DataEx* NS::DataEx::asDataEx(NS::Data* data) {
    return static_cast<DataEx*>(data);
}

_NS_INLINE NS::DataEx* NS::DataEx::dataCreateWithBytesNoCopy(const void* data, size_t length) {
    return Object::sendMessage<DataEx*>(_NS_PRIVATE_CLS(NSData), _NS_PRIVATE_SEL(dataWithBytesNoCopy_length_), data, length);
}

#endif // FNDN_EX_HPP
