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
    
    var items: Results<ToDo>? {
        let realm = try! Realm()
        return realm.objects(ToDo.self)
    }
    
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
    
    func create(name: String, deadline: String, completionOption : String, memoText: String) {
        let toDo = ToDo()
        
        toDo.planTitle = name
        toDo.deadLineNumber = deadline
        toDo.TimeOfCompletion = completionOption
        toDo.memo = memoText
        toDo.isComplete = false
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(toDo)
            }
        } catch {
            print("realm add error")
        }
    }
    
    func update(todo: ToDo?,name: String, deadline: String, completionOption : String, memoText: String) {
        do {
            let realm = try Realm()
            try realm.write {
                todo?.planTitle = name
                todo?.deadLineNumber = deadline
                todo?.TimeOfCompletion = completionOption
                todo?.memo = memoText            }
        } catch {
            print("update error")
        }
    }
}

