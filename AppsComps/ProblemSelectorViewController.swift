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
    //TODO: user should retrieve information from Teacher or Student class, not Account class.
    //Actually it might need to be global
    //let user = Account(idToken: "123", name: "Jan")
    //TODO: level should also be taken from teacher/student class, or the global class
    let level = 4
    
    @IBOutlet weak var level1: UIButton!
    @IBOutlet weak var level2: UIButton!
    @IBOutlet weak var level3: UIButton!
    @IBOutlet weak var level4: UIButton!
    @IBOutlet weak var level5: UIButton!
    @IBOutlet weak var level6: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        greetingText.text = "Hello " + Account.sharedInstance.name!
        levelText.text = "You are on level " + String(level)
        
        loadButtons()
    }
    
    func loadButtons(){
        //TODO: make buttons gray if level not reached
        level1.backgroundColor = UIColor.green
        level2.backgroundColor = UIColor.green
        level3.backgroundColor = UIColor.green
        level4.backgroundColor = UIColor.green
        level5.backgroundColor = UIColor.gray
        level6.backgroundColor = UIColor.gray
    
    }
    
}
