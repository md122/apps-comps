//
//  Level.swift
//  AppsComps
//
//  Created by appscomps on 1/11/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class LevelButton: UIButton {
    var level: Int
    var tapped: Bool
    var locked: Bool
    
    required init?(coder aDecoder: NSCoder) {
        // set myValue before super.init is called
        self.level = 0
        self.tapped = false
        self.locked = true
        
        super.init(coder: aDecoder)
        
        
        setBGColor();
        self.addTarget(self, action:#selector(self.onTap), for: .touchUpInside)
        
    }

    func setBGColor(){
        if (locked){
            self.backgroundColor = UIColor.gray
        } else{
            self.backgroundColor = UIColor.green
        }
    }
    

    
    func onTap(){
        if (locked){
            self.isUserInteractionEnabled = false
        }
        else{
            self.backgroundColor = UIColor.darkGray
        }
    }
    
    func setLevel(lev: Int){
        self.level = lev
    }
    
    func getLevel() -> Int {
        return level
    }
    
    func checkAccess(curLev: Int){
        if (level >= curLev){
            locked = false
        } else {
            locked = true
        }
    }

}
