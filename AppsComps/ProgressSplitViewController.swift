//
//  ProgressSplitViewController.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/16/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ProgressSplitViewController: UISplitViewController {

    @IBOutlet var logoutButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Student Progress"
        //let logoutButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
        logoutButton.tintColor = .red
        //self.navigationItem.rightBarButtonItem = logoutButton
//        let helpButton: UIBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(self.helpClicked(_:)))
//        self.navigationItem.leftBarButtonItem = helpButton
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbarItems = [flexibleSpace, logoutButton]
        self.navigationController?.setToolbarItems(toolbarItems, animated: false)
        //self.navigationController?.setToolbarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutClicked(_ sender: AnyObject) {
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
//    func logoutClicked(_ sender: UIBarButtonItem) {
//        let logOutAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
//        
//        // Log out option
//        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
//            if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
//                GIDSignIn.sharedInstance().signOut()
//            }
//            currentUser = nil
//            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
//        }))
//        // cancel option
//        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//        }))
//        present(logOutAlert, animated: true, completion: nil)
//    }
//    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if(segue.identifier == "FromTeacherToProblemSelector") {
//            splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryHidden
//            splitViewController?.presentsWithGesture = true
            self.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryHidden
            self.navigationController?.setToolbarHidden(true, animated: false)
        }
        
    }
    
//    (void)splitViewController:(UISplitViewController*)splitController willHideViewController:(UIViewController*)viewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)popoverController
    
//    func helpClicked(_ sender: UIBarButtonItem) {
//        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpPopUpID") as! HelpViewController
//        popOverVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
//    }

}
