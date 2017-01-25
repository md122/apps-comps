//
//  ProblemSelectorViewController.swift
//  TeacherDashSingleView
//
//  Created by Wanchen Yao on 11/9/16.
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
    @IBOutlet weak var levelContainerView: UIView!


    //TODO: level should also be taken from teacher/student class, or the global class
    let level = 4
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        greetingText.text = "Hello " + currentUser!.getName()
        levelText.text = "You are on level " + String(level)

    }
    

    
}
