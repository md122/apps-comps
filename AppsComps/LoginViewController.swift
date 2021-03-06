//
//  LoginViewController.swift
//  AppsComps
//
//  Created by Marco Dow on 11/15/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, APIDataDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    var name: String?
    var idToken: String?
    
    @IBOutlet weak var toStudentDashButton: UIButton!
    @IBOutlet weak var toTeacherDashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.style = GIDSignInButtonStyle.wide
        //GIDSignIn.sharedInstance().signInSilently()
        // Do any additional setup after loading the view.
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            GIDSignIn.sharedInstance().signOut()
        }
        
        toTeacherDashButton.isHidden = true
        toStudentDashButton.isHidden = true
        
        //let connect = APIConnector()
        //connect.attemptAddClassroom(callingDelegate: self, teacherID: "23", classroomName: "CatsRoom")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    
    // Function that gets called when login data (1=no account, 2=student, or 3=teacher) comes back
    func handleLoginAttempt(data: NSDictionary) {
        let connector = APIConnector()
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            print("signed in")
            if (data["error"] as! String == "ERROR: Account does not exist") {
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
            else if data["error"] as! String == "HTTP" {
                APIConnector().connectionDropped(callingDelegate: self)
            }
            else if (data["data"] as! String == "Student") {
                currentUser = Student(idToken: self.idToken!, name: name!)
                performSegue(withIdentifier: "loginToStudentDash", sender: self)
            }
            else if (data["data"] as! String == "Teacher") {
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
    
    // From google tutorial, handles url received at the end of authenticiation process
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    // Google sign-in methods from tutorial
    // The sign-in flow has finished and was successful if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            //let userId = user.userID                  // For client-side use only!
            self.idToken = user.authentication.idToken // Safe to send to the server
            self.name = user.profile.name
            let connector = APIConnector()
            connector.attemptLogin(callingDelegate: self, idToken: idToken!)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    // Function that gets called when next problem comes back
    func handleCreateAccountAttempt(data: NSDictionary) {
        print("Incoming handleNextProblem data")
        print(data)
        
    }
        
}
