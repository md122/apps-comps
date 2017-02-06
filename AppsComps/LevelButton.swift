//
//  Level.swift
//  AppsComps
//
//  Created by appscomps on 1/11/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class LevelButton: UIButton {
    var level: Int = 0
    var tapped: Bool = false
    var locked: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        
    }

    
    func setLevel(lev: Int){
        self.level = lev
    }
    
    func getLevel() -> Int {
        return level
    }
    
    func checkAccess(curLev: Int)->Bool{
        if (level <= curLev){
            locked = false
            self.backgroundColor = UIColor(red:0.71, green:0.47, blue:0.47, alpha:1.0)
        } else {
            locked = true
            self.backgroundColor = UIColor(red:0.42, green:0.41, blue:0.48, alpha:1.0)
            self.isUserInteractionEnabled = false
        }
        return locked
    }

}
