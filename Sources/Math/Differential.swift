//
//  Differential.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation

struct Differential {
    
    private static let DELTA = 0.000001
    
    static func numericalGradient(f: (Matrix) -> Double, x: Matrix) -> Matrix {
                
        let matrix2d: [[Double]] = x.array.enumerated().map { (rowInd, row) in
            
            return (0..<row.count).map {
            
                var tmpRow = row
                tmpRow[$0] += DELTA
                var tmpX = x
                tmpX[row: rowInd] = tmpRow
                let f1 = f(tmpX)
                
                tmpRow = row
                tmpRow[$0] -= DELTA
                tmpX = x
                tmpX[row: rowInd] = tmpRow
                let f2 = f(tmpX)
                
                return (f1 - f2) / (2.0 * DELTA)
            }
            
        }
        
        return Matrix(matrix2d)
    }
    
    static func descent(f: (Matrix) -> Double, x: Matrix, lr: Double = 0.01, step: Int = 100) -> Matrix {
    
        var x = x
        
        (0..<step).forEach { _ in

            let grad = numericalGradient(f: f, x: x)
            x = x - grad * lr
        }
        
        return x
    }
    
}
