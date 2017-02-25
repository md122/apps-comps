//
//  Level.swift
//  AppsComps
//
//  Created by WANCHEN YAO on 2/25/17.
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
    
    //CHECKS IF LEVEL BUTTON IS ACCESSIBLE
    func checkAccess(curLev: Int)->Bool{
        //IF LEVEL IS LESS THAN OR EQUAL TO STUDENT'S CURRENT LEVEL, UPDATES THE BUTTON TITLE TO LEVEL VALUE AND TURNS TO BLUE
        if (level <= curLev){
            locked = false
            self.backgroundColor = UIColor(red:0.26, green:0.53, blue:0.96, alpha:1.0)
            self.setTitleColor(UIColor(red:0.69, green:0.80, blue:0.90, alpha:1.0), for: .normal)
            self.isUserInteractionEnabled = true
            self.setTitle("Level \(level)", for: .normal)
        }
        //IF LEVEL IS GREATER THAN STUDENT'S CURRENT LEVEL, LOCKS THE BUTTON AND TURNS TO GREY
        else {
            locked = true
            self.setTitleColor(UIColor(red:0.69, green:0.69, blue:0.76, alpha:1.0), for: .normal)
            self.backgroundColor = UIColor(red:0.42, green:0.41, blue:0.48, alpha:1.0)
            self.isUserInteractionEnabled = false
            self.setTitle("Locked", for: .normal)
        }
        return locked
    }

}
