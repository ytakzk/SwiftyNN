//
//  Mnist.swift
//  zerodep
//
//  Created by yakizuki on 2017/04/14.
//  Copyright © 2017年 Yahoo JAPAN Cooporation. All rights reserved.
//

import Foundation

class Mnist {
    
    fileprivate enum ImageResource: String {
        
        case XTrain = "train-images-idx3-ubyte"
        case XTest  = "t10k-images-idx3-ubyte"
    }
    
    fileprivate enum LabelResource: String {
        
        case yTrain = "train-labels-idx1-ubyte"
        case yTest  = "t10k-labels-idx1-ubyte"
    }
    
    public static var XTrain: [[Double]] = {
        return loadImages(resource: .XTrain) }()
    
    public static var yTrain: [Double] = {
        return loadLabels(resource: .yTrain) }()
    
    public static var XTest: [[Double]]  = {
        return loadImages(resource: .XTest) }()
    
    public static var yTest: [Double]  = {
        return loadLabels(resource: .yTest) }()
}

private extension Mnist {
    
    // images
    // 32 bit int   magic number        0x00000803 (2051)
    // 32 bit int   number of images    60000
    // 32 bit int   number of rows      28
    // 32 bit int   number of columns   28
    // pixels unsigned bytes            0-255
    static func loadImages(resource: ImageResource) -> [[Double]] {
        
        var result: [[Double]] = []
        
        var imageData:[UInt8] = []
        
        guard let url = Bundle.main.url(forResource: resource.rawValue, withExtension: "data"),
            let data = try? Data(contentsOf: url) else {
                
                return []
        }
        
        imageData = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &imageData, count: data.count)
        
        imageData.removeSubrange(0..<16)
        
        var pixels: [Double] = []
        var previousRow = 0
        
        imageData.enumerated().forEach { (offset, pixel) in
            
            let row = Int(floor(Double(offset / 784)))
            
            if row == previousRow {
                
                pixels.append(Double(pixel) / 255.0)
                
            } else {
                
                result.append(pixels)
                pixels = []
                previousRow = row
            }
        }
        
        result.append(pixels)
        
        return result
    }
    
    // labels
    // 32 bit int   magic number        0x00000801 (2049)
    // 32 bit int   number of labels    60000
    // labels unsigned bytes  range is  0-9
    static func loadLabels(resource: LabelResource) -> [Double] {
        
        var result: [Double] = []

        var imageData:[UInt8] = []
        
        guard let url = Bundle.main.url(forResource: resource.rawValue, withExtension: "data"),
            let data = try? Data(contentsOf: url) else {
                
                return []
        }
        
        imageData = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &imageData, count: data.count)
        
        imageData.removeSubrange(0..<8)
        
        imageData.enumerated().forEach { (offset, label) in
            
            result.append(Double(label))
        }
        
        return result
    }

}
