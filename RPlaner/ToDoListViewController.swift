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
    
    let searchController = UISearchController(searchResultsController: nil)
    let realm = try? Realm()
    var todoList = ToDoList()
    var todo: ToDo?
    var filteredCandies = ToDoList()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //realm 변수를 선언.
        let realm = try? Realm()
        self.todoList.items = realm?.objects(ToDo.self)
        self.title = "RPlaner"
        self.navigationItem.backBarButtonItem?.tintColor = .white

    }
    //추가 버튼을 눌렀을 때 수행되는 함수. 세그를 이용하여 toNewToDoViewController로 가게된다.
    @IBAction func addButtonTapped(_ sender: Any) {
        self.todo = nil
        self.performSegue(withIdentifier: "toNewToDoViewController", sender: self)
    }
   
    
    @IBOutlet weak var addButton: UIBarButtonItem?
   
    
    // MARK: - Table view data source
    //테이블 뷰에 카운트를 줘야하므로 현재 todolist에 있는 아이템 갯수들을 리턴해주게 된다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoList.items?.count ?? 0
    }
    
    //테이블뷰 셀을 리턴해주는 함수.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoListViewCell
        cell?.todo = (todoList.items?[indexPath.row])
        return cell!
        
        
    }
    //셀의 높이를 지정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
  
    //셀을 클릭했을 시 수행되는 함수. 해당 셀을 클릭하면 세그를 통해 디테일 뷰로 넘어가게 된다.
    override func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ToDoListViewCell
        self.todo = cell.todo
        self.performSegue(withIdentifier: "toDetailToDoViewController", sender: self)
    }
    //뷰가 사라질 때 수행되는 함수.
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //performSegue가 수행될 때 자동으로 수행되는 함수.
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
    
    
    //스와이프를 edit, delete버튼이 나옴.
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            print("a")
            //현재 데이터를 가지고 toNewToDoViewController로 갈 수 있도록 한다.
            if let cell: ToDoListViewCell = tableView.cellForRow(at: editActionsForRowAt) as? ToDoListViewCell {
            self.performSegue(withIdentifier: "toNewToDoViewController", sender: cell.todo)
            }

        }
        
        //삭제. row를 삭제할 뿐만아니라 todoList에서도 삭제해야한다.
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
    
    //정렬.
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
            tableView.beginUpdates()
            //ㄱ~ㅎ 순으로 정렬.
            let sortedStuff = realm?.objects(ToDo.self).sorted(byKeyPath: "planTitle", ascending: true)
            
            self.todoList.items = sortedStuff
            
            tableView.reloadData()
            tableView.endUpdates()
            
      } else if sender.selectedSegmentIndex == 0 {
            
            // 최근 생성일 순으로 정렬
            let sortedStuffs = realm?.objects(ToDo.self).sorted(byKeyPath: "createdAt", ascending: false)
            //self.todoList.items = a?.elements
            self.todoList.items = sortedStuffs
            self.tableView.reloadData()
        }
    }
    @IBAction func returnToDoList(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
}
