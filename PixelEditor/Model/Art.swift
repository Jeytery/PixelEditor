//
//  Art.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

struct PixelColor: Codable {
    let red: CGFloat
    let blue: CGFloat
    let green: CGFloat
    
    var uiColor: UIColor { return UIColor(red: red, green: green, blue: blue, alpha: 1) }
}

struct Pixel: Codable {
    let point: CGPoint
    let color: PixelColor
    
    static let empty = Pixel(point: CGPoint(x: 0, y: 0), color: UIColor.white.pixelColor)
}

struct Art: Codable {
    var pixels: Pixels
    let name: String
    let dimension: Int
    
    var userKey: String = ""
    var key: String = ""
    
    static let empty = Art(pixels: [Pixel.empty], name: "Empty", dimension: 1)
    
    static func empty(named: String, dimension: Int) -> Art {
        return Art(pixels: [Pixel.empty],
                   name: named,
                   dimension: dimension)
    }
}

