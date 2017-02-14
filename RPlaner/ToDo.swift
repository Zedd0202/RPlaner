//
//  ToDo.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import Foundation
import RealmSwift

class ToDo: Object {
    
     dynamic var planTitle: String? = ""
     dynamic var deadLineNumber: String? = ""
     dynamic var TimeOfCompletion : String?
     dynamic var memo: String?
     dynamic var isComplete = false
     dynamic var isDoing = false
}

