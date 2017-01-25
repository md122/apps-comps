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
    var name: String?
    var idToken: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.style = GIDSignInButtonStyle.wide
        // Do any additional setup after loading the view.
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            GIDSignIn.sharedInstance().signOut()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    


    // Function that gets called when login data (1=no account, 2=student, or 3=teacher) comes back
    func handleLoginAttempt(data: String) {
        let connector = APIConnector()

        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            print("signed in")
            if (data == "ERROR: Account does not exist") {
                // Structure of how to write pop up taken from http://stackoverflow.com/questions/25511945/swift-alert-view-ios8-with-ok-and-cancel-button-which-button-tapped
                let createAccountAlert = UIAlertController(title: "Account Not Found", message: "You don't have an account with us. Create one now?", preferredStyle: UIAlertControllerStyle.alert)
                createAccountAlert.addAction(UIAlertAction(title: "Create Student Account", style: .default, handler: { (action: UIAlertAction!) in
                    connector.attemptCreateAccount(callingDelegate: self, idToken: self.idToken! , accountType: "student")
                    connector.attemptLogin(callingDelegate: self,  idToken: self.idToken!)
                }))
                createAccountAlert.addAction(UIAlertAction(title: "Create Teacher Account", style: .default, handler: { (action: UIAlertAction!) in
                    connector.attemptCreateAccount(callingDelegate: self, idToken: self.idToken!, accountType: "teacher")
                    connector.attemptLogin(callingDelegate: self, idToken: self.idToken!)
                }))
                createAccountAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                present(createAccountAlert, animated: true, completion: nil)
            }
            else if (data == "Student") {
                currentUser = Student(idToken: self.idToken!, name: name!)
                performSegue(withIdentifier: "loginToStudentDash", sender: self)
            }
            else if (data == "Teacher") {
                print ("is teacher")
                currentUser = Teacher(idToken: self.idToken!, name: name!)
                performSegue(withIdentifier: "loginToTeacherDash", sender: self)
            }
            else {
                print ("Error: Something is wrong with the server.")
            }
        } else {
            print ("not signed in")
        }

    }
    
    
    // Called from appdelegate after user is authenticated by google
    func didAttemptSignIn(idToken: String, name: String ) {
        let connector = APIConnector()
        self.name = name
        self.idToken = idToken
        connector.attemptLogin(callingDelegate: self, idToken: idToken)
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
