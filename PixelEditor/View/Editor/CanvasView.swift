//
//  CanvasView.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

protocol CanvasViewDelegate: AnyObject {
    func canvasView(_ view: CanvasView, didTappedPixelAt point: CGPoint)
    func canvasView(didEndConfigureGrid view: CanvasView)
}

class CanvasView: UIView {

    weak var delegate: CanvasViewDelegate?
    
    private(set) var dimension: Int
    private var pixels = Array<Array<UIView>>()
    private(set) var points = Pixels()
    
    init(dimension: Int) {
        self.dimension = dimension
        super.init(frame: .zero)
        
        backgroundColor = .white
        configureGestures()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGrid()
        delegate?.canvasView(didEndConfigureGrid: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - private
extension CanvasView {
    @objc func tapGestureAction(sender: UIGestureRecognizer) {
        delegate?.canvasView(self, didTappedPixelAt: sender.location(in: self))
    }
    
    @objc func dragGestureAction(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .began, .changed, .ended:
            delegate?.canvasView(self, didTappedPixelAt: sender.location(in: self))
        default: break
        }
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
        
        let dragGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                 action: #selector(dragGestureAction))
        dragGestureRecognizer.minimumPressDuration = 0
        addGestureRecognizer(dragGestureRecognizer)
    }
}

extension CanvasView {
    var image: UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    var pixelSize: CGFloat {
        return frame.height / CGFloat(dimension)
    }
    
    private var height: Int { return Int(frame.height) }
    
    private var width: Int { return Int(frame.width) }
}

//MARK: - public 
extension CanvasView {
    func draw(point: CGPoint, color: UIColor) {
        let y = Int(point.y / pixelSize)
        let x = Int(point.x / pixelSize)
        guard y < height && x < width && y >= 0 && x >= 0 else { return }
        pixels[y][x].backgroundColor = color
    }
    
    func draw(points: Array<CGPoint>, color: UIColor) {
        for point in points { draw(point: point, color: color) }
    }
    
    func draw(withMathimaticaly points: Array<CGPoint>, color: UIColor) {
        for point in points { drawMathPoint(point: point, color: color) }
    }
    
    func drawMathPoint(point: CGPoint, color: UIColor) {
        let x = Int(point.x)
        let y = Int(point.y)
        guard y < pixels.count && x < pixels.count && x >= 0 && y >= 0 else { return }
        let pixel = Pixel(point: CGPoint(x: x, y: y), color: color.pixelColor)
        points.append(pixel)
        pixels[y][x].backgroundColor = color
    }
    
    func drawArt(_ art: Art) {
        let pixels = art.pixels
        for pixel in pixels {
            drawMathPoint(point: pixel.point, color: pixel.color.uiColor)
        }
    }

    func clear() {
        for i in 0..<dimension {
            for j in 0..<dimension {
                pixels[i][j].backgroundColor = .white
            }
        }
        points.removeAll()
        points.append(Pixel.empty)
    }
    
    func hideGrid() {
        for i in 0..<dimension {
            for j in 0..<dimension {
                pixels[i][j].layer.borderWidth = 0
            }
        }
    }
    
    func showGrid() {
        for i in 0..<dimension {
            for j in 0..<dimension {
                pixels[i][j].layer.borderWidth = 0.5
            }
        }
    }
}


