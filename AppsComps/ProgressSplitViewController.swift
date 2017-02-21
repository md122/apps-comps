//
//  ProgressSplitViewController.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/16/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ProgressSplitViewController: UISplitViewController {

    @IBOutlet var helpButton: UIBarButtonItem!
    
    @IBOutlet var logoutButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Student Progress"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func helpClicked(_ sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpPopUpID") as! HelpViewController
        popOverVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    @IBAction func logoutClicked(_ sender: AnyObject) {
        let logoutAlert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Log out option
        logoutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
                GIDSignIn.sharedInstance().signOut()
            }
            currentUser = nil
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        // cancel option
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(logoutAlert, animated: true, completion: nil)
    }

    
//    @IBAction func logoutClicked(_ sender: AnyObject) {
//        let logoutAlert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
//        
//        // Log out option
//        logoutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
//            if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
//                GIDSignIn.sharedInstance().signOut()
//            }
//            currentUser = nil
//            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
//        }))
//        // cancel option
//        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//        }))
//        present(logoutAlert, animated: true, completion: nil)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
