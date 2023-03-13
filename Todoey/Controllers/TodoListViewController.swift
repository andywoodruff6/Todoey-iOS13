//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    
    //MARK: - Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.toDoItemCell, for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark :  .none
        
        //        print("call")
        return cell
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("item \(itemArray[indexPath.row]) pressed.")
        
        //removes item from the db
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        //        saveItems()
        
        //sets the variable to the opposite of whatever it currently is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - Add Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.addItem, style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on the Alert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("---------- Error saving item: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("---------- Fetch Request Error: \(error)")
        }
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //When the search is executed, the searchBar.text property is set to what was typed in
        print(searchBar.text!)
        
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sortDesc. is looking for an array of sort options, so we have to put our single
        // sort into an array.
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
