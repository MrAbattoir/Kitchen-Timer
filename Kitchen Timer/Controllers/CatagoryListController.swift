//
//  CatagoryListController.swift
//  Kitchen Timer
//
//  Created by Kevin Meatyard on 25/09/2018.
//  Copyright © 2018 Kevin Meatyard. All rights reserved.
//

import UIKit
import CoreData

class CatagoryListController: UITableViewController {

    var catagoryArray = [Catagory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100.0
        loadCatagorys()
        
    }

//MARK - Add new actions
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Meal", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what will happen whe...
            
            
            
            let newCatagory = Catagory(context: self.context)
            newCatagory.name = textField.text!
            self.catagoryArray.append(newCatagory)
            
            self.saveCatagorys()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Meal Description"
            alertTextfield.autocapitalizationType = .words
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated:true,completion: nil)
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        
        cell.textLabel?.text = catagoryArray[indexPath.row].name
        
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        //tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCatagory = catagoryArray[indexPath.row]
        }
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
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }



    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func saveCatagorys(){
        do{
            try context.save()
            
        } catch {
            print("Error saving catagory \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadCatagorys(with request: NSFetchRequest<Catagory> = Catagory.fetchRequest() ) {
        
        do {
            catagoryArray =  try context.fetch(request)
            
        } catch {
            print("Error fetching vatagory from context \(error)")
        }
        
        tableView.reloadData()
        
        
    }

}


