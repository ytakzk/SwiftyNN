//
//  Matrix.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation
import Accelerate

public enum MatrixAxies {
    case row
    case column
}

public struct Matrix {
    
    let rows: Int
    let columns: Int
    var grid: [Double]
    
    public init(rows: Int, columns: Int, repeatedValue: Double) {
        
        self.rows    = rows
        self.columns = columns
        self.grid    = [Double](repeating: repeatedValue, count: rows * columns)
    }
    
    public init(rows: Int, columns: Int, std: Double) {
        
        self.init(rows: rows, columns: columns, repeatedValue: 0.0)
        self.grid = self.grid.map { _ in
            return Double(arc4random_uniform(100)) / 100.0 * std }
    }
    
    public init(rows: Int, columns: Int, vector: [Double]) {
        
        assert(rows * columns == vector.count)

        self.rows    = rows
        self.columns = columns
        self.grid    = vector
    }
    
    public init(rows: Int, vector: [Double]) {
        
        self.rows    = rows
        self.columns = vector.count
        self.grid    = Array((0..<rows).map { _ in return vector }.joined())
    }
    
    public init(columns: Int, vector: [Double]) {
        
        self.columns = columns
        self.rows    = vector.count
        
        let matrix: [[Double]] = (0..<rows).map {
            return [Double](repeating: vector[$0], count: columns) }
                
        self.grid = Array(matrix.joined())
    }
    
    public init(diag: [Double]) {
        
        let n: Int = diag.count
        self.init(rows: n, columns: n, repeatedValue: 0.0)
        (0..<n).forEach { grid[$0*(n+1)] = diag[$0] }
    }
    
    public init(_ contents: [[Double]]) {
        
        let m: Int = contents.count
        let n: Int = contents[0].count
        let repeatedValue: Double = 0.0
        
        if m == 1 {
            
            self.init(contents[0])
            
        } else {

            self.init(rows: m, columns: n, repeatedValue: repeatedValue)
            for (i, row) in contents.enumerated() {
                grid.replaceSubrange(i*n..<i*n+Swift.min(m, row.count), with: row)
            }
        }
    }
    
    public init(_ vector: [Double], axies: MatrixAxies = .column) {

        switch axies {
            
        case .column:
            
            self.rows    = 1
            self.columns = vector.count
            
        case .row:
            
            self.rows    = vector.count
            self.columns = 1
        }
        
        self.grid    = vector
    }
    
    public subscript(row: Int, column: Int) -> Double {
        
        get {
            assert(indexIsValidForRow(row, column: column))
            return grid[(row * columns) + column]
        }
        
        set {
            assert(indexIsValidForRow(row, column: column))
            grid[(row * columns) + column] = newValue
        }
    }
    
    public subscript(row row: Int) -> [Double] {
        
        get {
        
            assert(row < rows)
            let startIndex = row * columns
            let endIndex   = row * columns + columns
            return Array(grid[startIndex..<endIndex])
        }
        
        set {
            
            assert(row < rows)
            assert(newValue.count == columns)
            let startIndex = row * columns
            let endIndex   = row * columns + columns
            grid.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }
    
    public subscript(column column: Int) -> [Double] {
        
        get {
            
            var result = [Double](repeating: 0.0, count: rows)
            for i in 0..<rows {
                let index = i * columns + column
                result[i] = self.grid[index]
            }
            return result
        }
        
        set {
            
            assert(column < columns)
            assert(newValue.count == rows)
            
            for i in 0..<rows {
                let index   = i * columns + column
                grid[index] = newValue[i]
            }
        }
    }
    
    public var array: [[Double]] {
        
        return (0..<self.rows).map { (row: Int) -> [Double] in

            let startIndex = row * columns
            let endIndex   = row * columns + columns
            return Array(grid[startIndex..<endIndex])
        }
    }
    
    public var diag: [Double] {
        
        return (0..<self.rows).map { return grid[$0 * (columns + 1)] }
    }
    
    public func batch(induces: [Int]) -> Matrix {
        
        assert(induces.max()! < rows)

        let diag = induces.map { return self[row: $0] }
        
        return Matrix(diag)
    }
    
    public func randomInduces(num: Int, axies: MatrixAxies = .row) -> [Int] {
        
        let max = axies == .row ? rows : columns

        var result: [Int] = []
        
        while result.count < num {
            
            let val = Int(arc4random_uniform(UInt32(max)))
            if !result.contains(val) { result.append(val) }
        }

        return result
    }
    
    public func argmax(axies: MatrixAxies = .row) -> Matrix {
        
        switch axies {
            
        case .row:
            
            let vector:[Double] = (0..<rows).map {
                
                let vec = self[row: $0]
                
                var maxarg = 0
                var maxVal = Double.leastNormalMagnitude

                vec.enumerated().forEach {

                    if $1 > maxVal {
                        
                        maxarg = $0
                        maxVal = $1
                    }
                }
                
                return Double(maxarg)
            }
            
            return Matrix(columns: 1, vector: vector)
            
        case .column:
            
            let vector:[Double] = (0..<columns).map {
                
                let vec = self[column: $0]
                
                var maxarg = 0
                var maxVal = Double.leastNormalMagnitude
                
                vec.enumerated().forEach {
                    
                    if $1 > maxVal {
                        
                        maxarg = $0
                        maxVal = $1
                    }
                }
                
                return Double(maxarg)
            }
            
            return Matrix(vector)
        }
    }
    
    public mutating func update(_ by: @escaping (Double) -> Double) -> Matrix {
        
        self.grid = self.grid.map { return by($0) }        
        return self
    }
    
    fileprivate func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
}

// MARK: - SequenceType
extension Matrix: Sequence {
    
    public func makeIterator() -> AnyIterator<ArraySlice<Double>> {
        
        let endIndex = rows * columns
        var nextRowStartIndex = 0
        
        return AnyIterator {
        
            if nextRowStartIndex == endIndex { return nil }
            
            let currentRowStartIndex = nextRowStartIndex
            nextRowStartIndex += self.columns
            
            return self.grid[currentRowStartIndex..<nextRowStartIndex]
        }
    }
}

extension Matrix: Equatable {}
public func == (lhs: Matrix, rhs: Matrix) -> Bool {
    
    return lhs.rows == rhs.rows && lhs.columns == rhs.columns && lhs.grid == rhs.grid
}


// MARK: -

public func add(_ x: Matrix, y: Matrix) -> Matrix {
    
    var x = x
    var y = y
    
    // condition to be compatible with numpy
    if x.rows != 1 && y.rows == 1 {
        
        y = Matrix(rows: x.rows, vector: y.grid)
        
    } else if x.rows == 1 && y.rows != 1 {
        
        x = Matrix(rows: y.rows, vector: x.grid)
        
    } else if x.columns != 1 && y.columns == 1 {
        
        y = Matrix(columns: x.columns, vector: y.grid)
        
    } else if x.columns == 1 && y.columns != 1 {
        
        x = Matrix(columns: y.columns, vector: x.grid)
    }
    
    precondition(x.columns == y.columns && x.rows == y.rows, "Matrix dimensions not compatible with addition")
    cblas_daxpy(Int32(x.grid.count), 1.0, x.grid, 1, &(y.grid), 1)
    
    return y
}

public func sub(_ x: Matrix, y: Matrix) -> Matrix {

    return add(x, y: y * -1)
}

public func mul(_ alpha: Double, x: Matrix) -> Matrix {
    
    var results = x
    cblas_dscal(Int32(x.grid.count), alpha, &(results.grid), 1)
    return results
}

public func mul(_ x: Matrix, y: Matrix) -> Matrix {
    
    precondition(x.columns == y.rows, "Matrix dimensions not compatible with multiplication")
    
    var results = Matrix(rows: x.rows, columns: y.columns, repeatedValue: 0.0)
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                Int32(x.rows), Int32(y.columns), Int32(x.columns),
                1.0, x.grid, Int32(x.columns), y.grid, Int32(y.columns),
                0.0, &(results.grid), Int32(results.columns))
    
    return results
}

public func elmul(_ x: Matrix, y: Matrix) -> Matrix {
    
    precondition(x.rows == y.rows && x.columns == y.columns, "Matrix must have the same dimensions")
    
    var result = Matrix(rows: x.rows, columns: x.columns, repeatedValue: 0.0)
    result.grid = x.grid * y.grid
    return result
}

public func div(_ x: Matrix, y: Matrix) -> Matrix {
    
    var x = x
    var y = y
    
    if x.rows != 1 && y.rows == 1 {
        
        y = Matrix(rows: x.rows, vector: y.grid)
        
    } else if x.rows == 1 && y.rows != 1 {
        
        x = Matrix(rows: y.rows, vector: x.grid)
        
    } else if x.columns != 1 && y.columns == 1 {
        
        y = Matrix(columns: x.rows, vector: y.grid)
        
    } else if x.columns == 1 && y.columns != 1 {
        
        x = Matrix(columns: y.rows, vector: x.grid)
    }
    
    let yInv = inv(y)

    precondition(x.columns == yInv.rows, "Matrix dimensions not compatible")
    return mul(x, y: yInv)
}

public func pow(_ x: Matrix, _ y: Double) -> Matrix {
    
    var result = Matrix(rows: x.rows, columns: x.columns, repeatedValue: 0.0)
    result.grid = pow(x.grid, y)
    return result
}

public func exp(_ x: Matrix) -> Matrix {
    
    var result = Matrix(rows: x.rows, columns: x.columns, repeatedValue: 0.0)
    result.grid = exp(x.grid)
    return result
}

public func log(_ x: Matrix) -> Matrix {
    
    var x = x
    x.grid = log(x.grid)
    return x
}

public func sum(_ x: Matrix, axies: MatrixAxies = .row) -> Matrix {
    
    var result: Matrix
    
    switch axies {
        
    case .column:
        
        result = Matrix(rows: 1, columns: x.columns, repeatedValue: 0.0)
        for i in 0..<x.columns {
            result.grid[i] = sum(x[column: i])
        }
        
    case .row:
        
        result = Matrix(rows: x.rows, columns: 1, repeatedValue: 0.0)
        for i in 0..<x.rows {
            result.grid[i] = sum(x[row: i])
        }
    }

    return result
}

public func dot(_ x: Matrix, y: Matrix) -> Matrix {

    var y = y
    
    if x.columns != y.rows && y.rows == 1 && y.columns != 1 {
        
        y = transpose(y)
    }
    
    precondition(x.columns == y.rows, "Matrix dimensions not compatible with multiplication")
    
    var results = Matrix(rows: x.rows, columns: y.columns, repeatedValue: 0.0)
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
                Int32(x.rows), Int32(y.columns), Int32(x.columns),
                1.0, x.grid, Int32(x.columns), y.grid, Int32(y.columns),
                0.0, &(results.grid), Int32(results.columns))
    
    return results
}

public func inv(_ x : Matrix) -> Matrix {
    
    precondition(x.rows == x.columns, "Matrix must be square")
    
    var results = x
    
    var ipiv    = [__CLPK_integer](repeating: 0, count: x.rows * x.rows)
    var lwork   = __CLPK_integer(x.columns * x.columns)
    var work    = [CDouble](repeating: 0.0, count: Int(lwork))
    var nc      = __CLPK_integer(x.columns)
    var error: __CLPK_integer = 0
    
    dgetrf_(&nc, &nc, &(results.grid), &nc, &ipiv, &error)
    dgetri_(&nc, &(results.grid), &nc, &ipiv, &work, &lwork, &error)
    
    assert(error == 0, "Matrix not invertible")
    
    return results
}

public func transpose(_ x: Matrix) -> Matrix {
    
    var results = Matrix(rows: x.columns, columns: x.rows, repeatedValue: 0.0)
    vDSP_mtransD(x.grid, 1, &(results.grid), 1,
                 vDSP_Length(results.rows), vDSP_Length(results.columns))
    
    return results
}
