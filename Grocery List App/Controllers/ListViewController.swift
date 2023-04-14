//
//  ListViewController.swift
//  Grocery List App
//
//  Created by Bilegt Davaa on 2023-04-13.
//

import UIKit
import FirebaseDatabase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let databaseRef = Database.database().reference()
    private var lists: [[String: Any]] = []
    private var tableView: UITableView!
    var selectedListKey: String?
    
    
    private func fetchData() {
        print("Fetching lists from Firebase")
        databaseRef.child("Lists").observe(.value) { [weak self] snapshot in
            // Process snapshot and store lists in the `lists` array
            var fetchedLists: [[String: Any]] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot, let listData = childSnapshot.value as? [String: Any] {
                    var list = listData
                    list["Key"] = childSnapshot.key
                    fetchedLists.append(list)
                }
            }
            self?.lists = fetchedLists
            self?.tableView.reloadData()
        }
    }
    
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none // Removes the separator lines
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Set row height to 70 points
        tableView.rowHeight = 70
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure list cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as! ListCell
        let list = lists[indexPath.row]
        
        if let listName = list["Name"] as? String {
            cell.textLabel?.text = listName
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let list = lists[indexPath.row]
        if let listKey = list["Key"] as? String {
            selectedListKey = listKey
            let viewController = ViewController(listKey: listKey)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addList))
        title = "Lists"
        setupTableView()
        fetchData()
    }
    
    private func addListToDatabase(name: String) {
        let listRef = databaseRef.child("Lists").childByAutoId()
        let listData: [String: Any] = ["Name": name]
        listRef.setValue(listData) { [weak self] (error, reference) in
            if let error = error {
                print("Error adding list to database: \(error.localizedDescription)")
            } else {
                print("List added to database successfully")
                self?.fetchData()
            }
        }
    }
    
    @objc func addList() {
        let alertController = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter List Name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] (_) in
            if let listName = alertController?.textFields?[0].text {
                self?.addListToDatabase(name: listName)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }


    

    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

