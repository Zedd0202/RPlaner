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
    //var aa = Count()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.view.backgroundColor = UIColor(red: CGFloat(238 / 255.0), green: CGFloat(238 / 255.0), blue: CGFloat(238 / 255.0), alpha: 1)
        
        self.title = "RPlaner"
        addButton?.target = self
        addButton?.action = #selector(ToDoListViewController.onClickAddButton(sender:))
        
        
    }
    func onClickAddButton(sender: UIBarButtonItem) {
        self.todo = nil
        self.performSegue(withIdentifier: "toNewToDoViewController", sender: self)
    }
    
    @IBOutlet weak var addButton: UIBarButtonItem?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        return 50.0
    }
    
    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ToDoListViewCell
        self.todo = cell.todo
        self.performSegue(withIdentifier: "toDetailToDoViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailToDoViewController") {
            let newToDoVC = segue.destination as! ToDoDetailViewController
            newToDoVC.todo = self.todo
        }
    }
    var deleteTableIndexPath: NSIndexPath? = nil
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            
        }
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            tableView.beginUpdates()
            self.todoList.delete(index: editActionsForRowAt.row)
            let indexPaths = NSIndexPath(row: editActionsForRowAt.row, section: editActionsForRowAt.section)
            
            tableView.deleteRows(at: [indexPaths as IndexPath], with: .automatic)
            //self.aa.completeTodo.remove(at: editActionsForRowAt.row)
            tableView.endUpdates()
            print(self.todoList.items?.count)
            //            self.deleteTableIndexPath = editActionsForRowAt as NSIndexPath?
            //            self.confirmDelete(planet: "tableToDelete")
            
        }
        
        return [delete,edit]
    }
    //    func confirmDelete(planet: String) {
    //        let alert = UIAlertController(title: "계획 삭제", message: "정말 지우시겠어요?", preferredStyle: .actionSheet)
    //
    //        let DeleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: handleDeleteTable)
    //        let CancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelDeleteTable)
    //
    //        alert.addAction(DeleteAction)
    //        alert.addAction(CancelAction)
    //
    //        alert.popoverPresentationController?.sourceView = self.view
    //        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y : self.view.bounds.size.height / 2.0, width : 1.0,height : 1.0)
    //
    //        self.present(alert, animated: true, completion: nil)
    //    }
    //
    //
    //
    //    func handleDeleteTable(alertAction: UIAlertAction!) -> Void {
    //        if let indexPath =  deleteTableIndexPath
    //        {
    //            tableView.beginUpdates()
    //            tableView.beginUpdates()
    //            todoList.delete(index: indexPath.row)
    //            let indexPaths = NSIndexPath(row: indexPath.row, section: indexPath.section)
    //
    //            tableView.deleteRows(at: [indexPaths as IndexPath], with: .automatic)
    //            tableView.endUpdates()
    //        }
    //    }
    //    func cancelDeleteTable(alertAction: UIAlertAction!) {
    //        deleteTableIndexPath = nil
    //    }
    
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            
//            var sortedStuff = realm?.objects(ToDo.self).filter("planTitle")
//            sortedStuff?.sorted(byKeyPath: "planTitle", ascending: true)
            // A-Z
            //            var sortedStuff = todoList.items!.sorted(todoList.items, { (left: Int, right: Int) -> Bool in left < right })
            //            self.todoList = self.todoList.items!.sorted(by: { (left: ToDo, right: ToDo) -> Bool in
            //                return left.planTitle ?? "" < right.planTitle ?? ""
            //            })
            
            //         self.todoList = self.todoList.items!.sorted(byProperty: "planTitle", ascending: true)
            //            sorted(byProperty: "planTitle")
            //        }
            //        else{
            ////            // date
            ////           self.todoList = self.todoList.items!.sorted(byProperty: "createdAt", ascending:false)
            //        }
            //        self.tableView.reloadData()
            //    }
            
            
        }}
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            todoList.delete(index: indexPath.row)
            
            let indexPaths = NSIndexPath(row: indexPath.row, section: indexPath.section)
            
            tableView.deleteRows(at: [indexPaths as IndexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    @IBAction func returnToDoList(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
