//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andy W on 3/13/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
            super.viewDidLoad()
            print("________")
            loadItems()
        }
 

//MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }

//MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.addItem, style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveItems()
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
     }
    
//MARK: - TableView Delegate Methods
    
    
//MARK: - Data Manipulation Methods
        func saveItems() {
        do {
            try context.save()
        } catch {
            print("---------- Error saving item: \(error)")
        }
            tableView.reloadData()
        }
        
        func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("---------- Fetch Request Error: \(error)")
        }
            tableView.reloadData()
        }
}

