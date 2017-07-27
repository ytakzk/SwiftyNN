//
//  Exponential.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation
import Accelerate

// MARK: Exponentiation
public func exp(_ x: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vvexp(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Square Exponentiation
public func exp2(_ x: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vvexp2(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Natural Logarithm
public func log(_ x: [Double]) -> [Double] {
    var results = [Double](x)
    vvlog(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Base-2 Logarithm
public func log2(_ x: [Double]) -> [Double] {
    var results = [Double](x)
    vvlog2(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Base-10 Logarithm
public func log10(_ x: [Double]) -> [Double] {
    var results = [Double](x)
    vvlog10(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Logarithmic Exponentiation
public func logb(_ x: [Double]) -> [Double] {
    var results = [Double](x)
    vvlogb(&results, x, [Int32(x.count)])
    
    return results
}
