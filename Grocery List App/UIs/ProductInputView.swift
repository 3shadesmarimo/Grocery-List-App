//
//  ProductInputView.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-04-05.
//

import UIKit

class ProductInputView: UIView {
    
    private let brandTextField = UITextField()
    private let quantityTextField = UITextField()
    private let timeAddedDatePicker = UIDatePicker()
    private let addButton = UIButton(type: .system)
    
    
    private let inputStackView = UIStackView()
    
    var addProductHandler: ((String, Int, String) -> Void)?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInputFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPreFilledData(brand: String, quantity: Int, timeAdded: String) {
        brandTextField.text = brand
        quantityTextField.text = "\(quantity)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if let date = dateFormatter.date(from: timeAdded) {
            timeAddedDatePicker.setDate(date, animated: false)
        }
        
    }
    
    private func setupInputFields() {
        brandTextField.placeholder = "Brand"
        brandTextField.borderStyle = .roundedRect
        quantityTextField.placeholder = "Quantity"
        quantityTextField.borderStyle = .roundedRect
        quantityTextField.keyboardType = .numberPad
        /*
        timeAddedDatePicker.datePickerMode = .date
        timeAddedDatePicker.preferredDatePickerStyle = .compact
        timeAddedDatePicker.minimumDate = Date()
         */
        
        

        addButton.setTitle("Add Product", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        inputStackView.axis = .vertical
        inputStackView.spacing = 8
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addArrangedSubview(brandTextField)
        inputStackView.addArrangedSubview(quantityTextField)
        //inputStackView.addArrangedSubview(timeAddedDatePicker)
        inputStackView.addArrangedSubview(addButton)
        

        addSubview(inputStackView)
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            inputStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            inputStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
  
    
    @objc private func addButtonTapped(){
        guard let brand = brandTextField.text, !brand.isEmpty,
              let quantityString = quantityTextField.text, !quantityString.isEmpty,
              let quantity = Int(quantityString) else {
            //Display an alert when the input is incorrect
            let alertController = UIAlertController(title: "Incorrect input", message: "Please fill in all fields with valid information", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            if let viewController = self.window?.rootViewController {
                viewController.present(alertController, animated: true)
            }
            
            return
        }
        
        let currentDate = Date()
        let timeAdded = DateFormatter.localizedString(from: currentDate, dateStyle: .short, timeStyle: .none)
        
        addProductHandler?(brand, quantity, timeAdded)
        brandTextField.text = ""
        quantityTextField.text = ""
        
    }
    
  

}

