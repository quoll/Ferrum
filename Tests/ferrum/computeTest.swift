// The Swift Programming Language
// https://docs.swift.org/swift-book

// computeTest.swift

import Foundation
import Metal

let devices = MTLCopyAllDevices()
print("Available devices: \(devices)")

guard let device = devices.first else {
    fatalError("Metal is not supported on this device")
}

print("Running on device: \(device.name)")

let commandQueue = device.makeCommandQueue()!

let shader = """
#include <metal_stdlib>
using namespace metal;

kernel void add_arrays(const device float* inA,
                       const device float* inB,
                       device float* c,
                       uint id [[thread_position_in_grid]]) {
    c[id] = inA[id] + inB[id];
}
"""

let library = try! device.makeLibrary(source: shader, options: nil)

let function = library.makeFunction(name: "add_arrays")!

let computePipelineState = try! device.makeComputePipelineState(function: function)

let arrayLength = 4
let inA: [Float] = [1, 2, 3, 4]
let inB: [Float] = [5, 6, 7, 8]

let inABuffer = device.makeBuffer(bytes: inA, length: arrayLength * MemoryLayout<Float>.size, options: [])!
let inBBuffer = device.makeBuffer(bytes: inB, length: arrayLength * MemoryLayout<Float>.size, options: [])!
let resultBuffer = device.makeBuffer(length: arrayLength * MemoryLayout<Float>.size, options: [])!

let commandBuffer = commandQueue.makeCommandBuffer()!

let computeEncoder = commandBuffer.makeComputeCommandEncoder()!

computeEncoder.setComputePipelineState(computePipelineState)

computeEncoder.setBuffer(inABuffer, offset: 0, index: 0)
computeEncoder.setBuffer(inBBuffer, offset: 0, index: 1)
computeEncoder.setBuffer(resultBuffer, offset: 0, index: 2)

// Dispatch the compute task
let gridSize = MTLSize(width: arrayLength, height: 1, depth: 1)
let threadGroupSize = MTLSize(width: 1, height: 1, depth: 1)
computeEncoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadGroupSize)

// End the encoding
computeEncoder.endEncoding()
// Commit the command buffer
commandBuffer.commit()
commandBuffer.waitUntilCompleted()

let resultPointer = resultBuffer.contents().bindMemory(to: Float.self, capacity: arrayLength)
let resultArray = Array(UnsafeBufferPointer(start: resultPointer, count: arrayLength))

print("Result: \(resultArray)")

