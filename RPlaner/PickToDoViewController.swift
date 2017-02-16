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

class PickToDoViewController: UIViewController,CountdownTimerDelegate {
    let realm = try? Realm()
    var currentTime = NSDate()
    var todoList = ToDoList()
    var todo: ToDo?
    //var completeTodo = [ToDo]()
    //var aa = Count()
    //var count : Int = 0
    
    var timer: CountdownTimer!

    var randomIndex:Int?
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
//    func getCurrentDate() -> Date {
//        
//        var now:Date = Date()
//        var calendar = Calendar.current
//        let timezone = NSTimeZone.system
//        calendar.timeZone = timezone
//        //timezone을 사용해서 date의 components를 지정해서 가져옴.
//        let anchorComponets = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: now)
//        
//        let getDateFromDateComponents = calendar.date(from: anchorComponets)
//        if let getCurrentDate = getDateFromDateComponents {
//            now = getCurrentDate
//        }
//        return now
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        completionButton.isHidden = true
        self.todoList.items = realm?.objects(ToDo.self)
        userDefaults.set(displayTodoLabel.text, forKey: "displayTodoLabel")

        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first{
            displayTodoLabel.text = doingTodo.planTitle
            completionButton.isHidden = false
            pickRandomToDoButton.isHidden = true
            timeLabel.isHidden = false
          
            //let currentIndex = doingTodo.index(ofAccessibilityElement: doingTodo)

        }
       
        else{
            userDefaults.set(displayTodoLabel.text, forKey: "displayTodoLabel")
            displayTodoLabel.text = displayTodoLabel.text
            //timeLabel.isHidden = true

        }
          timer = CountdownTimer(timerLabel: timeLabel, startingDay : 2, startingHour :0,startingMin: 0, startingSec: 0)
        timer.delegate = self
    }
    func countdownEnded() -> Void {
        // Handle countdown finishing
    }
    @IBOutlet weak var displayTodoLabel: UILabel!
    @IBOutlet weak var pickRandomToDoButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    @IBAction func tapPickRandomToDoButton(_ sender: Any) {
        timeLabel.isHidden = false
        if (todoList.items?.count)! >  0
        {
            while  true{
                let ccount = realm?.objects(ToDo.self).filter("isComplete == true")
                if ccount?.count == todoList.items?.count{
                    timeLabel.isHidden = true

                    displayTodoLabel.text = "모든 계획이 완료"
                    break;
                }
                self.randomIndex = Int(arc4random_uniform(UInt32((todoList.items?.count)!)))
                if((todoList.items?[randomIndex!].isComplete)! == false){
                    displayTodoLabel.isHidden = false
                    displayTodoLabel.text = todoList.items?[randomIndex!].planTitle
                    pickRandomToDoButton.isHidden = true
                    completionButton.isHidden = false
                   
                    timer.start()
                    
                    let realm = try! Realm()
                    realm.beginWrite()
                    todoList.items?[randomIndex!].isDoing = true
                    try? realm.commitWrite()
                    userDefaults.setValue(randomIndex, forKey: "randomIndex")
                    userDefaults.synchronize()
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
        
        timeLabel.isHidden = true
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first{
        completionButton.isHidden = true
        pickRandomToDoButton.isHidden = false
        timeLabel.isHidden = true
        displayTodoLabel.text = "다음 계획을 생성하려면 클릭버튼을 눌러주세요"
            timeLabel.isHidden = true
        timer.reset()

        
        
        let realm = try! Realm()
        realm.beginWrite()
        
        //todoList.complete()
        doingTodo.isComplete = true


        doingTodo.isDoing = false
//        todoList.items?[randomIndex!].isComplete = true
//        
//        
//        todoList.items?[randomIndex!].isDoing = false


//        count = count + 1//유저디폴트
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(count, forKey: "count")
//        userDefaults.synchronize()
//        print(count)
        try? realm.commitWrite()
        
    }
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first {
            
            if doingTodo.isComplete == false{
                self.displayTodoLabel.text = doingTodo.planTitle
                //print(doingTodo.planTitle)
                pickRandomToDoButton.isHidden = true
                completionButton.isHidden = false
                timeLabel.isHidden = false
                
            }
            
            
        }
        else{
            
            displayTodoLabel.text = userDefaults.string(forKey: "displayTodoLabel")
            
            if displayTodoLabel.text == "다음 계획을 생성하려면 클릭버튼을 눌러주세요"{
               displayTodoLabel.text = userDefaults.string(forKey: "displayTodoLabel")
                print("aa")
                userDefaults.synchronize()
                return
            }
            if displayTodoLabel.text == "모든 계획이 완료"{
                //self.displayTodoLabel.text = "모든 계획이 완료"
                displayTodoLabel.text = userDefaults.string(forKey: "displayTodoLabel")
                userDefaults.synchronize()
                return
            }
            else{
            self.displayTodoLabel.text = "삭제된 계획입니다"
            pickRandomToDoButton.isHidden = false
            completionButton.isHidden = true
            
            }
            
        }
        // let memes = realm.objects()
//                userDefaults.setValue(displayTodoLabel.text, forKey: "displayTodoLabel")
//                userDefaults.synchronize()
        
        
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
