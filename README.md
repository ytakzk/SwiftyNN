# SwiftyNN

Pure Swift Neural Network. (WIP)

[![CI Status](http://img.shields.io/travis/ytakzk/SwiftyNN.svg?style=flat)](https://travis-ci.org/ytakzk/SwiftyNN)
[![Version](https://img.shields.io/cocoapods/v/SwiftyNN.svg?style=flat)](http://cocoapods.org/pods/SwiftyNN)
[![License](https://img.shields.io/cocoapods/l/SwiftyNN.svg?style=flat)](http://cocoapods.org/pods/SwiftyNN)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyNN.svg?style=flat)](http://cocoapods.org/pods/SwiftyNN)

## TO-DO
- [x] 1D neural network
- [ ] Convolutional neural network
- [ ] Create a class to create neural networks easily
- [ ] Release

## Sample codes

```
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
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 3 or later

## Installation

SwiftyNN is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyNN"
```

## Reference

* [oreilly-japan/deep-learning-from-scratch](https://github.com/oreilly-japan/deep-learning-from-scratch)
* [aleph7/Upsurge](https://github.com/aleph7/Upsurge)

## Author

ytakzk, yt@ytakzk.me

## License

SwiftyNN is available under the MIT license. See the LICENSE file for more info.
