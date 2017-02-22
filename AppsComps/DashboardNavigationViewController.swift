//
//  DashboardNavigationViewController.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/20/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class DashboardNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // let logoutButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: (logoutClicked(_:)))
       let logoutButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
        self.navigationItem.leftBarButtonItem = logoutButton
        // Do any additional setup after loading the view.
        toolbarItems = [logoutButton]
        self.setToolbarItems(toolbarItems, animated: false)
        self.setToolbarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
