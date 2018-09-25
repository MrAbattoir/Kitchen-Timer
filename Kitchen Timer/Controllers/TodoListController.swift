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
    var selectedCatagory : Catagory? {
        didSet{
            navigationItem.title = selectedCatagory?.name
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100.0
        
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK - Add new actions
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var textField2 = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what will happen whe...
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.timeCook = textField2.text!
            newItem.done = false
            newItem.parentCatagory = self.selectedCatagory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add Item"
            alertTextfield.autocapitalizationType = .words
            textField = alertTextfield
        }
        
        alert.addTextField { (alertTextfield2) in
            alertTextfield2.placeholder = "Add Cook Time"
            alertTextfield2.autocapitalizationType = .words
            alertTextfield2.keyboardType = .numberPad
            textField2 = alertTextfield2
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
        cell.detailTextLabel?.text = item.timeCook
       
        
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
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // tableView.deleteRows(at: [indexPath], with: .fade)
            
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
   
    
    
    func saveItems() {
    
        do{
            try context.save()
        
        } catch {
            print("Error saving context \(error)")
        }
    
        tableView.reloadData()
    
    }


    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate: NSPredicate? = nil) {
        
        
        let catagoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCatagory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagoryPredicate,additionalPredicate])
        } else{
            request.predicate = catagoryPredicate
        }
        
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
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
        loadItems(with: request, predicate: predicate)
    
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
