//
//  EditorToolsView.swift
//  PixelEditor
//
//  Created by Jeytery on 14.12.2021.
//

import UIKit

protocol EditorToolsViewDelegate: AnyObject {
    func editorToolsViewDidenterForward()
    func editorToolsViewDidEnterBack()
}

class EditorToolsView: UIView {
    
    weak var delegate: EditorToolsViewDelegate?
    
    var points: Array<CGPoint> {
        return []
    }
    
    private let horizontalStackView = StackListView(axis: .vertical)
    
    private let additionalStackView = StackListView(axis: .horizontal)
    private let figureStackView = StackListView(axis: .horizontal)
    private let navigationStackView = StackListView(axis: .horizontal)
    
    private let slider = UISlider()
    
    init() {
        super.init(frame: .zero)
        configureAdditionalStackView()
        configureFigureStackView()
        configureNavigationStackView()
        configureHorizontalStackView()
        backgroundColor = Colors.lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension EditorToolsView {
    private func configureHorizontalStackView() {
        addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        
        horizontalStackView.addView(additionalStackView, size: 80)
        horizontalStackView.addViews([figureStackView, navigationStackView], size: 110)
    }
    
    private func configureFigureStackView() {
        let squareButton = ToolView(icon: Icons.square, size: 20)
        let circleButton = ToolView(icon: Icons.circle, size: 20)
        let polygonButton = ToolView(icon: Icons.polygon, size: 20)
        
        squareButton.didTapView = squareButtonDidTap
        circleButton.didTapView = circleButtonDidTap
        polygonButton.didTapView = polygonButtonDidTap
        
        squareButton.isSelected = true
        
        let figureButtons = [squareButton, circleButton, polygonButton]
        
        figureStackView.addViews(figureButtons, size: 110)
    }
    
    private func configureNavigationStackView() {
        let nextButton = ToolView(icon: Icons.next, size: 30)
        let returnButton = ToolView(icon: Icons.back, size: 30)
        
        let figureButtons = [returnButton,nextButton]
        
        navigationStackView.addViews(figureButtons, size: 110)
    }
    
    private func SliderView() -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 15
        
        v.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 15).isActive = true
        slider.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -15).isActive = true
        return v
    }
    
    private func configureAdditionalStackView() {
        let colorButton = ToolView(icon: Icons.lensFilled, size: 30)
        let sliderView = SliderView()
        
        additionalStackView.addView(colorButton, size: 110)
        additionalStackView.addView(sliderView, size: 210)
    }
}

//MARK: - figures stackView
extension EditorToolsView {
    
    
    private func squareButtonDidTap() {
        
    }
    
    private func circleButtonDidTap() {
        
    }
    
    private func polygonButtonDidTap() {
        
    }
}
