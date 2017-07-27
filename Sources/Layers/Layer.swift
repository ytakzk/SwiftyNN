//
//  Layer.swift
//  SwiftyNN
//
//  Created by Yuta Akizuki on 2017/07/27.
//  Copyright © 2017年 ytakzk. All rights reserved.
//

import Foundation

protocol JoinLayer {
    
    func forward(x: Matrix, y: Matrix) -> Matrix
    func backward(_ dout: Matrix) -> (Matrix, Matrix)
}

protocol Layer {
    
    func forward(x: Matrix) -> Matrix
    func backward(_ dout: Matrix) -> Matrix
    func update(lr: Double)
}

class AddLayer: JoinLayer {
    
    public func forward(x: Matrix, y: Matrix) -> Matrix {
        
        return x + y
    }
    
    public func backward(_ dout: Matrix) -> (Matrix, Matrix) {
        
        return (dout, dout)
    }
}

class MulLayer: JoinLayer {
    
    var x: Matrix?, y: Matrix?

    public func forward(x: Matrix, y: Matrix) -> Matrix {
        
        self.x = x
        self.y = y
        return x * y
    }
    
    public func backward(_ dout: Matrix) -> (Matrix, Matrix) {
        
        guard let x = self.x, let y = self.y else { fatalError("Pass forward before") }

        return (dout * y, dout * x)
    }
}

class Relu: Layer {

    private var mask: [(Int, Int)]?
    
    public func forward(x: Matrix) -> Matrix {

        mask = []

        var x = x
        
        (0..<x.rows).forEach { row in
            
            (0..<x.columns).forEach { column in
                
                if x[row, column] <= 0 {

                    x[row, column] = 0
                    mask!.append((row, column))
                }
            }
        }
        
        return x
    }
    
    public func backward(_ dout: Matrix) -> Matrix {
        
        guard let mask = self.mask else { fatalError("Pass forward before") }

        var out = dout
        mask.forEach { out[$0.0, $0.1] = 0 }
        return out
    }

    public func update(lr: Double = 0.1) { }
}

class Sigmoid: Layer {
    
    private var out: Matrix?
    
    public func forward(x: Matrix) -> Matrix {
        
        self.out = 1 / (exp(x * -1) + 1)
        return out!
    }
    
    public func backward(_ dout: Matrix) -> Matrix {
        
        guard let out = self.out else { fatalError("Pass forward before") }
        return dout * (1 - out) * out
    }
    
    public func update(lr: Double = 0.1) { }
}

class Affine: Layer {
    
    private var W: Matrix, b: Matrix
    private var x: Matrix?
    private var _dW: Matrix?, _db: Matrix?
    
    public var dW: Matrix {
        
        guard let dW = self._dW else { fatalError("Pass backword before") }
        return dW
    }
    
    public var db: Matrix {
        
        guard let db = self._db else { fatalError("Pass backword before") }
        return db
    }
    
    public init(W: Matrix, b: Matrix) {
        
        self.W = W
        self.b = b
    }
    
    public func forward(x: Matrix) -> Matrix {
        
        self.x = x
        return dot(x, y: self.W) + self.b
    }
    
    public func backward(_ dout: Matrix) -> Matrix {
        
        guard let x = self.x else { fatalError("Pass forward before") }

        let dx = dot(dout, y: transpose(self.W))

        self._dW = dot(transpose(x), y: dout)
        self._db = sum(dout, axies: .column)
        return dx
    }
    
    public func update(lr: Double = 0.1) {
    
        self.W = self.W - self.dW * lr
        self.b = self.b - self.db * lr
    }
    
}

class SoftmaxWithLoss {
    
    private var y: Matrix?, t: Matrix?
    
    public func forward(x: Matrix, t: Matrix) -> Double {
        
        self.y    = Activation.softmax(x: x)
        self.t    = t
        return Loss.crossEntropy(y: self.y!, t: t)
    }
    
    public func backward(_ dout: Matrix) -> Matrix {
        
        guard let y = self.y, let t = self.t else {
            fatalError("Pass forward before") }

        let batchSize = t.rows

        if y.rows == t.rows && y.columns == t.columns {
            
            return (y - t) / batchSize
        
        } else {
            
            var dx = y
            
            dx.enumerated().forEach { (offset, row) in
                
                let tt = Int(t[offset, 0])
                dx[offset, tt] = dx[offset, tt] - 1
            }
            
            return dx / batchSize
        }
    }
}
