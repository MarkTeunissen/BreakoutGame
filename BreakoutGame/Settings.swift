//
//  Settings.swift
//  BreakoutGame
//
//  Created by Mark on 24-05-16.
//  Copyright © 2016 MarkTeunissen. All rights reserved.
//

import Foundation

class Settings {
    
    private struct Const {
        static let Balls = "Settings.Balls"
        static let Bricks = "Settings.Bricks"
        static let SpecialBricks = "Settings.SpecialBricks"
        static let Speed = "Settings.Speed"
        static let Childmode = "Settings.Childmode"
        static let defaultBalls = 1
        static let defaultBricks = 5
        static let defaultSpecialBricks = 5
        static let defaultSpeed = 0.50
        static let defaultChildmode = false
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    
    var Balls: Int? {
        get { return defaults.objectForKey(Const.Balls) as? Int}
        set { defaults.setObject(newValue, forKey: Const.Balls) }
    }
    
    var Bricks: Int? {
        get { return defaults.objectForKey(Const.Bricks) as? Int}
        set { defaults.setObject(newValue, forKey: Const.Bricks) }
    }
    
    var SpecialBricks: Int? {
        get { return defaults.objectForKey(Const.SpecialBricks) as? Int}
        set { defaults.setObject(newValue, forKey: Const.SpecialBricks) }
    }

    var Speed: Double? {
        get { return defaults.objectForKey(Const.Speed) as? Double}
        set { defaults.setObject(newValue, forKey: Const.Speed) }
    }

    var Childmode: Bool? {
        get { return defaults.objectForKey(Const.Childmode) as? Bool}
        set { defaults.setObject(newValue, forKey: Const.Childmode) }
    }
    
    func setSettingsOnStartUp() {
        if Balls == nil {
            Balls = 1
            Bricks = 5
            SpecialBricks = 5
            Speed = 0.50
            Childmode = false
        }
    }
}