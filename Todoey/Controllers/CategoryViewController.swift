//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ahmed Mohamed on 8/16/19.
//  Copyright © 2019 Ahmed Mohamed. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoriesArray = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

        
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add categoty", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            print(textField.text!)
            newCategory.name = textField.text!
            self.categoriesArray.append(newCategory)
            self.saveCategories()
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
    //MARK : - Table view datasoucre methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destination.selectedCategory = self.categoriesArray[indexPath.row]
            
        }
        
    }
    //MARK: - Data Manipulation methods
    
    func saveCategories()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error in saving category \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do
        {
            try categoriesArray = context.fetch(request)
        }
        catch
        {
            print("Error in loading categories \(error)")
        }
    }

    //MARK: - TableView Delegate methods

}
