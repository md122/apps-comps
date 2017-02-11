//
//  StudentCollectionViewController.swift
//  MasterDetailTest
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit


class StudentCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIToolbarDelegate {
    
    var students = [NSArray]()
    
    var level1Students = [NSArray]()
    var level2Students = [NSArray]()
    var level3Students = [NSArray]()
    var level4Students = [NSArray]()
    var studentsByLevel : [[NSArray]]? = nil
    var levelNumbers = ["Level 1", "Level 2", "Level 3", "Level 4"]
    let cellModeSegment = UISegmentedControl(items: ["Graph", "By Student"])
    
    var cellMode = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        collectionView?.allowsMultipleSelection = true
        
        if cellMode == nil {
            cellModeSegment.selectedSegmentIndex = 0
            cellMode = false
        } else if cellMode == false {
            cellModeSegment.selectedSegmentIndex = 0
        }  else if cellMode == true {
            cellModeSegment.selectedSegmentIndex = 1
        }
        
        
        
        getStudentData(studentList: [["Tiff Mering", "1", "000"], ["Tiff Mering", "1", "000"], ["Tiff Mering", "2", "000"], ["Tiff Mering", "3", "000"], ["Tiff Mering", "4", "000"], ["Tiff Mering", "4", "000"]])
        
    }
    
    func modeSegmentChanged(_ sender: AnyObject) {
        if sender.selectedSegmentIndex == 1 {
            self.cellMode = true
        } else {
            self.cellMode = false
        }
        self.collectionView?.reloadData()
    }

    func loadStudentCollection(classroomID: String) {
        if classroomID == "test" {
            getStudentData(studentList: [["Student Name", "1", "000"], ["Student Name", "1", "000"], ["Student Name", "2", "000"], ["Student Name", "3", "000"], ["Student Name", "4", "000"], ["Student Name", "4", "000"]])
            
        }
        self.collectionView?.reloadData()
        
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

//        let cellModeSegment = UISegmentedControl(items: ["Graph", "By Student"])
//        cellModeSegment.selectedSegmentIndex = 0
        //cellModeSegment.addTarget(self, action: #selector(modeSegmentChanged), for: .touchUpInside)
        cellModeSegment.addTarget(self, action: #selector(modeSegmentChanged), for: .allEvents)
        let segmentBarItem = UIBarButtonItem(customView: cellModeSegment)
       // let deleteStudentsButton = UISwitch()
        segmentBarItem.target = self
//        segmentBarItem.action = #selector(modeSegmentChanged)
        toolbarItems = [segmentBarItem]
        self.navigationController?.setToolbarItems(toolbarItems, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
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
        
        if section == 0{
            return 1
        } else {
            if cellMode {
                let sectionStudents = studentsByLevel?[section-1]
                return sectionStudents!.count
            } else {
                return 1
            }
        }
    }
    
//    www.raywenderlich.com/136161/uicollectionview-tutorial-reusable-views-selection-reordering
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeaderCollectionReusableView
                if indexPath.section == 0{
                    headerView.headerLabel1.text = "Classroom Name"
                    headerView.headerLabel2.text = "Classroom Code"
                } else if indexPath.section == 1{
                    headerView.headerLabel1.text = "Level 1"
                    headerView.headerLabel2.text = ""
                } else if indexPath.section == 2{
                    headerView.headerLabel1.text = "Level 2"
                    headerView.headerLabel2.text = ""
                } else if indexPath.section == 3{
                    headerView.headerLabel1.text = "Level 3"
                    headerView.headerLabel2.text = ""
                } else if indexPath.section == 4{
                    headerView.headerLabel1.text = "Level 4"
                    headerView.headerLabel2.text = ""
                } else {
                    headerView.headerLabel1.text = "ERROR"
                    headerView.headerLabel2.text = "ERROR"
                }
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath) 
            return cell
        } else {
            if cellMode {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! StudentCollectionViewCell
                //let sectionTitle = levelNumbers[indexPath.section-1]
                let sectionStudents = studentsByLevel?[indexPath.section-1]
                let student = sectionStudents?[indexPath.row]
                cell.studentNameLabel.text = (student?[0] as! String)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCell", for: indexPath)
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
          return CGSize(width: 10.0, height: 1.0)
        } else{
            if cellMode == true {
                return CGSize(width: 100.0, height: 100.0)
            } else {
                if indexPath.section == 1 {
                    return CGSize(width: 200.0, height: 100.0)
                } else if indexPath.section == 2 {
                    return CGSize(width: 100.0, height: 100.0)
                } else if indexPath.section == 3 {
                    return CGSize(width: 100.0, height: 100.0)
                } else if indexPath.section == 4 {
                    return CGSize(width: 300.0, height: 100.0)
                } else {
                    print("ALERT!! SAM!! A student is in a level not 1,2,3,or 4. This should not happen!")
                    return CGSize(width: 100.0, height: 100.0)
                }
            }
        }
    }
    
    func getStudentData(studentList: [NSArray]) {
        ///This is where we will requestClassroomInfo
        students = studentList
        
        level1Students.removeAll()
        level2Students.removeAll()
        level3Students.removeAll()
        level4Students.removeAll()
        
        for student in students {
            if student[1] as! String == "1"{
                level1Students.append(student)
            } else if student[1] as! String == "2"{
                level2Students.append(student)
            } else if student[1] as! String == "3"{
                level3Students.append(student)
            } else if student[1] as! String == "4"{
                level4Students.append(student)
            } else {
                print("ALERT!! SAM!! A student is in a level not 1,2,3,or 4. This should not happen!")
            }
        }
        studentsByLevel = [level1Students, level2Students, level3Students, level4Students]
    }
    


    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    

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
