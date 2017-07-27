//
//  NeuralNet.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation

class NeuralNet {

    var W1: Matrix
    var b1: Matrix
    var W2: Matrix
    var b2: Matrix
    
    var layers: [Layer]
    
    let affine1: Affine
    let affine2: Affine
    let relu1: Relu
    var softmaxWithLoss: SoftmaxWithLoss
    
    init(inputNum: Int, hiddenNum: Int, outputNum: Int, weightInitialStd: Double = 0.01) {
        
        W1 = Matrix(rows: inputNum, columns: hiddenNum, std: weightInitialStd)
        b1 = Matrix(rows: 1, columns: hiddenNum, std: weightInitialStd)
        W2 = Matrix(rows: hiddenNum, columns: outputNum, std: weightInitialStd)
        b2 = Matrix(rows: 1, columns: outputNum, std: weightInitialStd)
        
        self.affine1 = Affine(W: W1, b: b1)
        self.relu1   = Relu()
        self.affine2 = Affine(W: W2, b: b2)
        self.softmaxWithLoss = SoftmaxWithLoss()
        
        self.layers = [self.affine1, self.relu1, self.affine2]
    }

    func predict(x: Matrix) -> Matrix {

        return self.layers.reduce(x) { return $1.forward(x: $0) }
    }
    
    func loss(x: Matrix, t: Matrix) -> Double {
        
        let y = self.predict(x: x)
        return self.softmaxWithLoss.forward(x: y, t: t)
    }
    
    func accuracy(x: Matrix, t: Matrix) -> Double {

        let y = self.predict(x: x)

        assert(y.rows == t.rows)

        var yy: [Int] = []
        
        if y.columns == 1 {
            
            yy = y.grid.map { Int($0) }
            
        } else {
            
            yy = y.argmax().grid.map { Int($0) }
        }
        
        var tt: [Int] = []
        
        if t.columns == 1 {
            
            tt = t.grid.map { Int($0) }
            
        } else {
            
            tt = t.argmax().grid.map { Int($0) }
        }
        
        var total = 0
        
        for i in (0..<yy.count) {
        
            total += yy[i] == tt[i] ? 1 : 0
        }

        return Double(total) / Double(yy.count)
    }
    
    func gradient(x: Matrix, t: Matrix, lr: Double = 0.1) {
        
        _ = self.loss(x: x, t: t)
        
        var dout = Matrix([1])
        dout     = self.softmaxWithLoss.backward(dout)
        
        for l in layers.reversed() { dout = l.backward(dout) }
        
        affine1.update()
        affine2.update()
    }
    
    func numericalGradient(x: Matrix, t: Matrix, lr: Double = 0.1) {
        
        func lossW1(_ W: Matrix) -> Double {
            
            let a1 = dot(x, y: W) + b1
            let z1 = Activation.sigmoid(x: a1)
            let a2 = dot(z1, y: W2) + b2
            
            let y = Activation.sigmoid(x: a2)
        
            return Loss.crossEntropy(y: y, t: t)
        }
        
        func lossb1(_ b: Matrix) -> Double {
            
            let a1 = dot(x, y: W1) + b
            let z1 = Activation.sigmoid(x: a1)
            let a2 = dot(z1, y: W2) + b2
            
            let y = Activation.sigmoid(x: a2)
            
            return Loss.crossEntropy(y: y, t: t)
        }
        
        func lossW2(_ W: Matrix) -> Double {
            
            let a1 = dot(x, y: W1) + b1
            let z1 = Activation.sigmoid(x: a1)
            let a2 = dot(z1, y: W) + b2
            
            let y = Activation.sigmoid(x: a2)
            
            return Loss.crossEntropy(y: y, t: t)
        }
        
        func lossb2(_ b: Matrix) -> Double {
            
            let a1 = dot(x, y: W1) + b1
            let z1 = Activation.sigmoid(x: a1)
            let a2 = dot(z1, y: W2) + b
            
            let y = Activation.sigmoid(x: a2)
            
            return Loss.crossEntropy(y: y, t: t)
        }
        
        let gradW1 = Differential.numericalGradient(f: lossW1, x: W1)
        let gradb1 = Differential.numericalGradient(f: lossb1, x: b1)
        let gradW2 = Differential.numericalGradient(f: lossW2, x: W2)
        let gradb2 = Differential.numericalGradient(f: lossb2, x: b2)
        
        W1 = W1 - gradW1 * lr
        b1 = b1 - gradb1 * lr
        W2 = W2 - gradW2 * lr
        b2 = b2 - gradb2 * lr
    }
}
