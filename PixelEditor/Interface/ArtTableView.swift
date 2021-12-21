//
//  ArtTableView.swift
//  PixelEditor
//
//  Created by BarsO_o on 19.12.2021.
//

import UIKit

protocol ArtTableViewDelegate: AnyObject {
    func artTableView(_ view: ArtTableView, deleteArt: Art, at: IndexPath)
    func artTableView(_ view: ArtTableView, deleteLast art: Art)
    func artTableView(_ view: ArtTableView, didSelect art: Art)
}

class ArtTableView: UIView {
    
    weak var delegate: ArtTableViewDelegate?
    
    private var arts: Arts

    private var tableView: UITableView!
    
    init(arts: Arts = []) {
        self.arts = arts
        super.init(frame: .zero)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArtTableView {
    private func configureTableView() {
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: .zero, style: .grouped)
        }
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tableView.register(ArtCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ArtTableView {
    private func addEmptyArt() {
        
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
}

extension ArtTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return arts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArtCell
        let art = arts[indexPath.row]
        cell.setArt(art)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let art = arts[indexPath.row]
        delegate?.artTableView(self, didSelect: art)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.artTableView(self, deleteArt: arts[indexPath.row], at: indexPath)
            arts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ArtTableView {
    func addArt(_ art: Art) {
        arts.append(art)
        reloadData()
    }
    
    func updateArt(_ art: Art) {
        for i in 0..<arts.count {
            let _art = arts[i]
            guard _art.key == art.key else { continue }
            arts.remove(at: i)
            arts.insert(art, at: i)
        }
        reloadData()
    }
    
    func setArts(_ arts: Arts) {
        self.arts = arts
        reloadData()
    }
}
