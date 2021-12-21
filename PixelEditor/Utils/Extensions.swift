//
//  Extension .swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

extension UIView {
    var bottomIndentValue: CGFloat {
        let window = UIApplication.shared.windows.first
        if #available(iOS 11.0, *) {
            let bottomPadding = window!.safeAreaInsets.bottom
            return bottomPadding
        }
        else {
            return 0
        }
    }
    
    var topIndentValue: CGFloat {
        if #available(iOS 11.0, *) {
            let bottomPadding = window!.safeAreaInsets.top
            return bottomPadding
        }
        else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    func setTopConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        }
        else {
            topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor, constant: constant).isActive = true
        }
    }
    
    func setBottomConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
        }
        else {
            bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor, constant: constant).isActive = true
        }
    }
    
    func getBottomConstraint(
        _ viewController: UIViewController,
        constant: CGFloat = 0) -> NSLayoutConstraint
    {
        if #available(iOS 11.0, *) {
            let constraint = bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: constant)
            constraint.isActive = true
            return constraint
        }
        else {
            let constraint = bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor, constant: constant)
            constraint.isActive = true
            return constraint
        }
    }
    
    func setLeftConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            leftAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leftAnchor, constant: constant).isActive = true
        }
        else {
            leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
        }
    }
    
    func setRightConstraint(_ viewController: UIViewController, constant: CGFloat = 0) {
        if #available(iOS 11.0, *) {
            rightAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.rightAnchor, constant: constant).isActive = true
        }
        else {
            rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        }
    }
    
    func setFullScreenConstraints(_ viewController: UIViewController) {
        setTopConstraint(viewController)
        setBottomConstraint(viewController)
        setLeftConstraint(viewController)
        setRightConstraint(viewController)
    }
    
    func setSideConstraints(_ viewController: UIViewController, constant: CGFloat = 0) {
        setLeftConstraint(viewController, constant: constant)
        setRightConstraint(viewController, constant: -constant)
    }
}

extension UIColor {
    var pixelColor: PixelColor {
        return PixelColor(red:   CIColor(color: self).red,
                          blue:  CIColor(color: self).blue,
                          green: CIColor(color: self).green)
    }
}
