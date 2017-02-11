//
//  PickToDoViewController.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit
import GameplayKit

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
                
                if count == todoList.items?.count                 {
                    displayTodoLabel.text = "모든 계획이 완료"
                    break;
                }
                self.randomIndex = Int(arc4random_uniform(UInt32((todoList.items?.count)!)))
                if(todoList.items?[randomIndex].isComplete == false)
                {
                    displayTodoLabel.isHidden = false
                    displayTodoLabel.text = todoList.items?[randomIndex].planTitle
                    pickRandomToDoButton.isHidden = true
                    completionButton.isHidden = false
                    
                    break
                }
                else{
                    
                    
                    //            let randomIndex = Int(arc4random_uniform(UInt32(plans.count)))
                    //            displayPlanLabel.isHidden = false
                    //            displayPlanLabel.text = plans[randomIndex].planTitle
                    //            pickRandomButton.isHidden = true
                    //            completionButton.isHidden = false
                    
                }
            }
            
        }
        else
        {
            displayTodoLabel.isHidden = false
            displayTodoLabel.text = "계획을 먼저 생성해 주세요ㅠㅠ"
        }

        
        
    }
    @IBAction func tapToDoCompleteButton(_ sender: Any) {
        completionButton.isHidden = true
        pickRandomToDoButton.isHidden = false
        
       todoList.items?[randomIndex].isComplete = true
        count = count + 1

        
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
