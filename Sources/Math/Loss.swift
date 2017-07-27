//
//  Loss.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation

struct Loss {
    
    static func meanSquared(y: Matrix, t: Matrix) -> Double {
        
        return sum(pow(y - t, 2).grid) * 0.5
    }
    
    static func crossEntropy(y: Matrix, t: Matrix) -> Double {
        
        assert(y.rows == t.rows)
        
        let delta = Double.ulpOfOne
        
        var tt: [Int] = []
        
        if t.columns == 1 {
            
            tt = t.grid.map { Int($0) }
        
        } else {
            
            tt = t.argmax().grid.map { Int($0) }
        }
        
        let err: [Double] = y.array.enumerated().map { (rowInd, row) in
        
            let yval = row[tt[rowInd]]
            return log(yval + delta) * -1
        }
                
        return sum(err) / Double(err.count)
    }
    
}
