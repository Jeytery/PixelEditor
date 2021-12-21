//
//  FigureToolsView.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

protocol FigureToolsViewDelegate: AnyObject {
    func figureToolsView(_ view: UIView, didChoose figure: Drawable)
}

class FigureToolsView: UIView {

    weak var delegate: FigureToolsViewDelegate?
    
    private let figureStackView = StackListView(axis: .horizontal)
    private let squareButton = ToolView(icon: Icons.square, size: 20)
    private let circleButton = ToolView(icon: Icons.circle, size: 20)
    private let polygonButton = ToolView(icon: Icons.polygon, size: 20)
    
    init() {
        super.init(frame: .zero)
        
        addSubview(figureStackView)
        figureStackView.translatesAutoresizingMaskIntoConstraints = false
        figureStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        figureStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        figureStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        figureStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        configureFigureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension FigureToolsView {
    private func clearSelection() {
        let arr = [squareButton, circleButton, polygonButton]
        for toolView in arr {
            toolView.isSelected = false
        }
    }
    
    private func configureFigureStackView() {
        
        squareButton.didTapView = squareButtonDidTap
        circleButton.didTapView = circleButtonDidTap
        polygonButton.didTapView = polygonButtonDidTap
    
        squareButton.isSelected = true
        
        let figureButtons = [squareButton, circleButton, polygonButton]
        figureStackView.addViews(figureButtons, size: 110)
    }
}

extension FigureToolsView {
    func squareButtonDidTap() {
        clearSelection()
        squareButton.isSelected = true
        delegate?.figureToolsView(self, didChoose: Square())
    }
    
    private func circleButtonDidTap() {
        clearSelection()
        circleButton.isSelected = true
        delegate?.figureToolsView(self, didChoose: Circle())
    }
    
    private func polygonButtonDidTap() {
        clearSelection()
        polygonButton.isSelected = true
        delegate?.figureToolsView(self, didChoose: Polygon())
    }
}


