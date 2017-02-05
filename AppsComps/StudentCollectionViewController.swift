//
//  StudentCollectionViewController.swift
//  MasterDetailTest
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit


class StudentCollectionViewController: UICollectionViewController {
    
    @IBOutlet var StudentCollection: UICollectionView!
    var students = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Brynna had this next line of code but it interferes with the Logout Button
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        if(currentUser == nil) {
            currentUser = Teacher(idToken: "23", name: "Meg Crenshaw")
            (currentUser as! Teacher).testAPIConnector()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        loadSampleStudents(studentList: ["Tiff Mering", "Josh Mering", "Jenner Mering", "Ray Mering", "Sarah Mering", "Mason Mering", "Sadie Mering", "John Mering", "Ellen Mering", "Karl Mering", "Kimm Mering", "Andrew Mering", "Nicole Sachse", "Rich Sachse", "Alex Sachse", "Jacob Sachse", "Maddie Sachse", "Willy Sachse", "Kate Feinberg", "Jack Feinberg", "Hanna Feinberg", "Melissa Haas", "Eric Haas", "Noah Haas", "Claire Haas", "Alex Tomala", "Christopher Omen",  "Danielle Omen", "Ty Hall", "Corrine Avenius", "Rick Avenius", "Lizzy Avenius", "April Durrett"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*  SPLIT VIEW NAVIGATION THINGS  */
    
    // When this view will appear bring back the primary view controller
    override func viewWillAppear(_ animated: Bool) {
        // Tests getting the split view controller
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
        splitViewController?.presentsWithGesture = true
    }

    // Note there is a similar logout in Student, changes to one should also go in the other
    @IBAction func logoutClicked(_ sender: AnyObject) {
        let createAccountAlert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Log out option
        createAccountAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
                GIDSignIn.sharedInstance().signOut()
            }
            currentUser = nil
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        // cancel option
        createAccountAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(createAccountAlert, animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if(segue.identifier == "FromTeacherToProblemSelector") {
            splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryHidden
            splitViewController?.presentsWithGesture = false
        }
        
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
        return self.students.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! StudentCollectionViewCell
        
        let student = self.students[indexPath.row]
        if student.range(of: "Mering") != nil{
            cell.backgroundColor = UIColor.red
        } else if student.range(of: "Sachse") != nil{
            cell.backgroundColor = UIColor.blue
        } else if student.range(of: "Feinberg") != nil{
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        
        cell.studentNameLabel.text = student
    
        return cell
    }
    
    func loadSampleStudents(studentList: [String]) {
        
        students = studentList
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
