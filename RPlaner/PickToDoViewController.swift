//
//  PickToDoViewController.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit
//import GameplayKit
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
    //@IBOutlet weak var circularProgressView: KDCircularProgress!
    
    func handle()
    {
        if maxCount <= currentCount {
            //circularProgressView.animate(toAngle: 0.0, duration: 1, completion: nil)
            timers?.invalidate()
            timers = nil
            completionButton.isHidden = true
            pickRandomToDoButton.isHidden = false
            displayTodoLabel.text = "다음 계획을 생성하려면 클릭버튼을 눌러주세요"
            return
            
        }
        else{
            let newAngleValue = newAngle()
            //circularProgressView.animate(toAngle:Double(newAngleValue), duration: 1, completion: nil)
        }
    }
    
    
    
    
    
    //뷰가 처음 로드 되었을 때 수행되는 함수.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        //notification을 등록해준다.
        registerForLocalNotifications()
        
        
        //클릭버튼과 완료버튼을 둥글게 하기 위한 코드
        pickRandomToDoButton.layer.cornerRadius = 0.5 * pickRandomToDoButton.bounds.size.width
        pickRandomToDoButton.layer.masksToBounds = false
        
        completionButton.layer.masksToBounds = false
        completionButton.layer.cornerRadius = 0.5 * completionButton.bounds.size.width
        completionButton.isHidden = true
        
        
        self.todoList.items = realm?.objects(ToDo.self)
        userDefaults.set(displayTodoLabel.text, forKey: "displayTodoLabel")
        
        
        //만약 뷰가 로드되었을 때, 수행중인 계획이 있다면 표시해준다.
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first{
            displayTodoLabel.text = doingTodo.planTitle
            completionButton.isHidden = false
            pickRandomToDoButton.isHidden = true
            timeLabel.isHidden = false
            
            
            // registerForLocalNotifications()
            stopTime = UserDefaults.standard.object(forKey: stopTimeKey) as? Date
            //현재 시간이 완료시간보다 작으면 타이머를 다시 실행하고 아니면 카운트 다운이 끝났다는 알림을 보낸다.
            if let time = stopTime {
                if time > Date() {
                    startTimer(time, includeNotification: false)
                }
                else {
                    notifyTimerCompleted()
                }
            }
        }
        //만약 현재 수행중인 계획이 없다면 카운트를 멈춘다.
        else{
            timers?.invalidate()
            timers = nil
            userDefaults.set(displayTodoLabel.text, forKey: "displayTodoLabel")
            displayTodoLabel.text = displayTodoLabel.text
        }
    }
    //MARK: Register Notification.
    
    private func registerForLocalNotifications() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                guard granted && error == nil else {
                    // display error

                    return
                }
            }
        }
            //노티피케이션의 형태를 지정해준다.
        else {
            let types: UIUserNotificationType = [.badge, .sound, .alert]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    
    
    @IBOutlet weak var displayTodoLabel: UILabel!
    @IBOutlet weak var pickRandomToDoButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    
    //랜덤한 계획을 뽑는 클릭버튼이다. 현재 생성된 계획이 0 이상일 때만 동작한다.
    @IBAction func tapPickRandomToDoButton(_ sender: Any) {
        timeLabel.isHidden = false
        if (todoList.items?.count)! >  0
        {
            
            currentCount = 0.0
            while  true{
                let ccount = realm?.objects(ToDo.self).filter("isComplete == true")
                //만약 현재 생성된 계획과 완료된 계획의 수가 같으면 처리해줄 코드
                if ccount?.count == todoList.items?.count{
                    timeLabel.isHidden = true
                    
                    displayTodoLabel.text = "모든 계획이 완료"
                    userDefaults.set(displayTodoLabel.text, forKey: "모든 계획이 완료")
                    userDefaults.synchronize()
                    break;
                }
                
                //MARK: Create RandomIndex
                self.randomIndex = Int(arc4random_uniform(UInt32((todoList.items?.count)!)))
                
                
                //현재 뽑힌 계획이 완료가 되지 않았을 경우에만 실행.
                if((todoList.items?[randomIndex!].isComplete)! == false){
                    timeLabel.isHidden = false
                    displayTodoLabel.isHidden = false
                    displayTodoLabel.text = todoList.items?[randomIndex!].planTitle
                    pickRandomToDoButton.isHidden = true
                    completionButton.isHidden = false
                    
                    //그 계획의 데드라인을 가져온다.
                    var deadLine = Double((todoList.items?[randomIndex!].deadLineNumber)!)
                    //print(deadLine)
                    
                    //완료시간
                    //let time = getCurrentDate() + 5.0
                     //완료시간을 지정해준다.
                     let time = getCurrentDate() + (deadLine!*86400)
                    
                    
                    //                    UserDefaults.standard.set(currentTime, forKey: "currentTime")
                    //                    self.currentTime = currentTime
                    //let newAngleValue = newAngle()
                    //maxCount = deadLine!*86400
                    maxCount = deadLine!*86400
                   // maxCount = 60
                    userDefaults.set(maxCount, forKey: "maxCount")
                    userDefaults.synchronize()
                    
                    //그래프를 계산. 만약 현재 카운트가 가야할 맥스카운트보다 작으면 수행.
                    if currentCount <= maxCount {
                        //currentCount += 1
                        
                        userDefaults.synchronize()
                        //let newAngleValue = newAngle()
                        
                        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handle(_:)), userInfo: nil, repeats: true)
                        
                        //타이머를 돌려 계속 handle함수가 0.9초마다 수행되게 한다.
                        timers = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timers) in
                            self.handle()
                            //let newAngleValue = self.newAngle()
                        })
                    }
                        //현재 카운트가 맥스 카운트를 넘어가면 타이머를 종료한다.
                    else{
                        timers?.invalidate()
                        timers = nil
                    }
                    
                    
                    
                    
                    //let time = getCurrentDate() + 5.0
                    
                    if time > Date() {
                        startTimer(time)
                    } else {
                        timeLabel.text = "timer date must be in future"
                    }
                    
                    
                    let realm = try! Realm()
                    realm.beginWrite()
                    //현재 뽑혔으면 현재 수행중이라는 bool형 변수를 true로 set해준다.
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
    //그래프를 그려주는 함수. 현재카운트와 맥스카운트를 비교하여 라이브러리에 있는 함수들을 불러와 수행한다.
    func newAngle() -> Int {
        if currentCount >=  maxCount{
            timers?.invalidate()
            timers = nil
            currentCount = 0
            //circularProgressView.animate(toAngle: 0, duration: 1, completion: nil)
            //circularProgressView.animate(fromAngle:circularProgressView.angle, toAngle: 0, duration: 0.5, completion: nil)
        }
        
        currentCount += 1
        userDefaults.set(currentCount, forKey: "currentCount")
        userDefaults.synchronize()
        
        return Int(360 * (currentCount / maxCount))
        //return Int(currentCount / maxCount)
        
    }
    
    //현재 시간을 보기좋은 형태로 가지고 오는 함수.
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
    //완료버튼을 눌렀을 때 수행되는 함수.
    @IBAction func tapToDoCompleteButton(_ sender: Any) {
        
        //        currentCount = 0
        //        circularProgressView.animate( toAngle: 0, duration: 1, completion: nil)
        //        timers?.invalidate()
        //        timers = nil
        //        timeLabel.isHidden = true
        
        //현재 수행중인 계획을 완료하는 것이므로 현재 수행중인 계획이 있는지 체크해야한다.
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first{
            
            //바로 완료하지 않게 하기 위해 alert뷰 추가.
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
                
                //완료 버튼을 눌렀으므로 그래프를 다시 0으로 돌리고, 타이머를 중지시킨다.
                //self.circularProgressView.animate( toAngle: 0, duration: 1, completion: nil)
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
                //현재 계획을 완료했다고 체크
                doingTodo.isComplete = true
                
                //현재 수행중이지 않게 되기때문에 false로 set.
                doingTodo.isDoing = false
                try? realm.commitWrite()
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
    //viewDidLoad다음에 수행되는 함수.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeLabel.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        //현재 수행중인계획이 있다면,
        if let doingTodo = todoList.items?.filter({ $0.isDoing == true }).first {
            
            //게다가 현재 계획이 완료된 상태가 아니라면 수행.
            if doingTodo.isComplete == false{
                self.displayTodoLabel.text = doingTodo.planTitle
                pickRandomToDoButton.isHidden = true
                completionButton.isHidden = false
                timeLabel.isHidden = false
                currentCount = userDefaults.double(forKey: "currentCount")
                userDefaults.synchronize()
                maxCount = userDefaults.double(forKey: "maxCount")
                userDefaults.synchronize()
                
                //위와 마찬가지로 현재 그래프 카운트와 맥스 카운트를 비교하여 수행.
                if currentCount >=  maxCount{
                    timers?.invalidate()
                    timers = nil
                    currentCount = 0
                    //circularProgressView.animate(toAngle: 0, duration: 1, completion: nil)
                }
                else{
                    timers = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timers) in
                        self.handle()
                    })
                }
                
                
                
            }
            
            
        }
        else{
            //현재  수행중인 계획이 없다면 수행.
            self.displayTodoLabel.text = "다음 계획을 생성하려면 클릭버튼을 눌러주세요"
            pickRandomToDoButton.isHidden = false
            completionButton.isHidden = true
            timers?.invalidate()
            timers = nil
            currentCount = 0
            //circularProgressView.animate(toAngle: 0, duration: 1, completion: nil)
            
            
        }
        
    }
    
    
    
    //MARK: Start Timer
    private func startTimer(_ stopTime: Date, includeNotification: Bool = true) {
        
        //유저디폴트를 이용해 현재 시간을 저장한다.
        UserDefaults.standard.set(stopTime, forKey: stopTimeKey)
        self.stopTime = stopTime
        
        //타이머 수행. 0.1초마다 handleTimer를 불러온다.
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: true)
        
        guard includeNotification else { return }
        
        //iOS 10이상인지 아닌지 판별. Notification의 내용을 지정
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
    //카운트다운이 끝났을 때 불리는 함수.
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //카운트다운 표시 형식을 보기좋게 하기 위해 구현. 
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
        timers?.invalidate()
        timers = nil
        //circularProgressView.animate(toAngle: 0, duration: 1, completion: nil)
        
    }
    
}
