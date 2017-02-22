//
//  ProgressSplitViewController.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/16/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ProgressSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Student Progress"
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "FromTeacherToProblemSelector") {
            self.navigationController?.setToolbarHidden(true, animated: false)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
        let logoutButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
        logoutButton.tintColor = .red
    }
    
    
    func logoutClicked(_ sender: UIBarButtonItem) {
        let logOutAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Log out option
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
                GIDSignIn.sharedInstance().signOut()
            }
            currentUser = nil
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        // cancel option
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(logOutAlert, animated: true, completion: nil)
    }
}
