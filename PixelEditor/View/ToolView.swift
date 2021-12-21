//
//  ToolView.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

class ToolView: UIView {
    
    var didTapView: VoidFunc? = nil
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                layer.borderWidth = 3
            }
            else {
                layer.borderWidth = 0
            }
        }
    }
        
    private let mainImageView = UIImageView()
    
    init(icon: UIImage, size: CGFloat) {
        super.init(frame: .zero)
        configureUI()
        addImageView(iconSize: CGSize(width: size, height: size), icon: icon)

    }
    
    init(icon: UIImage, size: CGSize) {
        super.init(frame: .zero)
        configureUI()
        addImageView(iconSize: size, icon: icon)
    }
    
    private func addImageView(iconSize: CGSize, icon: UIImage) {
        mainImageView.image = icon
        addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: iconSize.height).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: iconSize.width).isActive = true
    }
    
    private func configureUI() {
        backgroundColor = .white
        layer.borderColor = Colors.blue.cgColor
        layer.cornerRadius = 10
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc func tapAction() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            [weak self] in
            self?.alpha = 0.3
            self?.mainImageView.alpha = 0.3
        })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            [weak self] in
            self?.alpha = 1
            self?.mainImageView.alpha = 1
        })
        didTapView?()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func setIcon(_ icon: UIImage) {
        mainImageView.image = icon
    }
}
