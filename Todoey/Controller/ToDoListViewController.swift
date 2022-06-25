//
//  ViewController.swift
//  Todoey
//
//  Created by Marvellous Dirisu on 13/06/2022.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //    var itemArrays = ["apple", "ball", "cat", "door", "egg"]
    var itemArrays = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // set up the user default object
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        
        // retrives data stored in the user default
//        let newItem = Item()
//        newItem.title = "find me"
//        itemArrays.append(newItem)
//
//        let newItem1 = Item()
//        newItem1.title = "merry"
//        itemArrays.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "sharp"
//        itemArrays.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "happy"
//        itemArrays.append(newItem3)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArrays = items
//        }
        
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print("table loaded")
        
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArrays[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Refactored using ternary operator
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArrays[indexPath.row])
        
        //if itemArrays[indexPath.row].done == true {
        //            itemArrays[indexPath.row].done = false
        //        } else {
        //            itemArrays[indexPath.row].done = true
        //        }
        
        itemArrays[indexPath.row].done = !itemArrays[indexPath.row].done
        
        saveItems()
  
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        
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
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArrays.append(newItem)
            
            // saves updated array to user default
//            self.defaults.set(self.itemArrays, forKey: "ToDoListArray")
            
            self.saveItems()
            
            // reloads the table view and adds new item to the list
            
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
    
    // Encoding with NSCoder
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArrays)
            
            try data.write(to: dataFilePath!)
            
        } catch {
            print("error encoding data array\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Decoding with NSCoder
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                
            itemArrays = try decoder.decode([Item].self, from: data)
                
            } catch {
                print("error decoding data array\(error)")
            }
        }
    }
}

