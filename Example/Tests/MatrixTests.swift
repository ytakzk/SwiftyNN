//
//  MatrixTests.swift
//  SwiftyNNTests
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import XCTest

class MatrixTests: XCTestCase {
    
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
    
    func testAdd() {
        
        assert(vec + 1 == Matrix([2, 3]))
        assert(vec + vec == Matrix([2, 4]))
        assert(vec + mat == Matrix([[2, 4], [4, 6]]))
        assert(mat + vec == Matrix([[2, 4], [4, 6]]))
        assert(mat + mat == Matrix([[2, 4], [6, 8]]))
    }
    
    func testSub() {
        
        assert(vec - 1 == Matrix([0, 1]))
        assert(vec - vec == Matrix([0, 0]))
        assert(vec - mat == Matrix([[0, 0], [-2, -2]]))
        assert(mat - vec == Matrix([[0, 0], [2, 2]]))
        assert(mat - mat == Matrix([[0, 0], [0, 0]]))
    }
    
    func testMul() {
        
        assert(vec * 1 == Matrix([1, 2]))
        assert(vec * vec == Matrix([1, 4]))
        assert(vec * mat == Matrix([[1, 4], [3, 8]]))
        assert(mat * vec == Matrix([[1, 4], [3, 8]]))
        assert(mat * mat == Matrix([[1, 4], [9, 16]]))
    }
    
    func testDiv() {
        
        assert(vec / 1 == Matrix([1, 2]))
        assert(vec / vec == Matrix([1, 1]))
        assert(vec / mat == Matrix([[1, 1], [1.0/3.0, 1.0/2.0]]))
        assert(mat / vec == Matrix([[1, 1], [3, 2]]))
        assert(mat / mat == Matrix([[1, 1], [1, 1]]))
    }
    
    func testSum() {
        
        assert(sum(vec) == Matrix([[3]]))
        assert(sum(mat) == Matrix([[3], [7]]))
        assert(sum(vec, axies: .column) == Matrix([[1, 2]]))
        assert(sum(mat, axies: .column) == Matrix([[4, 6]]))
    }
    
    func testDot() {

        assert(dot(vec, y: vec) == Matrix([5]))
        assert(dot(vec, y: mat) == Matrix([[7, 10]]))
        assert(dot(mat, y: vec) == Matrix([[5], [11]]))
    }
    
    func testTranspose() {
        
        assert(transpose(vec) == Matrix([[1], [2]]))
        assert(transpose(mat) == Matrix([[1, 3], [2, 4]]))
    }
    
}
