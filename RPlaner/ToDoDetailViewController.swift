//
//  ToDoDetailViewController.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 13..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController {
    
    var todoList = ToDoList()
    var todo: ToDo?
    
    @IBOutlet weak var detailMemo: UITextView!
    @IBOutlet weak var detailToDoCompletionOption: UILabel!
    @IBOutlet weak var detailDays: UILabel!
    @IBOutlet weak var detailToDoTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarControlle
        editButton.target = self
        editButton.action = #selector(ToDoDetailViewController.onClickEditButton(sender:))
        // Do any additional setup after loading the view.
        detailDays.text = todo?.deadLineNumber
        detailToDoCompletionOption.text = todo?.TimeOfCompletion
        detailToDoTitle.text = todo?.planTitle
        detailMemo.text = todo?.memo
        self.detailMemo.layer.cornerRadius = 10
        self.detailMemo.layer.masksToBounds = true
        self.title = todo?.planTitle
        self.navigationController?.navigationBar.tintColor = UIColor.black
      
        self.navigationController?.navigationBar.topItem?.title = ""
        self.detailToDoTitle.layer.cornerRadius = 10
        self.detailToDoTitle.layer.masksToBounds = true

        
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    func onClickEditButton(sender: UIBarButtonItem) {
        //self.todo = nil
        self.performSegue(withIdentifier: "toNewToDoViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewToDoViewController") {
            if let navi = segue.destination as? UINavigationController, let newToDoVC = navi.viewControllers.first as? NewToDoCreateViewController {
                newToDoVC.todo = self.todo
                newToDoVC.title = self.todo?.planTitle
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = true
    }
   
    
}
