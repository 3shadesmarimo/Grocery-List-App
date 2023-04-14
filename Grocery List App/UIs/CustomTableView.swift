//
//  CustomTableView.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-04-05.
//

import UIKit
import FirebaseFirestore

class CustomTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style){
        super.init(frame: frame, style: style)
        setupTableView()
    }
        
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        
        
    }

    private func setupTableView(){
        self.register(GroceryItemCell.self, forCellReuseIdentifier: GroceryItemCell.reuseIdentifier)
    }
}
