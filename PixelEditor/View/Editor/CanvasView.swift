//
//  CanvasView.swift
//  PixelEditor
//
//  Created by Jeytery on 14.12.2021.
//

import UIKit

protocol CanvasViewDelegate: AnyObject {
    func canvasView(didTappedPixelAt point: CGPoint)
}

class CanvasView: UIView {

    private(set) var dimension: Int
    
    private var pixels = Array<Array<UIView>>()
    
    init(dimension: Int) {
        self.dimension = dimension
        super.init(frame: .zero)
        
        backgroundColor = .white
        configureGestures()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGrid()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - private
extension CanvasView {
    @objc func tapGestureAction(sender: UIGestureRecognizer) {
        draw(atPoint: sender.location(in: self))
    }
    
    private func createPixel(defaultColor: UIColor) -> UIView {
        let pixel = UIView()
        pixel.backgroundColor = defaultColor
        pixel.layer.borderWidth = 0.5
        pixel.layer.borderColor = Colors.lightGray.cgColor
        pixel.isUserInteractionEnabled = false
        return pixel
    }
    
    private func configureGrid() {
        for heightIndex in 0..<dimension {
            pixels.append([])
            for widthIndex in 0..<dimension {
                let pixel = createPixel(defaultColor: .white)
                pixel.frame = CGRect(
                    x: CGFloat(widthIndex) * pixelSize,
                    y: CGFloat(heightIndex) * pixelSize,
                    width: pixelSize,
                    height: pixelSize
                )
                pixels[heightIndex].append(pixel)
                addSubview(pixel)
            }
        }
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        addGestureRecognizer(tapGesture)
    }
    
    private func draw(atPoint point: CGPoint) {
        let y = Int(point.y / pixelSize)
        let x = Int(point.x / pixelSize)
        guard y < height && x < width && y >= 0 && x >= 0 else { return }
        pixels[y][x].backgroundColor = .red
    }
}

extension CanvasView {
    var image: UIImage {
        return UIImage()
    }
    
    private var pixelSize: CGFloat {
        return frame.height / CGFloat(dimension)
    }
    
    private var height: Int { return Int(frame.height) }
    
    private var width: Int { return Int(frame.width) }
}

extension CanvasView {
    func draw(points: Array<CGPoint>, color: UIColor) {
        
    }
}


