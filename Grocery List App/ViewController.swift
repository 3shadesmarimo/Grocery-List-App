//
//  ViewController.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-03-29.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let databaseRef = Database.database().reference()
    private var groceryItems: [[String: Any]] = []
    private var tableView: CustomTableView!
    private let productInputView = ProductInputView()
    var listKey: String?
    let dateFormatter = DateFormatter()
    //Instance variable to store the index path of the cell being edited
    private var indexPathForEditing: IndexPath?
     
    
    init(listKey: String) {
        self.listKey = listKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    private func fetchData() {
        print("Fetching products from Firebase")
        guard let listKey = listKey else {
            print("No list selected")
            return
        }
        databaseRef.child("Lists").child(listKey).child("Products").observe(.value) { [weak self] snapshot in
            // Process snapshot and store products in the `products` array
            var fetchedProducts: [[String: Any]] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot, let productData = childSnapshot.value as? [String: Any] {
                    var product = productData
                    product["Key"] = childSnapshot.key
                    fetchedProducts.append(product)
                }
            }
            self?.groceryItems = fetchedProducts
            self?.tableView.reloadData()
        }
    }


    
    private func addProduct(brand: String, quantity: Int, timeAdded: String) {
        guard let listKey = listKey else {
            print("No list selected")
            return
        }
        let productRef = databaseRef.child("Lists").child(listKey).child("Products").childByAutoId()
        let productData: [String: Any] = ["Brand": brand, "Quantity": quantity, "TimeAdded": Date().description]
        productRef.setValue(productData) { [weak self] (error, reference) in
            if let error = error {
                print("Error adding product to database: \(error.localizedDescription)")
            } else {
                print("Product added to database successfully")
                self?.fetchData()
            }
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0 // Set the desired height for table view cells
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(groceryItems.count)")
        return groceryItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroceryItemCell.reuseIdentifier, for: indexPath) as! GroceryItemCell
        let product = groceryItems[indexPath.row]
        
        
        
        if let brand = product["Brand"] as? String,
           let quantity = product["Quantity"] as? Int,
           let timeAdded = product["TimeAdded"] as? String {
            
            let formattedText = """
            Brand: \(brand)\n
            Quantity: \(quantity)\n
            Time Added: \(timeAdded)\n
            """
           
            
            cell.customLabel.numberOfLines = 8
            cell.customLabel.font = UIFont.systemFont(ofSize: 16)
            cell.customLabel.text = formattedText
            
        }
        
        //Add a tap gesture for the cell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }


    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        //Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){[weak self] (action, view, completionHandler) in
            //Perform the delete action here
            self?.deleteItem(at: indexPath)
            completionHandler(true)
        }
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Save the index path for later use
        indexPathForEditing = indexPath
        
        //Create the edit view and add it to the view hierarchy
        let editView = GroceryItemEditView()
        editView.frame = view.bounds
        view.addSubview(editView)
        
        //Set the completion handler to update the data in Firebase
        editView.editCompletionHandler = { [weak self] brand, quantity in
            guard let indexPath = self?.indexPathForEditing, let item = self?.groceryItems[indexPath.row], let itemKey = item["Key"] as? String else {
                return
            }
            
            let productData: [String: Any] = ["Brand": brand, "Quantity": quantity, "TimeAdded": item["TimeAdded"] ?? Date().description]
            self?.databaseRef.child("Lists").child(self?.listKey ?? "").child("Products").child(itemKey).setValue(productData)
            editView.removeFromSuperview()
        }
    }
    
    
    func deleteItem(at indexPath: IndexPath) {
        //Get the item and its key
        let item = groceryItems[indexPath.row]
        if let listKey = listKey, let itemKey = item["Key"] as? String {
            //Remove the item from the Firebase database
            databaseRef.child("Lists").child(listKey).child("Products").child(itemKey).removeValue()
        }
        
        //Remove the item from the datasource
        groceryItems.remove(at: indexPath.row)
        //Delete the row from the table view with an animation
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shopping List"
        setupTableView()
        //setupProductInputView()
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentProductInputViewController))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch data for the selected list
        if let listKey = (navigationController?.viewControllers.first as? ListViewController)?.selectedListKey {
            self.listKey = listKey
            fetchData()
        }
    }
    
    
    
    
        
    private func setupTableView() {
        tableView = CustomTableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(GroceryItemCell.self, forCellReuseIdentifier: GroceryItemCell.reuseIdentifier)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.isHidden = false
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = true
    }
    
    
    private func setupProductInputView() {
        productInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productInputView)
        
        NSLayoutConstraint.activate([
              productInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              productInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              productInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              productInputView.heightAnchor.constraint(equalToConstant: 200) // Set a height constraint
          ])
        
        productInputView.addProductHandler = { [weak self] brand, quantity, timeAdded in
            self?.addProduct(brand: brand, quantity: quantity, timeAdded: timeAdded)
        }


    }
    
    @objc func presentProductInputViewController(){
        let productInputVC = ProductInputViewController()
        productInputVC.addProductHandler = { [weak self] brand, quantity, timeAdded in
            self?.addProduct(brand: brand, quantity: quantity, timeAdded: timeAdded)
        }
        
        navigationController?.pushViewController(productInputVC, animated: true)
    }
    
    @objc private func cellTapped(_ gestureResognizer: UITapGestureRecognizer){
        guard let tappedCell = gestureResognizer.view as? GroceryItemCell, let indexPath = tableView.indexPath(for: tappedCell) else {
            return
        }
        
        tableView(tableView, didSelectRowAt: indexPath)
    }


}



