//
//  DifferentialTests.swift
//  SwiftyNNTests
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import XCTest
import Foundation

class DifferentialTests: XCTestCase {
    
    let vec = Matrix([1, 2])
    let mat = Matrix([[1, 2], [3, 4]])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testnumericalGradient() {
        
        let diffVec = Differential.numericalGradient(f: func1, x: vec)

        (diffVec.grid - [3, 5]).forEach {

            if Int($0) != 0 { assertionFailure() }
        }
        
        let diffMat = Differential.numericalGradient(f: func1, x: mat)
        
        (diffMat.grid - [3, 5, 7, 9]).forEach {
            
            if Int($0) != 0 { assertionFailure() }
        }
    }
    
    func testDescent() {
        
        let diffVec = Differential.descent(f: func1, x: vec, lr: 0.001, step: 10000)
        
        (diffVec.grid - [-0.5, -0.5]).forEach {
            
            if Int($0) != 0 { assertionFailure() }
        }
        
        let diffMat = Differential.descent(f: func1, x: mat, lr: 0.001, step: 10000)
        
        (diffMat.grid - [-0.5, -0.5, -0.5, -0.5]).forEach {
            
            if Int($0) != 0 { assertionFailure() }
        }
    }
    
    func testDescent2d() {
        
        let diffVec = Differential.descent(f: func1, x: vec, lr: 0.001, step: 10000)
        
        (diffVec.grid - [0, 0]).forEach {
            
            if Int($0) != 0 { assertionFailure() }
        }
        
        let diffMat = Differential.descent(f: func2, x: mat, lr: 0.01, step: 10000)
        
        (diffMat.grid - [0, 0, 0, 0]).forEach {
            
            if Int($0) != 0 { assertionFailure() }
        }
    }
    
}

fileprivate extension DifferentialTests {
    
    func func1(_ x: Matrix) -> Double {
        
        return sum((pow(x, 2) + x).grid)
    }
    
    func func2(_ x: Matrix) -> Double {
        
        let x1 = Matrix(x[column: 0], axies: .column)
        let x2 = Matrix(x[column: 1], axies: .column)
        return sum((pow(x1, 2) + pow(x2, 2)).grid)
    }
}
