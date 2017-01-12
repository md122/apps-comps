//
//  ProblemSelectorViewController.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/9/16.
//  Copyright © 2016 appscomps. All rights reserved.
//


/* PLANS FOR NEXT TERM
 -user should retrieve information from Teacher or Student class, not Account class.
 //Actually it might need to be global
 -create a UIButton class which takes in the level and accordingly becomes enable/disabled (green or grey). 
 -level should also be taken from teacher/student class, or the global class
*/
import UIKit

class ProblemSelectorViewController: UIViewController {
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var levelText: UILabel!
    //TODO: user should retrieve information from Teacher or Student class

    //TODO: user should retrieve information from Teacher or Student class, not Account class.
    //Actually it might need to be global
    //let user = Account(idToken: "123", name: "Jan")

    //TODO: level should also be taken from teacher/student class, or the global class
    let level = 4
    
    @IBOutlet weak var level1: LevelButton!
    @IBOutlet weak var level2: LevelButton!
    @IBOutlet weak var level3: LevelButton!
    @IBOutlet weak var level4: LevelButton!
    @IBOutlet weak var level5: LevelButton!
    @IBOutlet weak var level6: LevelButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        greetingText.text = "Hello " + Account.sharedInstance.name!
        levelText.text = "You are on level " + String(level)
        
        loadButtons()
    }
    
    func loadButtons(){
        //TODO: make buttons gray if level not reached
        level1.setLevel(lev: 1)
        level2.setLevel(lev: 2)
        level3.setLevel(lev: 3)
        level4.setLevel(lev: 4)
        level5.setLevel(lev: 5)
        level6.setLevel(lev: 6)
        level1.checkAccess(curLev: level)
    }
    
}
