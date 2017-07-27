//
//  Arithmetic.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation

import Accelerate

// MARK: Sum
public func sum(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_sveD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Sum of Absolute Values
public func asum(_ x: [Double]) -> Double {
    return cblas_dasum(Int32(x.count), x, 1)
}

// MARK: Maximum
public func max(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_maxvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Minimum
public func min(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_minvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Mean
public func mean(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_meanvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Mean Magnitude
public func meamg(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_meamgvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Mean Square Value
public func measq(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_measqvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Add
public func add(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](y)
    cblas_daxpy(Int32(x.count), 1.0, x, 1, &results, 1)
    
    return results
}

// MARK: Subtraction
public func sub(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](y)
    catlas_daxpby(Int32(x.count), 1.0, x, 1, -1, &results, 1)
    
    return results
}

// MARK: Multiply
public func mul(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vDSP_vmulD(x, 1, y, 1, &results, 1, vDSP_Length(x.count))
    
    return results
}

// MARK: Divide
public func div(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vvdiv(&results, x, y, [Int32(x.count)])
    
    return results
}

// MARK: Modulo
public func mod(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vvfmod(&results, x, y, [Int32(x.count)])
    
    return results
}

// MARK: Remainder
public func remainder(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vvremainder(&results, x, y, [Int32(x.count)])
    
    return results
}

// MARK: Square Root
public func sqrt(_ x: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vvsqrt(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Dot Product
public func dot(_ x: [Double], y: [Double]) -> Double {
    precondition(x.count == y.count, "Vectors must have equal count")
    
    var result: Double = 0.0
    vDSP_dotprD(x, 1, y, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: - Distance
public func dist(_ x: [Double], y: [Double]) -> Double {
    precondition(x.count == y.count, "Vectors must have equal count")
    let sub = x - y
    var squared = [Double](repeating: 0.0, count: x.count)
    vDSP_vsqD(sub, 1, &squared, 1, vDSP_Length(x.count))
    
    return sqrt(sum(squared))
}

// MARK: - Operators
public func + (lhs: [Double], rhs: [Double]) -> [Double] {
    return add(lhs, y: rhs)
}

public func + (lhs: [Double], rhs: Double) -> [Double] {
    return add(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

public func - (lhs: [Double], rhs: [Double]) -> [Double] {
    return sub(lhs, y: rhs)
}

public func - (lhs: [Double], rhs: Double) -> [Double] {
    return sub(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

public func / (lhs: [Double], rhs: [Double]) -> [Double] {
    return div(lhs, y: rhs)
}

public func / (lhs: [Double], rhs: Double) -> [Double] {
    return div(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

public func / (lhs: Double, rhs: [Double]) -> [Double] {
    return div([Double](repeating: lhs, count: rhs.count), y: rhs)
}

public func * (lhs: [Double], rhs: [Double]) -> [Double] {
    return mul(lhs, y: rhs)
}

public func * (lhs: [Double], rhs: Double) -> [Double] {
    return mul(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

public func % (lhs: [Double], rhs: [Double]) -> [Double] {
    return mod(lhs, y: rhs)
}

public func % (lhs: [Double], rhs: Double) -> [Double] {
    return mod(lhs, y: [Double](repeating: rhs, count: lhs.count))
}

infix operator •
public func • (lhs: [Double], rhs: [Double]) -> Double {
    return dot(lhs, y: rhs)
}
