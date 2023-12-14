//
//  ViewController.swift
//  ENRealmSwift
//
//  Created by dsm 5e on 14.12.2023.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private let manager = NewRealmManager()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.frame = view.frame
        table.register(UITableViewCell.self, forCellReuseIdentifier: "self")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Realm CRUD"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { _ in
            self.createAlert()
        }))
    }
    
    private func createAlert() {
        let alert = UIAlertController(title: "Add Item", message: "New item for you", preferredStyle: .alert)
        alert.addTextField { titleTextField in
            titleTextField.placeholder = "Add title"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let title = alert.textFields?[0].text, !title.isEmpty else {
                // Show another alert for empty text field
                let emptyAlert = UIAlertController(title: "Error", message: "Title cannot be empty", preferredStyle: .alert)
                emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.createAlert() // Show the original alert again
                }))
                self.present(emptyAlert, animated: true)
                return
            }

            let item = ToDoItem()
            item.title = title
            self.manager.addNewItem(item: item)
            self.tableView.reloadData()
        }

        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "self", for: indexPath)
        cell.textLabel?.text = manager.allItems[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemId = manager.allItems[indexPath.row].id
            manager.deleteItem(id: itemId)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
