//
//  PickToDoViewController.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit
import GameplayKit
import RealmSwift

class PickToDoViewController: UIViewController {
    
    var todoList = ToDoList()
    var todo: ToDo?
    var count : Int = 0
    var randomIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var displayTodoLabel: UILabel!
    @IBOutlet weak var pickRandomToDoButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    @IBAction func tapPickRandomToDoButton(_ sender: Any) {
        if (todoList.items?.count)! >  1
        {
            while  true{
                
                if count == todoList.items?.count{
                    displayTodoLabel.text = "모든 계획이 완료"
                    break;
                }
                self.randomIndex = Int(arc4random_uniform(UInt32((todoList.items?.count)!)))
                if(todoList.items?[randomIndex].isComplete == false){
                    displayTodoLabel.isHidden = false
                    displayTodoLabel.text = todoList.items?[randomIndex].planTitle
                    pickRandomToDoButton.isHidden = true
                    completionButton.isHidden = false
                    
                    
                    let realm = try! Realm()
                    
                    realm.beginWrite()
                    
                    todoList.items?[randomIndex].isDoing = true
                    
                    try? realm.commitWrite()

                    
                    
                    break
                }
                else{
                    
                    continue
                }
            }
            
        }
        else{
            displayTodoLabel.isHidden = false
            displayTodoLabel.text = "계획을 먼저 생성해 주세요ㅠㅠ"
        }
        
        
        
    }
    @IBAction func tapToDoCompleteButton(_ sender: Any) {
        completionButton.isHidden = true
        pickRandomToDoButton.isHidden = false
        
        
        let realm = try! Realm()

        realm.beginWrite()
        
        todoList.items?[randomIndex].isComplete = true
        count = count + 1//유저디폴트
        
        try? realm.commitWrite()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first {
            self.displayTodoLabel.text = doingTodo.planTitle
            print(doingTodo.planTitle)
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
