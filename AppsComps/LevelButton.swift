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
            self.backgroundColor = UIColor(red:0.26, green:0.53, blue:0.96, alpha:1.0)
            self.setTitleColor(UIColor(red:0.69, green:0.80, blue:0.90, alpha:1.0), for: .normal)
            self.isUserInteractionEnabled = true
        } else {
            locked = true
            self.setTitleColor(UIColor(red:0.69, green:0.69, blue:0.76, alpha:1.0), for: .normal)
            self.backgroundColor = UIColor(red:0.42, green:0.41, blue:0.48, alpha:1.0)
            self.isUserInteractionEnabled = false
            self.setTitle("Locked", for: .normal)
        }
        return locked
    }

}
