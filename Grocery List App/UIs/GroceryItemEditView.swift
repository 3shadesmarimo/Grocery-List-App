//
//  GroceryItemEditView.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-04-14.
//

import UIKit

class GroceryItemEditView: UIView {
    
    // MARK: - Properties
    
    private let brandTextField = UITextField()
    private let quantityTextField = UITextField()
    private let doneButton = UIButton()
    private let cancelButton = UIButton()
    
    var editCompletionHandler: ((String, Int) -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        // Brand text field
        brandTextField.placeholder = "Brand"
        brandTextField.borderStyle = .roundedRect
        addSubview(brandTextField)
        
        brandTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brandTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            brandTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            brandTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            brandTextField.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        // Quantity text field
        quantityTextField.placeholder = "Quantity"
        quantityTextField.borderStyle = .roundedRect
        quantityTextField.keyboardType = .numberPad
        addSubview(quantityTextField)
        
        quantityTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityTextField.topAnchor.constraint(equalTo: brandTextField.bottomAnchor, constant: 20),
            quantityTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quantityTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            quantityTextField.heightAnchor.constraint(equalTo: brandTextField.heightAnchor)
        ])
        
        // Done button
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .systemBlue
        doneButton.layer.cornerRadius = 5
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        addSubview(doneButton)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 20),
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
            
        ])
        
        // Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalTo: doneButton.heightAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped() {
        guard let brand = brandTextField.text, let quantityString = quantityTextField.text, let quantity = Int(quantityString) else {
            return
        }
        
        editCompletionHandler?(brand, quantity)
    }
    
    @objc private func cancelButtonTapped() {
        removeFromSuperview()
    }
    
}

