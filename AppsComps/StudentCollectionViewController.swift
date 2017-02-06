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
    @IBOutlet var graphSegment: UISegmentedControl!
    var students = [String]()
    @IBAction func graphSegmentChanged(_ sender: AnyObject) {
        print("HHRKLJSDBGJKSDHBVKJHGDSBGJKSD")
        loadSampleStudents(studentList: ["Joan Baez", "Bob Dylan", "Billy Joel"])
        StudentCollection.reloadSections([1,2])
    }
    
   
    var level1Students = [String]()
    var level2Students = [String]()
    var level3Students = [String]()
    var level4Students = [String]()
    var studentsByLevel = [Int: [String]]()
    var levelNumbers = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Brynna had this next line of code but it interferes with the Logout Button
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        loadSampleStudents(studentList: ["Tiff Mering", "Josh Mering", "Jenner Mering", "Ray Mering", "Sarah Mering", "Mason Mering", "Sadie Mering", "John Mering", "Ellen Mering", "Karl Mering", "Kimm Mering", "Andrew Mering", "Nicole Sachse", "Rich Sachse", "Alex Sachse", "Jacob Sachse", "Maddie Sachse", "Willy Sachse", "Kate Feinberg", "Jack Feinberg", "Hanna Feinberg", "Melissa Haas", "Eric Haas", "Noah Haas", "Claire Haas", "Alex Tomala", "Christopher Omen",  "Danielle Omen", "Ty Hall", "Corrine Avenius", "Rick Avenius", "Lizzy Avenius", "April Durrett"])
        
        for student in students {
            if student.range(of: "Mering") != nil{
                level1Students.append(student)
            } else if student.range(of: "Sachse") != nil{
                level2Students.append(student)
            } else if student.range(of: "Feinberg") != nil{
                level3Students.append(student)
            } else {
                level4Students.append(student)
            }
            studentsByLevel = [1 : level1Students, 2 : level2Students, 3 : level3Students, 4 : level4Students]
            //levelNumbers = [Int](studentsByLevel.keys)
            levelNumbers = [1,2,3,4]
            print(levelNumbers)
            
        }        
        
    }
        //let toolbar = UIToolbar()
        //toolbar.frame = RectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 46)
//        toolbar.sizeToFit()
//        //toolbar.setItems(toolbarButtons, animated: true)
//        toolbar.backgroundColor = UIColor.red
//        self.view.addSubview(toolbar)
        //setLevels()
    
    
//    func setLevels(){
//        for student in students {
//            if student.range(of: "Mering") != nil{
//                level1Students.append(student)
//            } else if student.range(of: "Sachse") != nil{
//                level2Students.append(student)
//            } else if student.range(of: "Feinberg") != nil{
//                level3Students.append(student)
//            } else {
//                level4Students.append(student)
//            }
//            studentsByLevel = [1 : level1Students, 2 : level2Students, 3 : level3Students, 4 : level4Students]
//            //levelNumbers = [Int](studentsByLevel.keys)
//            levelNumbers = [1,2,3,4]
//            print(levelNumbers)
//            
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*  SPLIT VIEW NAVIGATION THINGS  */
    
    // When this view will appear bring back the primary view controller
    override func viewWillAppear(_ animated: Bool) {
        // Tests getting the split view controller
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
        splitViewController?.presentsWithGesture = true
//        let toolbar = UIToolbar()
//        
//        self.view.addSubview(toolbar)
        
        // instantiate spacer, middleItem
       // toolbar.items = @[spacer, middleItem, spacer];
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
        let numSections = levelNumbers.count + 1
        return numSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        sectionTitle = [animalSectionTitles objectAtIndex:section]
//        NSArray *sectionAnimals = [animals objectForKey:sectionTitle];
//        // #warning Incomplete implementation, return the number of items
//        if section == 0 {
//            return self.level1Students.count
//        } else if section == 1 {
//            return self.level2Students.count
//        } else if section == 2 {
//            return self.level3Students.count
//        } else if section == 3 {
//            return self.level4Students.count
//        } else {
//            return 0
//        }
        
        
        if section == 0{
            print(section)
            return 1
        } else {
            print(section)
            let sectionTitle = levelNumbers[section-1]
            let sectionStudents = studentsByLevel[sectionTitle]
            return sectionStudents!.count
        }
        
        //NSArray *sectionAnimals = [animals objectForKey:sectionTitle];
        //return [sectionAnimals count];
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //collectionView.reloadSections([0])
        
//        let student = self.students[indexPath.row]
//        if student.range(of: "Mering") != nil{
//            cell.backgroundColor = UIColor.red
//        } else if student.range(of: "Sachse") != nil{
//            cell.backgroundColor = UIColor.blue
//        } else if student.range(of: "Feinberg") != nil{
//            cell.backgroundColor = UIColor.green
//        } else {
//            cell.backgroundColor = UIColor.yellow
//        }
        
        if indexPath.section == 0{
            //let header = collectionView.dequeueReusableCell(withReuseIdentifier: "Header", for: indexPath) as! UICollectionReusableView
            //return header as! UICollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) 
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! StudentCollectionViewCell
            let sectionTitle = levelNumbers[indexPath.section-1]
            let sectionStudents = studentsByLevel[sectionTitle]!
            let student = sectionStudents[indexPath.row]
            cell.studentNameLabel.text = student
            
            return cell
        }
        
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
