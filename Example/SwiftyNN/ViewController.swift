//
//  ViewController.swift
//  SwiftyNN
//
//  Created by ytakzk on 07/27/2017.
//  Copyright (c) 2017 ytakzk. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        run()
    }
}

private extension ViewController {
    
    func run() {
        
        let XTrain = Matrix(Mnist.XTrain)
        let yTrain = Matrix(Mnist.yTrain, axies: .row)

        let net    = NeuralNet(inputNum: 784, hiddenNum: 50, outputNum: 10)
        
        let batch  = 100
        
        (0..<5000).forEach {
            
            let induces = XTrain.randomInduces(num: batch)
            let XBatch  = XTrain.batch(induces: induces)
            let yBatch  = yTrain.batch(induces: induces)
            
            net.gradient(x: XBatch, t: yBatch)
            
            let loss = net.loss(x: XBatch, t: yBatch)
            
            if $0 % 500 == 0 {
                
                print("\($0) iter: \(loss.description)")
            }
        }
        let XTest = Matrix(Mnist.XTest)
        let yTest = Matrix(Mnist.yTest, axies: .row)
        
        print("Accuracy: \(net.accuracy(x: XTest, t: yTest))")
    }
}
