//
//  Task.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 27.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation

class Task: Codable {
    var id : Int?
    var name : String
    var description : String
    var dueDate : String
    var listId : Int?
    
    init(name: String, description: String, dueDate: String) {
        self.name = name
        self.description = description
        self.dueDate = dueDate
    }
    
    /*
    init(name: String, date: String) {
        self.name = name
        self.date = date
    }
    
    init(id: Int, name: String, date: Date) {
        self.name = name
        self.date = date.description
        self.id = id
    }
 */
}
