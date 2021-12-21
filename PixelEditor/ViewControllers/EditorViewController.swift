//
//  EditorViewController.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

protocol EditorViewControllerDelegate: AnyObject {
    func editorViewController(_ viewController: UIViewController, didReturn art: Art)
}

class EditorViewController: UIViewController {
    
    weak var delegate: EditorViewControllerDelegate?
    
    private let canvasView: CanvasView
    private let editorToolsView = EditorToolsView()
    
    private var pixelColor: UIColor = .red
    
    private let colorPickerVC = ColorPickerViewController()
    private var art: Art?
    
    init(art: Art?, dimension: Int) {
        self.art = art
        canvasView = CanvasView(dimension: dimension)
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .lightGray
        configureUI()
        configreCanvas()
        
        if let art = art { canvasView.drawArt(art) }
        
        configureEditToolsView()
        configureCloseButton()
        configureUploadButton()
        
        canvasView.delegate = self
        editorToolsView.delegate = self
        colorPickerVC.delegate = self
        
        editorToolsView.setColorForColorButton(.red)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension EditorViewController {
    private func configureUI() {
        title = art?.name ?? "Editor"
    }
    
    private func configreCanvas() {
        view.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        canvasView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        canvasView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    private func configureEditToolsView() {
        view.addSubview(editorToolsView)
        editorToolsView.translatesAutoresizingMaskIntoConstraints = false
        editorToolsView.topAnchor.constraint(equalTo: canvasView.bottomAnchor).isActive = true
        editorToolsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        editorToolsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        editorToolsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configureCloseButton() {
        let doneButton = UIBarButtonItem(image: Icons.cross,
                                         style: .plain,
                                         target: self,
                                         action: #selector(closeButtonAction))
        navigationItem.leftBarButtonItem = doneButton
        doneButton.tintColor = .gray
    }
    
    private func configureUploadButton() {
        let uploadButton = UIBarButtonItem(image: Icons.upload,
                                         style: .plain,
                                         target: self,
                                         action: #selector(uploadButtonAction))
        navigationItem.rightBarButtonItem = uploadButton
        uploadButton.tintColor = .gray
    }
    
    @objc func closeButtonAction() {
        art?.pixels = canvasView.points
        art?.userKey = UserManager.shared.user!.key
        delegate?.editorViewController(self, didReturn: art ?? Art.empty)
    }
    
    @objc func uploadButtonAction() {
        let image = canvasView.image
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [.airDrop, .postToFacebook]
        present(activityViewController, animated: true, completion: nil)
    }
}

//MARK: - [d] CanvasView
extension EditorViewController: CanvasViewDelegate {
    func canvasView(didEndConfigureGrid view: CanvasView) {
        guard let art = art else { return }
        view.drawArt(art)
    }
    
    func canvasView(_ view: CanvasView, didTappedPixelAt point: CGPoint) {
        
        let mathPoint = CGPoint(x: point.x / canvasView.pixelSize,
                                y: point.y / canvasView.pixelSize)
        
        let points = editorToolsView.getPoints(on: mathPoint)
        
        canvasView.draw(withMathimaticaly: points, color: pixelColor)
    }
}

//MARK: - [d] EditorTools
extension EditorViewController: EditorToolsViewDelegate {
    func editorToolViewShowGrid() {
        canvasView.showGrid()
    }
    
    func editorToolViewHideGrid() {
        canvasView.hideGrid()
    }
    
    func editorToolViewDidTapReload() {
        canvasView.clear()
    }
    
    func editorToolViewDidTapColor() {
        let nc = BackNavigationController(rootViewController: colorPickerVC)
        present(nc, animated: true, completion: nil)
    }
}

//MARK: - [d] ColorPickerVC
extension EditorViewController: ColorPickerViewControllerDelegate {
    func colorPicker(_ viewController: UIViewController, didChoose color: UIColor) {
        viewController.dismiss(animated: true, completion: nil)
        pixelColor = color
        editorToolsView.setColorForColorButton(color)
    }
}

