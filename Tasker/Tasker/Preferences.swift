//
//  Preferences.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 02.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation
import UIKit

struct Preferences {
    
    static let defaults = UserDefaults.standard
    
    // PRIVATE
    //static var userId = 0
    //static var key  = ""
    
    // Settings
    static var backgroundImageName = "None"
    static var theme = "Default"
    static var blur = false
    static var textColor = UIColor.black
    static var cellColor = UIColor.white
    static var taskSeparatorColor = UIColor.black
    
    static func getKey() -> String {
        return Preferences.defaults.string(forKey: "apiKey")!
    }

    static func savePreferences() {
        defaults.set(theme, forKey: "theme")
        defaults.set(blur, forKey: "blur")
        defaults.set(backgroundImageName, forKey: "wallpaperName")
        
        defaults.setColor(color: textColor, forKey: "textColor")
        defaults.setColor(color: cellColor, forKey: "cellColor")
        defaults.setColor(color: taskSeparatorColor, forKey: "taskSeparatorColor")
    }
    
    static func loadPreferences() {
        backgroundImageName = defaults.string(forKey: "wallpaperName")!
        blur = defaults.bool(forKey: "blur")
        theme = defaults.string(forKey: "theme")!
        
        textColor = defaults.colorForKey(key: "textColor")!
        cellColor = defaults.colorForKey(key: "cellColor")!
        taskSeparatorColor = defaults.colorForKey(key: "taskSeparatorColor")!
    }
    
    static func isAppAlreadyLaunchedOnce() -> Bool{
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
}
