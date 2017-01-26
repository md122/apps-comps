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

    @IBOutlet weak var studentLogoutButton: UIBarButtonItem!

    //TODO: level should also be taken from teacher/student class, or the global class
    let level = 4
    
    override func viewDidLoad() {
        
        // Creates a fake user for testing purposes
        if(currentUser == nil) {
            currentUser = Student(idToken: "fakeID", name: "Wanchen Orange")
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        greetingText.text = "Hello " + currentUser!.getName()
        levelText.text = "You are on level " + String(level)
        
        
        // Set the UIButton to Logout if the less than 2 items on navigation stack
        // This occurs when a going straight from the login to student view
        // In other words make a logout button on student view, but not if coming from teacher
        if let navController = self.navigationController, navController.viewControllers.count < 2 {
            let leftButton: UIBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
            leftButton.tintColor = .red
            self.navigationItem.leftBarButtonItem = leftButton
        }
    }
    
    
    // Note there is a similar logout in Teacher, changes to one should also go in the other
    // At some point Sam should figure out how to just merge the two, because this is sloppy
    @IBAction func logoutClicked(_ sender: AnyObject) {
        let createAccountAlert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Log out option
        createAccountAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            GIDSignIn.sharedInstance().signOut()
        }
        currentUser = nil
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        // cancel option
        createAccountAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(createAccountAlert, animated: true, completion: nil)
    }
}
