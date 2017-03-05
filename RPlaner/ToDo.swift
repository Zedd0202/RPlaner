//
//  ToDo.swift
//  RPlaner
//
//  Created by Zedd on 2017. 2. 10..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import Foundation
import RealmSwift

//계획 객체들.
class ToDo: Object {
    
     dynamic var planTitle: String?//계획 제목
     dynamic var deadLineNumber: String? // 기한
     dynamic var TimeOfCompletion : String?// 이내 or 동안
     dynamic var memo: String? // 메모
     dynamic var isComplete = false //완료되었는지
     dynamic var isDoing = false //현재 수행중인지.
     dynamic var createdAt = Date() //계획이 만들어진 시간.
}

