//
//  ViewController.swift
//  Todoey
//
//  Created by Ahmed Mohamed on 7/18/19.
//  Copyright © 2019 Ahmed Mohamed. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    
    var todoItems: Results<Item>?
    let realm = try! Realm()
   
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         }

    
    
    // MARK - TableView Datasource Methods
    
    //Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell",for: indexPath)
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = todoItems?[indexPath.row].title
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else
        {
            cell.textLabel?.text = "No items added"
            
        }
        
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]
        {
            do{
            try realm.write {
                realm.delete(item)
            }
            }
            catch
            {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens when user clicks add item button on alert
            print(textField.text)
            
           if let currentCategory = self.selectedCategory
           {
            do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.done = false
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
            }
            catch
            {
                print("Error in saving new item \(error)")
            }
            
            
            }
     
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
    
    func loadItems( )
    {
       todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    

}

extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count  == 0
        {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }

}
