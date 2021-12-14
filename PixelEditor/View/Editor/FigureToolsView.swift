//
//  FigureToolsView.swift
//  PixelEditor
//
//  Created by Jeytery on 14.12.2021.
//

import UIKit

protocol FigureToolsViewDelegate: AnyObject {
    func figureToolsView(_ view: UIView, didChooseCellWith index: Int)
}

class FigureToolsView: UIView {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

