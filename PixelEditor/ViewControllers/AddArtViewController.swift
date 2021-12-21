//
//  AddArtViewController.swift
//  PixelEditor
//
//  Created by BarsO_o on 21.12.2021.
//

import UIKit

protocol AddArtViewControllerDelegate: AnyObject {
    func addArtViewController(_ viewController: AddArtViewController, didReturn name: String, size: Int)
}

class AddArtViewController: UIViewController {

    weak var delegate: AddArtViewControllerDelegate?
    
    private let list = StackListView(axis: .vertical)
    private let slider = UISlider()
    private let nameTextField = DescTextFieldView(title: "Enter name",
                                                  placeholder: "For exampla: robot")
    private let sizeLabel = UILabel()
    private let okButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        okButton.setPrimaryStyle(icon: Icons.tick, color: Colors.primary)
        okButton.addTarget(self, action: #selector(okButtonAction), for: .touchDown)
        
        configureSlider()
        configureSizeLabel()
        
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setTopConstraint(self)
        list.setSideConstraints(self, constant: 20)
        list.setBottomConstraint(self)
        
        list.addViews([sizeLabel, slider], size: 50)
        list.addView(nameTextField, size: 100)
        list.addView(okButton, size: 60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ui
extension AddArtViewController {
    @objc func okButtonAction() {
        print("123")
//        guard nameTextField.text != "" else {
//            nameTextField.setError(text: "Enter name, please!")
//            return
//        }
        print(delegate)
        delegate?.addArtViewController(self,
                                       didReturn: nameTextField.text,
                                       size: Int(slider.value))
    }
    
    @objc func sliderAction() {
        sizeLabel.text = "Canvas size: \(Int(slider.value))"
    }
    
    private func configureSlider() {
        slider.minimumValue = 1
        slider.maximumValue = 64
        slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
    }
    
    private func configureSizeLabel() {
        sizeLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        sizeLabel.text = "Canvas size: 1"
    }
}
