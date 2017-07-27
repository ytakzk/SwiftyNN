//
//  LayerTests.swift
//  SwiftyNNTests
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import XCTest
import Foundation

class LayerTests: XCTestCase {
    
    let vec0 = Matrix([1])
    let vec1 = Matrix([1, 2])
    let vec2 = Matrix([3, 4])
    let mat1 = Matrix([[1, -2], [3, 4]])
    let mat2 = Matrix([[1, 2], [-3, 4]])

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddLayer() {
    
        let l = AddLayer()
        
        let f_out = l.forward(x: vec1, y: vec1)
        let b_out = l.backward(vec1)
        
        assert(f_out == Matrix([2, 4]))
        assert(b_out.0 == Matrix([1, 2]))
        assert(b_out.1 == Matrix([1, 2]))
    }
    
    func testMulLayer() {
        
        let l = MulLayer()
        
        let f_out = l.forward(x: vec1, y: vec2)
        let b_out = l.backward(vec1)
        
        assert(f_out == Matrix([3, 8]))
        assert(b_out.0 == Matrix([3, 8]))
        assert(b_out.1 == Matrix([1, 4]))
    }

    func testRelu() {
        
        let l = Relu()
        
        let f_out = l.forward(x: mat1)
        let b_out = l.backward(mat2)
        
        assert(f_out == Matrix([[1, 0], [3, 4]]))
        assert(b_out == Matrix([[1, 0], [-3, 4]]))
    }
    
    func testSigmoid() {
        
        let l = Sigmoid()
        
        let f_out = l.forward(x: vec0)
        let b_out = l.backward(vec0)
        
        let out = 0.731058578630005
        
        assert(f_out.grid[0] - out < 0.0001)
        assert(b_out.grid[0] - (1 - out) * out < 0.0001)
    }
    
    func testAffine() {
        
        let l = Affine(W: mat1, b: vec1)
        
        let f_out = l.forward(x: vec1)
        let b_out = l.backward(vec1)
        
        assert(f_out == Matrix([[8, 8]]))
        assert(b_out == Matrix([[-3, 11]]))
    }
    
    func testSoftmaxWithLoss() {

    }
}

