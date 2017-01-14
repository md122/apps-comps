//
//  LoginViewController.swift
//  AppsComps
//
//  Created by Marco Dow on 11/15/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, APIDataDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signInSilently()
        // Do any additional setup after loading the view.

 
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    // this is an example of how to use the APIConnector
    func testAPIConnector() {
        let connector = APIConnector()
        connector.attemptLogin(callingDelegate: self, idToken: "STUDENT1")
    }

    // Function that gets called when student data comes back
    func handleLoginAttempt(data: NSDecimalNumber) {
        let connector = APIConnector()
        connector.attemptLogin(callingDelegate: self, idToken: Account.sharedInstance.idToken!)
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            /*print("signed in")
            if (data == 1) {
                print ("dont have account")
            }
            else if (data == 2) {
                print ("has account")
            }
            else {
                print ("yikes")
            }*/
            
            performSegue(withIdentifier: "loginToStudentDash", sender: self)
        } else {
            print ("not signed in")
            //performSegue(withIdentifier: "your_segue_name", sender: self)
        }
        
        //QUESTION FROM WANCHEN: IS THIS WHERE YOU CALL THE USER TYPE?
        //call Student class, initialize it, direct to problem selector
        //call teacher class, init, direct to teacher dashboard
    }
    
    
 /*   func didAttemptSignIn() {
        let connector = APIConnector()
        connector.attemptLogin(callingDelegate: self, idToken: Account.sharedInstance.idToken!)
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            print("signed in")
            if (loginresponse == "1") {
                print ("dont have account")
            }
            else if (loginresponse == "2") {
                print ("has account")
            }
            else {
                print ("yikes")
            }
            
            //performSegue(withIdentifier: "loginToStudentDash", sender: self)
        } else {
            print ("not signed in")
            //performSegue(withIdentifier: "your_segue_name", sender: self)
        }
    }
    */



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
