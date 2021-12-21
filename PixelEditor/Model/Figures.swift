//
//  Figures.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

protocol Drawable {
    func getPoints(size: Int, on point: CGPoint) -> Array<CGPoint>
}

class Circle: Drawable {
    func getPolygon(size: Int, on point: CGPoint) -> Array<CGPoint> {
        var points: Array<CGPoint> = []
        for i in 0..<size {
            for j in 0..<i+1 {
                let y = point.y + CGFloat(i) - CGFloat(size - 1)
                points.append(CGPoint(x: point.x + CGFloat(j), y: y))
                points.append(CGPoint(x: point.x - CGFloat(j), y: y))
            }
        }
        return points
    }
    
    func getReversedPolygon(size: Int, on point: CGPoint) -> Array<CGPoint> {
        var points: Array<CGPoint> = []
        for i in 0..<size {
            for j in 0..<i+1 {
                let y = point.y - CGFloat(i) + CGFloat(size - 1)
                points.append(CGPoint(x: point.x + CGFloat(j), y: y))
                points.append(CGPoint(x: point.x - CGFloat(j), y: y))
            }
        }
        return points
    }
    
    
    func getPoints(size: Int, on point: CGPoint) -> Array<CGPoint> {
        
        return getReversedPolygon(size: size, on: point) + getPolygon(size: size, on: point)
    }
}

class Square: Drawable {
    func getPoints(size: Int, on point: CGPoint) -> Array<CGPoint> {
        var points: Array<CGPoint> = []
        for i in 0..<size {
            for j in 0..<size {
                points.append(CGPoint(x: point.x + CGFloat(i),
                                      y: point.y + CGFloat(j)))
            }
        }
        return points
    }
}

class Polygon: Drawable {
    func getPoints(size: Int, on point: CGPoint) -> Array<CGPoint> {
        var points: Array<CGPoint> = []
        for i in 0..<size {
            for j in 0..<i+1 {
                let y = point.y + CGFloat(i - (size / 2))
                points.append(CGPoint(x: point.x + CGFloat(j), y: y))
                points.append(CGPoint(x: point.x - CGFloat(j), y: y))
            }
        }
        return points
    }
}
