//
//  TaskList.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 27.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation

class TaskList: Codable {
    var id : Int?
    var title : String
    var tasks : [Task]?
    
    
    init(title: String) {
        self.title = title
    }
    /*
    init(id: Int, title: String, tasks: [Task]) {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
 */
}
