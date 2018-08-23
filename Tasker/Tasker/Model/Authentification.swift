//
//  Authentification.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 02.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation

struct Authentification : Codable {
    let status : Int
    let statusMessage : String
    let data : [String:String]
}

// TODO: CHANGE TO USER AND RETURN ID FROM API
