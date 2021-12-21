//
//  ArtsViewController.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ArtsViewController: UIViewController {
    
    private let artTableView = ArtTableView()
    private let settingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureArtTableView()
        configureAddButton()
        configureSettingsButton()
        
        LoadingState.start()
       
        UserManager.shared.delegate = self
        UserManager.shared.configure()
        
        settingsVC.delegate = self
    }
}

//MARK: - ui
extension ArtsViewController {
    private func configureUI() {
        view.backgroundColor = .white
        title = "Arts"
    }
    
    private func configureArtTableView() {
        view.addSubview(artTableView)
        artTableView.translatesAutoresizingMaskIntoConstraints = false
        artTableView.setTopConstraint(self)
        artTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        artTableView.setSideConstraints(self)
        
        artTableView.delegate = self
        
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(title: "Add",
                                        style: .plain,
                                        target: self,
                                        action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func addArtCompletion(_ art: Art?, _ error: ArtError?) {
        guard error == nil, let art = art else { return print(error as Any) }
        artTableView.addArt(art)
        showEditor(art: art, dimension: art.dimension)
    }
    
    @objc func addButtonAction() {
        let addArtVC = AddArtViewController()
        addArtVC.delegate = self
        let nc = BackNavigationController(rootViewController: addArtVC)
        present(nc, animated: true, completion: nil)
    }
    
    @objc func settingsButtonAction() {
        let nc = BackNavigationController(rootViewController: settingsVC)
        present(nc, animated: true, completion: nil)
    }
    
    private func configureSettingsButton() {
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButtonAction))
        navigationItem.leftBarButtonItem = settingsButton
    }
}

//MARK: - private
extension ArtsViewController {
    private func showEditor(art: Art? = nil, dimension: Int) {
        let editorVC = EditorViewController(art: art, dimension: dimension)
        let nc = UINavigationController(rootViewController: editorVC)
        nc.modalPresentationStyle = .overCurrentContext
        editorVC.delegate = self
        present(nc, animated: true, completion: nil)
    }
    
    private func showAutorization() {
        let autorizationVC = AutorizationViewContoller()
        autorizationVC.modalPresentationStyle = .overCurrentContext
        autorizationVC.delegate = self
        present(autorizationVC, animated: false, completion: nil)
    }
}

//MARK: - [d] autorizationVC
extension ArtsViewController: AutorizationViewControllerDelegate {
    func autorizationViewController(_ viewController: UIViewController, didAutorized user: User) {
        viewController.dismiss(animated: true, completion: nil)
        title = user.name
        
        LoadingState.start()
        getArts(for: user, completion: {
            [unowned self] result in
            LoadingState.stop()
            switch result {
            case .success(let arts):
                artTableView.setArts(arts)
                break
            case .failure(let error): print(error); break
            }
        })
    }
}

//MARK: - [d] tableView
extension ArtsViewController: ArtTableViewDelegate {
    func artTableView(_ view: ArtTableView, deleteArt: Art, at: IndexPath) {
        removeArt(deleteArt)
    }
    
    func artTableView(_ view: ArtTableView, deleteLast art: Art) {}
    
    func artTableView(_ view: ArtTableView, didSelect art: Art) {
        showEditor(art: art, dimension: art.dimension)
    }
}

//MARK: - [d] editorVC
extension ArtsViewController: EditorViewControllerDelegate {
    func editorViewController(_ viewController: UIViewController, didReturn art: Art) {
        viewController.dismiss(animated: true, completion: nil)
        updateArt(art)
        artTableView.updateArt(art)
    }
}

//MARK: - [d] UserManager
extension ArtsViewController: UserManagerDelegate {
    func userManager(didGetUser arts: Arts) {
        artTableView.setArts(arts)
    }
    
    func userManager(didGet user: User) {
        title = user.name
    }
    
    func userManagerDidConfigure() {
        LoadingState.stop()
    }
    
    func userManagerDidNotGetUser() {
        showAutorization()
    }
}

//MARK: [d] settingsVC
extension ArtsViewController: SettingsViewControllerDelegate {
    func settingsViewController(_ viewController: SettingsViewController, didLogOut user: User) {
        UserManager.shared.clearUser()
        viewController.dismiss(animated: true, completion: nil)
        showAutorization()
    }
}
 
//MARK: [d] addArtVC
extension ArtsViewController: AddArtViewControllerDelegate {
    func addArtViewController(_ viewController: AddArtViewController, didReturn name: String, size: Int) {
        viewController.dismiss(animated: true, completion: nil)
        var art = Art.empty(named: name, dimension: size)
        art.key = UserManager.shared.user!.key
        addArt(art, user: UserManager.shared.user!, completion: addArtCompletion)
    }
}
