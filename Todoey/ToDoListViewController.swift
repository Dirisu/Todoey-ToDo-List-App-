//
//  ViewController.swift
//  Todoey
//
//  Created by Marvellous Dirisu on 13/06/2022.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArrays = ["apple", "ball", "cat", "door", "egg"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrives data stored in the user default
//        itemArrays = defaults.array(forKey: "ToDoListArray") as! [String]
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArrays = items
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArrays[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArrays[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // add new item using UIAlert
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // create a global textField variable to be used in the addButtonPressed
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        // alert action button
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // adds text to item arrays
            self.itemArrays.append(textField.text!)
            
            // saves updated array to user default
            self.defaults.set(self.itemArrays, forKey: "ToDoListArray")
            
            // reloads the table view and adds new item to the list
            self.tableView.reloadData()
        }
        
        // creates textfield + placeholder
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
            
        }
        // add action to the alert
        alert.addAction(action)
        
        // show alert on screen
        present(alert, animated: true, completion: nil)
    }
}

