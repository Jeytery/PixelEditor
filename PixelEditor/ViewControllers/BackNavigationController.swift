//
//  BackNavigationController.swift
//  PixelEditor
//
//  Created by Jeytery on 21.12.2021.
//

import UIKit

class BackNavigationController: UINavigationController {

    @objc func action() {
        dismiss(animated: true, completion: nil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        let doneButton = UIBarButtonItem(image: Icons.cross,
                                         style: .plain,
                                         target: self,
                                         action: #selector(action))
        topViewController?.navigationItem.rightBarButtonItem = doneButton
        doneButton.tintColor = .gray
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
