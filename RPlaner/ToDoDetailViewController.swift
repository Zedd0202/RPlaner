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
        editButton.target = self
        editButton.action = #selector(ToDoDetailViewController.onClickEditButton(sender:))
        // Do any additional setup after loading the view.
        detailDays.text = todo?.deadLineNumber
        detailToDoCompletionOption.text = todo?.TimeOfCompletion
        detailToDoTitle.text = todo?.planTitle
        detailMemo.text = todo?.memo
        detailMemo.layer.borderWidth = 1.0
        detailMemo.layer.borderColor = UIColor.black.cgColor
        self.title = todo?.planTitle
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    func onClickEditButton(sender: UIBarButtonItem) {
        //self.todo = nil
        self.performSegue(withIdentifier: "toNewToDoViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toNewToDoViewController") {
            let newToDoVC = segue.destination as! NewToDoCreateViewController
            newToDoVC.todo = self.todo
        }
    }
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
