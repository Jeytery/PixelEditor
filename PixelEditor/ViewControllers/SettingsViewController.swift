//
//  SettingsViewController.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewController(_ viewController: SettingsViewController, didLogOut user: User)
}

class SettingsViewController: UIViewController {
        
    weak var delegate: SettingsViewControllerDelegate?
    
    private var list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureList()
        
        view.backgroundColor = .white
        title = "Settings"
    }
    
    private func configureList() {
        if #available(iOS 13.0, *) {
            list = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            list = UITableView(frame: .zero, style: .grouped)
        }
        
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.setTopConstraint(self)
        list.setSideConstraints(self)
        list.setBottomConstraint(self)
        
        list.delegate = self
        list.dataSource = self
        
        list.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Log out"
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0, let user = UserManager.shared.user else { return }
        delegate?.settingsViewController(self, didLogOut: user)
    }
}
