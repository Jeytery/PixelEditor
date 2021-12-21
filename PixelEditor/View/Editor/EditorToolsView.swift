//
//  EditorToolsView.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

protocol EditorToolsViewDelegate: AnyObject {
    func editorToolViewDidTapReload()
    func editorToolViewDidTapColor()
    
    func editorToolViewShowGrid()
    func editorToolViewHideGrid()
}

class EditorToolsView: UIView {
    
    weak var delegate: EditorToolsViewDelegate?
    
    private let horizontalStackView = StackListView(axis: .vertical)
    
    private var isGridActive: Bool = true
    
    //stacks
    private let additionalStackView = StackListView(axis: .horizontal)
    private let figureStackView = FigureToolsView()
    private let navigationStackView = StackListView(axis: .horizontal)
    
    //simple elements
    private let slider = UISlider()
    private let sizeLevelLabel = UILabel()
    private let colorButton = ToolView(icon: Icons.lensFilled, size: 30)
    private let gridButton = ToolView(icon: Icons.activeGrid, size: 30)
    
    private var getFigurePoints: (Int, CGPoint) -> Array<CGPoint> = { _, _ in return [] }
    
    init() {
        super.init(frame: .zero)
        configureAdditionalStackView()
        configureNavigationStackView()
        configureHorizontalStackView()
        
        configureSlider()
        
        backgroundColor = Colors.lightGray
        figureStackView.delegate = self
        
        figureStackView.squareButtonDidTap()
        setActiveGridButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension EditorToolsView {
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
    
    private func SizeLevelView() -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 15
        
        sizeLevelLabel.textColor = .black
        sizeLevelLabel.text = "1"
        
        v.addSubview(sizeLevelLabel)
        sizeLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLevelLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        sizeLevelLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        sizeLevelLabel.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        return v
    }
}

extension EditorToolsView {
    @objc func sliderDidChangeValue() {
        sizeLevelLabel.text = String(Int(slider.value))
    }
    
    private func setActiveGridButton() {
        gridButton.setIcon(Icons.activeGrid)
        gridButton.setBorder(width: 3, color: Colors.blue)
        delegate?.editorToolViewShowGrid()
    }
    
    private func setUnactiveGridButton() {
        gridButton.setIcon(Icons.unactiveGrid)
        gridButton.setBorder(width: 0, color: Colors.blue)
        delegate?.editorToolViewHideGrid()
    }
    
    private func configureSlider() {
        slider.maximumValue = 15
        slider.minimumValue = 1
        slider.addTarget(self, action: #selector(sliderDidChangeValue), for: .valueChanged)
    }
    
    private func configureHorizontalStackView() {
        addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        
        horizontalStackView.addView(additionalStackView, size: 80)
        horizontalStackView.addView(figureStackView, size: 110)
        horizontalStackView.addView(navigationStackView, size: 90)        
    }
    
    private func configureNavigationStackView() {
        let reloadButton = ToolView(icon: Icons.reload, size: CGSize(width: 25, height: 30))
        
        reloadButton.didTapView = {
            [unowned self] in
            delegate?.editorToolViewDidTapReload()
        }
        
        gridButton.didTapView = {
            [unowned self] in
            isGridActive = !isGridActive
            if isGridActive == true {
                setActiveGridButton()
            }
            else {
                setUnactiveGridButton()
            }
        }
        
        navigationStackView.addView(reloadButton, size: 110)
        navigationStackView.addView(gridButton, size: 110)
    }
    
    private func configureAdditionalStackView() {
        
        let sliderView = SliderView()
        let sizeLevelView = SizeLevelView()
        
        colorButton.didTapView = {
            [unowned self] in
            delegate?.editorToolViewDidTapColor()
        }
        
        additionalStackView.addView(colorButton, size: 110)
        additionalStackView.addView(sliderView, size: 210)
        additionalStackView.addView(sizeLevelView, size: 80)
    }
}

//MARK: - [d] FigureStackView
extension EditorToolsView: FigureToolsViewDelegate {
    func figureToolsView(_ view: UIView, didChoose figure: Drawable) {
        getFigurePoints = figure.getPoints
    }
}

//MARK: - public
extension EditorToolsView {
    func getPoints(on point: CGPoint) -> Array<CGPoint> {
        let size = Int(slider.value)
        return getFigurePoints(size, point)
    }
    
    func setColorForColorButton(_ color: UIColor) {
        colorButton.setBorder(width: 3, color: color)
    }
}

