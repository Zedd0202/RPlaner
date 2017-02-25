//
//  ToDoListViewController.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoListViewController: UITableViewController {
    
    
    let realm = try? Realm()
    var todoList = ToDoList()
    var todo: ToDo?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
  
        
        let realm = try? Realm()

        self.todoList.items = realm?.objects(ToDo.self)
        
        self.title = "RPlaner"
        
        self.navigationItem.backBarButtonItem?.tintColor = .white

    }
    @IBAction func addButtonTapped(_ sender: Any) {
        self.todo = nil
        self.performSegue(withIdentifier: "toNewToDoViewController", sender: self)
    }
   
    
    @IBOutlet weak var addButton: UIBarButtonItem?
   
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoListViewCell
        cell?.todo = (todoList.items?[indexPath.row])
        return cell!
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
  
    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ToDoListViewCell
        self.todo = cell.todo
        self.performSegue(withIdentifier: "toDetailToDoViewController", sender: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailToDoViewController") {
            let newToDoVC = segue.destination as! ToDoDetailViewController
            newToDoVC.todo = self.todo
        }
        if (segue.identifier == "toNewToDoViewController") {
            if let navi = segue.destination as? UINavigationController, let newToDoVC = navi.viewControllers.first as? NewToDoCreateViewController, let todo = sender as? ToDo {
            
                newToDoVC.todo = todo
            }
        }
        
    }
    
    var deleteTableIndexPath: NSIndexPath? = nil
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            print("a")
            
            if let cell: ToDoListViewCell = tableView.cellForRow(at: editActionsForRowAt) as? ToDoListViewCell {
            self.performSegue(withIdentifier: "toNewToDoViewController", sender: cell.todo)
            }

        }
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            tableView.beginUpdates()
            self.todoList.delete(index: editActionsForRowAt.row)
            let indexPaths = NSIndexPath(row: editActionsForRowAt.row, section: editActionsForRowAt.section)
            
            tableView.deleteRows(at: [indexPaths as IndexPath], with: .automatic)
            
            tableView.endUpdates()
            print(self.todoList.items?.count)
                        tableView.reloadData()
        }
        
        return [delete,edit]
    }
    
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
            tableView.beginUpdates()

            let sortedStuff = realm?.objects(ToDo.self).sorted(byKeyPath: "planTitle", ascending: true)
            
            self.todoList.items = sortedStuff
            
            tableView.reloadData()
            tableView.endUpdates()

            
            
            
        } else if sender.selectedSegmentIndex == 0 {
            
            // 제목대신 날짜로 바꾸기
            let sortedStuffs = realm?.objects(ToDo.self).sorted(byKeyPath: "createdAt", ascending: false)
            
            self.todoList.items = sortedStuffs
            self.tableView.reloadData()
            
        }
    }
    
    
    
    
   
    
    @IBAction func returnToDoList(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
}
