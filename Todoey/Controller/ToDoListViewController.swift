//
//  ViewController.swift
//  Todoey
//
//  Created by Marvellous Dirisu on 13/06/2022.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArrays = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArrays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArrays[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArrays[indexPath.row].done = !itemArrays[indexPath.row].done
        
//        context.delete(itemArrays[indexPath.row])
//        itemArrays.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // add new item using UIAlert
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        // alert action button
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // adds text to item arrays
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArrays.append(newItem)
            
            self.saveItems()
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
    
    // create/save item to core data
    func saveItems() {
        
        do {
            try context.save()
            
        } catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
//    // fetching data from coredata
    func loadItems() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArrays = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context")
        }
        
        tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
    // fetch result from search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        print(searchBar.text)
        
        // query objects in coredata (how objects should be fetched)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        do {
            itemArrays = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context")
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
