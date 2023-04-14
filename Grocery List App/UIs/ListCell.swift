//
//  ListCell.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-04-13.
//

import UIKit

class ListCell: UITableViewCell {
    static let reuseIdentifier = "ListCell"

    var listLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupListLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupListLabel() {
        listLabel = UILabel()
        contentView.addSubview(listLabel)

        listLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            listLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            listLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            listLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        listLabel.numberOfLines = 0
        listLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func configureUI() {
        contentView.addSubview(listLabel)
        listLabel.translatesAutoresizingMaskIntoConstraints = false
        listLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        listLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func configure(with name: String) {
        listLabel.text = name
    }
}
