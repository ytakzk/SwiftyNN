//
//  Matrix+Arithmetic.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Accelerate

// MARK: - Operators

public func + (lhs: Matrix, rhs: Matrix) -> Matrix {
    return add(lhs, y: rhs)
}

public func + (lhs: Matrix, rhs: Double) -> Matrix {
    
    let y = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: rhs)
    return add(lhs, y: y)
}

public func - (lhs: Matrix, rhs: Matrix) -> Matrix {
    return sub(lhs, y: rhs)
}

public func - (lhs: Matrix, rhs: Double) -> Matrix {
    
    let y = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: rhs)
    return sub(lhs, y: y)
}

public func - (lhs: Double, rhs: Matrix) -> Matrix {
    
    let x = Matrix(rows: rhs.rows, columns: rhs.columns, repeatedValue: lhs)
    return sub(x, y: rhs)
}

public func * (lhs: Matrix, rhs: Matrix) -> Matrix {
    
    var x = lhs
    var y = rhs
    
    if x.rows != 1 && y.rows == 1 {
        
        y = Matrix(rows: x.rows, vector: y.grid)
        
    } else if x.rows == 1 && y.rows != 1 {
        
        x = Matrix(rows: y.rows, vector: x.grid)
        
    } else if x.columns != 1 && y.columns == 1 {
        
        y = Matrix(columns: x.rows, vector: y.grid)
        
    } else if x.columns == 1 && y.columns != 1 {
        
        x = Matrix(columns: y.rows, vector: x.grid)
    }
    
    precondition(x.rows == y.rows && x.columns == y.columns, "Matrix must have the same dimensions")
    
    return Matrix(rows: x.rows, columns: y.columns, vector: x.grid * y.grid)
    
}

public func * (lhs: Matrix, rhs: Double) -> Matrix {
    var result = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
    result.grid = lhs.grid * rhs
    return result
}

public func / (lhs: Matrix, rhs: Matrix) -> Matrix {
    
    var x = lhs
    var y = rhs
    
    if x.rows != 1 && y.rows == 1 {
        
        y = Matrix(rows: x.rows, vector: y.grid)
        
    } else if x.rows == 1 && y.rows != 1 {
        
        x = Matrix(rows: y.rows, vector: x.grid)
        
    } else if x.columns != 1 && y.columns == 1 {
        
        y = Matrix(columns: x.columns, vector: y.grid)
        
    } else if x.columns == 1 && y.columns != 1 {
        
        x = Matrix(columns: y.columns, vector: x.grid)
    }
    
    precondition(x.rows == y.rows && x.columns == y.columns, "Matrix must have the same dimensions")
    
    return Matrix(rows: x.rows, columns: y.columns, vector: x.grid / y.grid)
}

public func / (lhs: Matrix, rhs: Double) -> Matrix {
    var result = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
    result.grid = lhs.grid / rhs
    return result
}

public func / (lhs: Matrix, rhs: Int) -> Matrix {
    var result = Matrix(rows: lhs.rows, columns: lhs.columns, repeatedValue: 0.0)
    result.grid = lhs.grid / Double(rhs)
    return result
}

public func / (lhs: Double, rhs: Matrix) -> Matrix {
    var result = Matrix(rows: rhs.rows, columns: rhs.columns, repeatedValue: 0.0)
    result.grid = lhs / rhs.grid
    return result
}
