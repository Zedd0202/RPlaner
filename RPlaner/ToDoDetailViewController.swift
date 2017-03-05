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
    
    //디테일 뷰가 처음 로드되었을 때 수행되는 함수.
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
    
    //edit버튼을 눌렀을 때 수행되는 함수 performSegue를 통해 toNewToDoViewController로 가지만 현재 데이터를 가지고 이동한다 -> prepare때문.
    func onClickEditButton(sender: UIBarButtonItem) {
        //self.todo = nil
        self.performSegue(withIdentifier: "toNewToDoViewController", sender: self)
    }
    //performSegue가 수행되고 prepare함수로 오게된다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //만약 세그가 toNewToDoViewController이면, 현재 데이터를 가지고 간다. 때문에 toNewToDoViewController로 가도 새로운 계획을 생성하는 것이 아닌, 현재 계획을 수정할 수 있게 된다.
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
