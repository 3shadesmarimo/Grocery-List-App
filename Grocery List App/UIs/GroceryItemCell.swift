//
//  GroceryItemCell.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-04-05.
//

import UIKit

class GroceryItemCell: UITableViewCell {
    
    static let reuseIdentifier = "GroceryItemCell"
    let customLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCustomLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomLabel() {
        contentView.addSubview(customLabel)
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            customLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12)
        ])
    }
}
