//
//  ArtCell.swift
//  PixelEditor
//
//  Created by BarsO_o on 19.12.2021.
//

import UIKit

class ArtCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureNameLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - private
extension ArtCell {
    private func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
}

//MARK: - public
extension ArtCell {
    func setArt(_ art: Art) {
        nameLabel.text = art.name
    }
}

