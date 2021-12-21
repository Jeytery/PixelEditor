//
//  Icons.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

class Icons {
    static func Icon(_ name: String) -> UIImage {
        return UIImage(named: name) ?? UIImage()
    }
    
    static let square =  Icon("square")
    static let circle =  Icon("circle")
    static let polygon = Icon("polygon")
    
    static let next = Icon("next")
    static let back = Icon("keyboard_return")
    
    static let cross = Icon("cross")
    static let upload = Icon("upload")
    
    static let lens = Icon("lens")
    static let lensFilled = Icon("lens_filled")
    static let reload = Icon("reload")
    static let tick = Icon("tick")
    
    static let activeGrid = Icon("active_grid")
    static let unactiveGrid = Icon("unactive_grid")
    
    static let vector = UIImage(named: "vector")!.withRenderingMode(.alwaysTemplate)
}

