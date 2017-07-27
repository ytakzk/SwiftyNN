//
//  Activation.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation

struct Activation {
    
    // y = 1 (x > 0)
    // y = 0 (x <= 0)
    static func step(x: Matrix) -> Matrix {
        
        var tmp = x
        return tmp.update { return $0 > 0 ? 1 : 0 }
    }
    
    // y = 1 / (1 + exp(-x))
    static func sigmoid(x: Matrix) -> Matrix {
        
        var tmp = x
        return tmp.update { return 1 / (1 + exp(-1 * $0)) }
    }
    
    // y = x (x > 0)
    // y = 0 (x <= 0)
    static func relu(x: Matrix) -> Matrix {
        
        var tmp = x
        return tmp.update { return max($0, 0) }
    }
    
    static func softmax(x: Matrix) -> Matrix {
        
        let expX = exp(x)
        let sumExpX = sum(expX)
        
        return expX / sumExpX
    }
    
}
