//
//  TodoListController.swift
//  Kitchen Timer
//
//  Created by Kevin Meatyard on 24/09/2018.
//  Copyright © 2018 Kevin Meatyard. All rights reserved.
//

import UIKit
import CoreData

class TodoListController: UITableViewController {
    
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
       loadItems()
    }
    
    
    //MARK - Add new actions
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var textField2 = UITextField()
        
        let alert = UIAlertController(title: "Add Meal", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen whe...
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextfield2) in
            alertTextfield2.placeholder = "Add time"
            alertTextfield2.autocapitalizationType = .words
            textField2 = alertTextfield2
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add new meal"
            alertTextfield.autocapitalizationType = .words
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated:true,completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operation
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //used for deleting item
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    
    
    func saveItems() {
    
        do{
            try context.save()
        
        } catch {
            print("Error saving context \(error)")
        }
    
        tableView.reloadData()
    
    }


    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() ) {
        
        do {
            itemArray =  try context.fetch(request)
            
        } catch {
                print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}

extension TodoListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[CD] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    
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
