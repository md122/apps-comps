//
//  AppDelegate.swift
//  AppsComps
//
//  Created by appscomps on 10/25/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, APIDataDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func requestStudentData() {
        let connector = APIConnector()
        connector.testRequest(callingDelegate: self)
    }
    
    
    func handleStudentData(data: [NSArray]) {
        print("Handling Student Data")
        print(data)
        for dataPoint in data{
            //let dataP = dataPoint as! NSArray
            print("\(dataPoint[0])'s favortie color is \(dataPoint[1])")
        }
    }
    
    // Function that gets called when student data comes back
    func handleLoginAttempt(data: NSDecimalNumber) {
        print(data)
        
        //QUESTION FROM WANCHEN: IS THIS WHERE YOU CALL THE USER TYPE?
        //call Student class, initialize it, direct to problem selector
        //call teacher class, init, direct to teacher dashboard
    }
    
    // Function that gets called when creating account
    func handleCreateAccountAttempt(data: [NSArray]) {
        print(data)
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        //let viewController = self.window!.rootViewController! as UIViewController
        //let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        //navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        //viewController.delegate = self
        //return true
        
        /*
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        return true
         */
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        requestStudentData()
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // From tutorial, handles url received at the end of authenticiation process
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
    // Google sign-in methods from tutorial
    // The sign-in flow has finished and was successful if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            //let userId = user.userID                  // For client-side use only!
            let userToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let connector = APIConnector()
            connector.attemptLogin(callingDelegate: self, idToken: userToken!)
            //connector.attemptCreateAccount(callingDelegate: self, idToken: userToken!, accountType: "student")
            Account.sharedInstance.idToken = userToken!
            Account.sharedInstance.name = fullName!
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //sign out user somehow
    }


}

