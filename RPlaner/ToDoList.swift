//
//  ToDoList.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoList {
    
  // var count : Int = 0
    var items: Results<ToDo>?
//    {
//        let realm = try? Realm()
//        return realm?.objects(ToDo.self)
//    }
//    var counts : Results<ToDo>? {
//        let countRealm = try? Realm()
//        return countRealm?.objects(ToDo.self)
//    }
    
//    init() {
//        super.init()
//        
//                let realm = try? Realm()
//                return realm?.objects(ToDo.self)
//        self.items =
//    }
    //MARK: Delete ToDo
    func delete(index: Int) {
        do {
            let realm = try Realm()
           
            
            try realm.write {
                realm.delete((items?[index])!)
              
            }
        } catch {
            print("realm delete error")
        }
    }
    
    //MARK: Create newToDo
    func create(name: String, deadline: String, completionOption : String, memoText: String,createdAt : Date) {
        let toDo = ToDo()
        
        toDo.planTitle = name
        toDo.deadLineNumber = deadline
        toDo.TimeOfCompletion = completionOption
        toDo.memo = memoText
        toDo.isComplete = false
        toDo.createdAt = Date()
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(toDo)
            }
        } catch {
            print("realm add error")
        }
    }
    //MARK: Update ToDo
    func update(todo: ToDo?,name: String, deadline: String, completionOption : String, memoText: String) {
        do {
            let realm = try Realm()
            try realm.write {
                todo?.planTitle = name
                todo?.deadLineNumber = deadline
                todo?.TimeOfCompletion = completionOption
                todo?.memo = memoText
               
            }
        } catch {
            print("update error")
        }
    }
    
    

}

