//
//  Pow.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Accelerate

// MARK: Power
public func pow(_ x: [Double], y: [Double]) -> [Double] {
    var results = [Double](repeating: 0.0, count: x.count)
    vvpow(&results, x, y, [Int32(x.count)])
    
    return results
}

public func pow(_ x: [Double], _ y: Double) -> [Double] {
    let yVec = [Double](repeating: y, count: x.count)
    return pow(yVec, y: x)
}
