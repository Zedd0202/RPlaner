//
//  PickToDoViewController.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit
import GameplayKit
//랜덤인덱스를 구하기 위해 import
import RealmSwift
//Realm을 사용하기 위해 import
import UserNotifications

private let stopTimeKey = "stopTimeKey"

class PickToDoViewController: UIViewController {
    
    
    var currentTime = NSDate()
    var todoList = ToDoList()
    var todo: ToDo?
    var startClickTime : Int = 0
    var endTime : Int = 0
    var randomIndex:Int?
    var currentCount =  0.0
    var maxCount =  0.0
    var timers : Timer?
    private var stopTime: Date?
    private var timer: Timer?

    let userDefaults = UserDefaults.standard
    let realm = try? Realm()
    
  
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
       func handle()
    {
        if maxCount <= currentCount {
            print("tttttttttt")
            circularProgressView.animate(toAngle: 0.0, duration: 1, completion: nil)
            timers?.invalidate()
            timers = nil
            completionButton.isHidden = true
            pickRandomToDoButton.isHidden = false
            displayTodoLabel.text = "다음 계획을 생성하려면 클릭버튼을 눌러주세요"
            return
            
        }
        else{
            let newAngleValue = newAngle()
            circularProgressView.animate(toAngle:Double(newAngleValue), duration: 1, completion: nil)
        }
    }
    
//    @IBAction func tapAnywhereAction(_ sender: Any) {
//        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first{
//          self.performSegue(withIdentifier: "showDetailView", sender: self)
//        }
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "showDetailView") {
//            let newToDoVC = segue.destination as! ToDoDetailViewController
//            newToDoVC.todo = self.todo
//        }
//    }
   


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        

       // self.todoTitleTextField?.layer.cornerRadius = 10
       // self.todoTitleTextField?.layer.masksToBounds = true

        pickRandomToDoButton.layer.cornerRadius = 0.5 * pickRandomToDoButton.bounds.size.width
       pickRandomToDoButton.layer.masksToBounds = false
        //timeLabel.attributedText = UIFont(name: "BMHANNA_11yrs_ttf", size: 35)
        
      // pickRandomToDoButton.layer.shadowColor = UIColor.green.cgColor
      //  pickRandomToDoButton.layer.shadowOpacity = 0.8;
       // pickRandomToDoButton.layer.shadowRadius = 12;
        //pickRandomToDoButton.layer.shadowOffset = CGSize(x :12.0, y :12.0);
        
        
        completionButton.layer.masksToBounds = false
         completionButton.layer.cornerRadius = 0.5 * completionButton.bounds.size.width
        completionButton.isHidden = true
        self.todoList.items = realm?.objects(ToDo.self)
        userDefaults.set(displayTodoLabel.text, forKey: "displayTodoLabel")
        
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first{
            displayTodoLabel.text = doingTodo.planTitle
            completionButton.isHidden = false
            pickRandomToDoButton.isHidden = true
            timeLabel.isHidden = false
            
            
            registerForLocalNotifications()
            stopTime = UserDefaults.standard.object(forKey: stopTimeKey) as? Date
            if let time = stopTime {
                if time > Date() {
                    startTimer(time, includeNotification: false)
                }
                else {
                    notifyTimerCompleted()
                }
            }
        }
            
        else{
            timers?.invalidate()
            timers = nil
            userDefaults.set(displayTodoLabel.text, forKey: "displayTodoLabel")
            displayTodoLabel.text = displayTodoLabel.text
        }
        
    }
    
    
    private func registerForLocalNotifications() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                guard granted && error == nil else {
                    // display error
                    print("\(error)")
                    return
                }
            }
        }
        else {
            let types: UIUserNotificationType = [.badge, .sound, .alert]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    @IBOutlet weak var displayTodoLabel: UILabel!
    @IBOutlet weak var pickRandomToDoButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    
    
    @IBAction func tapPickRandomToDoButton(_ sender: Any) {
        timeLabel.isHidden = false
        if (todoList.items?.count)! >  0
        {
            
            currentCount = 0.0
            while  true{
                let ccount = realm?.objects(ToDo.self).filter("isComplete == true")
                if ccount?.count == todoList.items?.count{
                    timeLabel.isHidden = true
                    
                    displayTodoLabel.text = "모든 계획이 완료"
                    userDefaults.set(displayTodoLabel.text, forKey: "모든 계획이 완료")
                    userDefaults.synchronize()
                    break;
                }
                self.randomIndex = Int(arc4random_uniform(UInt32((todoList.items?.count)!)))
                if((todoList.items?[randomIndex!].isComplete)! == false){
                    timeLabel.isHidden = false
                    displayTodoLabel.isHidden = false
                    displayTodoLabel.text = todoList.items?[randomIndex!].planTitle
                    pickRandomToDoButton.isHidden = true
                    completionButton.isHidden = false
                    
                    var deadLine = Double((todoList.items?[randomIndex!].deadLineNumber)!)
                    print(deadLine)
                    
                    
                    
                    let time = getCurrentDate() + (deadLine!*86400)
//                    UserDefaults.standard.set(currentTime, forKey: "currentTime")
//                    self.currentTime = currentTime
                    
                    //maxCount = deadLine!*86400
                    maxCount = 30.0
                    userDefaults.set(maxCount, forKey: "maxCount")
                    userDefaults.synchronize()
                    
                    if currentCount <= maxCount {
                        //currentCount += 1
                        
                        userDefaults.synchronize()
                        let newAngleValue = newAngle()
                        
                        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handle(_:)), userInfo: nil, repeats: true)
                        timers = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true, block: { (timers) in
                            self.handle()
                            print("A")
                        })
                    }
                    else{
                        timers?.invalidate()
                        timers = nil
                    }
                    
                    
                    
                    
                    //let time = getCurrentDate() + 5.0
                    
                    print(time)
                    if time > Date() {
                        startTimer(time)
                    } else {
                        timeLabel.text = "timer date must be in future"
                    }
                    
                    
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
            displayTodoLabel.text = "생성된 계획이 없습니다."
            timeLabel.isHidden = true
        }
    }
    
    func newAngle() -> Int {
        if currentCount >=  maxCount{
            timers?.invalidate()
            timers = nil
            currentCount = 0
            circularProgressView.animate(toAngle: 0, duration: 1, completion: nil)
            circularProgressView.animate(fromAngle:circularProgressView.angle, toAngle: 0, duration: 0.5, completion: nil)
        }
        
        currentCount += 1
        userDefaults.set(currentCount, forKey: "currentCount")
        userDefaults.synchronize()
        
        return Int(360 * (currentCount / maxCount))
        //return Int(currentCount / maxCount)

    }
    
    func getCurrentDate() -> Date {
        
        var now:Date = Date()
        var calendar = Calendar.current
        let timezone = NSTimeZone.system
        calendar.timeZone = timezone
        //timezone을 사용해서 date의 components를 지정해서 가져옴.
        let anchorComponets = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: now)
        
        let getDateFromDateComponents = calendar.date(from: anchorComponets)
        if let getCurrentDate = getDateFromDateComponents {
            now = getCurrentDate
        }
        return now
    }
    
    @IBAction func tapToDoCompleteButton(_ sender: Any) {
        
//        currentCount = 0
//        circularProgressView.animate( toAngle: 0, duration: 1, completion: nil)
//        timers?.invalidate()
//        timers = nil
//        timeLabel.isHidden = true
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first{
            
            let alertController = UIAlertController(
                title: "\(doingTodo.planTitle!)을(를) 정말로 다 끝내셨나요?",
                message: "끝내셨다면 완료버튼을 눌러주세요.",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let cancelAction = UIAlertAction(
                title: "취소",
                style: UIAlertActionStyle.destructive) { (action) in
                    
            }
            
            let confirmAction = UIAlertAction(
            title: "완료", style: UIAlertActionStyle.default) { (action) in
                //self.currentCount = 0
                self.circularProgressView.animate( toAngle: 0, duration: 1, completion: nil)
                self.timers?.invalidate()
                self.timers = nil
                self.timeLabel.isHidden = true
                
                self.completionButton.isHidden = true
                self.pickRandomToDoButton.isHidden = false
                self.timeLabel.isHidden = true
                self.displayTodoLabel.text = "다음 계획을 생성하려면 클릭버튼을 눌러주세요"
                self.timeLabel.isHidden = true
                self.userDefaults.set(self.displayTodoLabel.text, forKey: "다음 계획을 생성하려면 클릭버튼을 눌러주세요")
                self.userDefaults.synchronize()
                let realm = try! Realm()
                realm.beginWrite()
                
                //todoList.complete()
                doingTodo.isComplete = true
                
                
                doingTodo.isDoing = false
                try? realm.commitWrite()

            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
            
//            completionButton.isHidden = true
//            pickRandomToDoButton.isHidden = false
//            timeLabel.isHidden = true
//            displayTodoLabel.text = "다음 계획을 생성하려면 클릭버튼을 눌러주세요"
//            timeLabel.isHidden = true
//            userDefaults.set(displayTodoLabel.text, forKey: "다음 계획을 생성하려면 클릭버튼을 눌러주세요")
//            userDefaults.synchronize()
            
           // currentCount = 0
           // circularProgressView.animate( toAngle: 0, duration: 1, completion: nil)
            
            
            
//            let realm = try! Realm()
//            realm.beginWrite()
//            
//            //todoList.complete()
//            doingTodo.isComplete = true
//            
//            
//            doingTodo.isDoing = false
//            try? realm.commitWrite()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeLabel.isHidden = true
        self.tabBarController?.tabBar.isHidden = false

        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first {
            
            
            if doingTodo.isComplete == false{
                self.displayTodoLabel.text = doingTodo.planTitle
                pickRandomToDoButton.isHidden = true
                completionButton.isHidden = false
                timeLabel.isHidden = false
                currentCount = userDefaults.double(forKey: "currentCount")
                userDefaults.synchronize()
                maxCount = userDefaults.double(forKey: "maxCount")
                userDefaults.synchronize()
                
               
                if currentCount >=  maxCount{
                    timers?.invalidate()
                    timers = nil
                    currentCount = 0
                    circularProgressView.animate(toAngle: 0, duration: 1, completion: nil)
                }
                else{
                    timers = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timers) in
                        self.handle()
                    })
                }
                
                
                
            }
            
            
        }
        else{
            
            self.displayTodoLabel.text = "다음 계획을 생성하려면 클릭버튼을 눌러주세요"
            pickRandomToDoButton.isHidden = false
            completionButton.isHidden = true
            timers?.invalidate()
            timers = nil
            currentCount = 0
            circularProgressView.animate(toAngle: 0, duration: 1, completion: nil)
            
            
        }
        
    }
    
    
    
    
    private func startTimer(_ stopTime: Date, includeNotification: Bool = true) {
        // save `stopTime` in case app is terminated
        
        UserDefaults.standard.set(stopTime, forKey: stopTimeKey)
        self.stopTime = stopTime
        
        // start Timer
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
        
        guard includeNotification else { return }
        
        // start local notification (so we're notified if timer expires while app is not running)
        
        if #available(iOS 10, *) {
            let content = UNMutableNotificationContent()
            content.title = "계획기한이 만료되었어요."
            content.body = "다음 계획을 진행해보세요!"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: stopTime.timeIntervalSinceNow, repeats: false)
            let notification = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(notification)
        } else {
            let notification = UILocalNotification()
            notification.fireDate = stopTime
            notification.alertBody = "Timer finished!"
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private let dateComponentsFormatter: DateComponentsFormatter = {
        let _formatter = DateComponentsFormatter()
        _formatter.allowedUnits = [.day, .hour, .minute, .second]
        _formatter.unitsStyle = .abbreviated
        _formatter.zeroFormattingBehavior = .pad
        return _formatter
    }()
    
    
    
    func handleTimer(_ timer: Timer) {
        let now = Date()
        
        if stopTime! > now {
            timeLabel.text = dateComponentsFormatter.string(from: now, to: stopTime!)
        } else {
            stopTimer()
            notifyTimerCompleted()
        }
    }
    
    private func notifyTimerCompleted() {
        timeLabel.text = "기한이 만료되었습니다."
    }
    
}
