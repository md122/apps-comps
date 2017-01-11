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
        GIDSignIn.sharedInstance().signInSilently()
        // Do any additional setup after loading the view.
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            print("signed in")
            //performSegue(withIdentifier: "your_segue_name", sender: self)
        } else {
            print ("not signed in")
            //performSegue(withIdentifier: "your_segue_name", sender: self)
        }
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
        connector.attemptLogin(callingDelegate: self, idToken: "User1")
        connector.attemptLogin(callingDelegate: self, idToken: "User27")
        
        connector.attemptCreateAccount(callingDelegate: self, idToken: "User1", accountType: "0")
    }
    
    // Function that gets called when student data comes back
    func handleLoginAttempt(data: NSDecimalNumber) {
        print("\n\n\n\n\n")
        print("Incoming handleLoginAttempt data")
        print(data)
    }
    
    // Function that gets called when next problem comes back
    func handleCreateAccountAttempt(data: [NSArray]) {
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
