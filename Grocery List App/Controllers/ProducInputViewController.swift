//
//  ProducInputViewController.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-04-09.
//

import UIKit

class ProductInputViewController : UIViewController {
        
    
    private let productInputView = ProductInputView()
    
    
    var addProductHandler: ((String, Int, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       title = "Add product"
        
        
        view.backgroundColor = .white
        setupProductInputView()
    }
    
    private func setupProductInputView(){
        productInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productInputView)
        
        NSLayoutConstraint.activate([
            productInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productInputView.heightAnchor.constraint(equalToConstant: 200) //Setting a height constraint
        ])
        
        productInputView.addProductHandler = { [weak self] brand, quantity, timeAdded in
            self?.addProductHandler?(brand, quantity, timeAdded)
            self?.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    
}
