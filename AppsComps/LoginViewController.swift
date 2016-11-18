//
//  LoginViewController.swift
//  AppsComps
//
//  Created by Marco Dow on 11/15/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, APIDataDelegate  {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
        testAPIConnector()
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
        connector.attemptLogin(callingDelegate: self, userID: "User1")
        connector.attemptLogin(callingDelegate: self, userID: "User27")
        
        connector.attemptCreateAccount(callingDelegate: self, userID: "User1", userName: "James", accountType: "0")
    }
    
    // Function that gets called when student data comes back
    func handleLoginAttempt(data: Bool) {
        print("\n\n\n\n\n")
        print("Incoming handleLoginAttempt data")
        print(data)
    }
    
    // Function that gets called when next problem comes back
    func handleCreateAccountAttempt(data: Bool) {
        print("-------------------------")
        print()
        print("Incoming handleCreateAccountAttempt data")
        print(data)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
