//
//  UserDefaultsColorExtension.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 09.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            do {
                color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            } catch {
                print(error)
            }
        }
        return color
    }
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData
            } catch {
                print(error)
            }
        }
        set(colorData, forKey: key)
    }
    
}
