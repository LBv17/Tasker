//
//  Root.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 02.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation

struct Root: Codable {
    let status : Int
    let statusMessage : String
    let data : [TaskList]
    // let userId : String
}
