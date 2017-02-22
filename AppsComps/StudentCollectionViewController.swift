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
    
    @IBOutlet var showTableButton: UIBarButtonItem!

    var level1Students = [NSArray]()
    var level2Students = [NSArray]()
    var level3Students = [NSArray]()
    var level4Students = [NSArray]()
    var studentsByLevel : [[NSArray]]? = nil
    var levelNumbers = ["Level 1", "Level 2", "Level 3", "Level 4"]
    var cellModeSegment = UISegmentedControl(items: ["Overview", "Students"])
    var isCollapsed = false
    //var toolbarItems = [UIBarButtonItem]
   
    
    var cellMode = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        studentsByLevel = [level1Students, level2Students, level3Students, level4Students]
        if(currentUser == nil) {
            currentUser = Teacher(idToken: "23", name: "Meg Crenshaw")
            (currentUser as! Teacher).testAPIConnector()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
//        getStudentData(studentList: [["Meghan Kreilkamp", "1", "000"], ["McCartney Goff", "1", "000"], ["Michael Botwick", "1", "000"], ["Matthew Meyers", "2", "000"], ["Gemma Pillsbury", "3", "000"], ["Angelia Jenkins", "3", "000"], ["Ryan Vondren", "3", "000"], ["Dani Kohlwalki", "4", "000"], ["Hannah Klemm", "4", "000"], ["Anna Mahinzki", "4", "000"], ["Eric Munz", "4", "000"], ["Tyler Hienke", "4", "000"], ["Karsen Greenwood", "4", "000"], ["Megan Collins", "4", "000"]])
        
    }
    
    func loadData(studentsData: [NSArray]) {
        getRealStudentData(studentList: studentsData)
        self.collectionView?.reloadData()
    }
    
    func getRealStudentData(studentList: [NSArray]) {
        ///This is where we will requestClassroomInfo
        students = studentList
        
        level1Students.removeAll()
        level2Students.removeAll()
        level3Students.removeAll()
        level4Students.removeAll()
        
        for student in students {
            if student[1] as! Int == 1{
                level1Students.append(student)
            } else if student[1] as! Int == 2{
                level2Students.append(student)
            } else if student[1] as! Int == 3{
                level3Students.append(student)
            } else if student[1] as! Int == 4{
                level4Students.append(student)
            } else {
                print("ALERT!! SAM!! A student is in a level not 1,2,3,or 4. This should not happen!")
            }
        }
        studentsByLevel = [level1Students, level2Students, level3Students, level4Students]
    }
    
    func modeSegmentChanged(_ sender: AnyObject) {
        if sender.selectedSegmentIndex == 1 {
            self.cellMode = true
        } else {
            self.cellMode = false
        }
        self.collectionView?.reloadData()
    }

//    func loadStudentCollection(classroomID: String) {
//        if classroomID == "0" {
//            getStudentData(studentList: [["Meghan Kreilkamp", "1", "000"], ["McCartney Goff", "1", "000"], ["Michael Bostwick", "1", "000"], ["Matthew Meyers", "2", "000"], ["Gemma Pillsbury", "3", "000"], ["Angelia Jenkins", "3", "000"], ["Ryan Vondren", "3", "000"], ["Dani Kohlwalki", "4", "000"], ["Hannah Klemm", "4", "000"], ["Anna Mahinzki", "4", "000"], ["Eric Munz", "4", "000"], ["Tyler Hienke", "4", "000"], ["Karsen Greenwood", "4", "000"], ["Megan Collins", "4", "000"]])
//        }else if classroomID == "1" {
//            getStudentData(studentList: [["Meghan Kreilkamp", "2", "000"], ["McCartney Goff", "2", "000"], ["Michael Bostwick", "2", "000"], ["Matthew Meyers", "2", "000"], ["Gemma Pillsbury", "2", "000"], ["Angelia Jenkins", "1", "000"], ["Ryan Vondren", "1", "000"], ["Dani Kohlwalki", "4", "000"], ["Hannah Klemm", "4", "000"], ["Anna Mahinzki", "4", "000"], ["Eric Munz", "4", "000"], ["Tyler Hienke", "4", "000"], ["Karsen Greenwood", "4", "000"], ["Megan Collins", "4", "000"]])
//        } else if classroomID == "2" {
//            getStudentData(studentList: [["Student Name", "1", "000"], ["Student Name", "1", "000"], ["Student Name", "2", "000"], ["Student Name", "3", "000"], ["Student Name", "4", "000"], ["Student Name", "4", "000"]])
//        } else {
//            getStudentData(studentList: [["Student Name", "1", "000"]])
//        }
//        self.collectionView?.reloadData()
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

        cellModeSegment = UISegmentedControl(items: ["Overview", "Students"])
        
//        if cellMode == nil {
//            cellModeSegment.selectedSegmentIndex = 0
//            cellMode = false
//        } else
        if cellMode == false {
            cellModeSegment.selectedSegmentIndex = 0
        }  else if cellMode == true {
            cellModeSegment.selectedSegmentIndex = 1
        }
        cellModeSegment.addTarget(self, action: #selector(modeSegmentChanged), for: .allEvents)
        let segmentBarItem = UIBarButtonItem(customView: cellModeSegment)
        segmentBarItem.target = self
        //let showIDButton: UIBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(self.helpClicked(_:)))
        let showIDButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.helpClicked(_:)))
//        self.navigationItem.leftBarButtonItem = showTableButton
        self.navigationItem.leftBarButtonItem = showIDButton
        self.navigationItem.rightBarButtonItem = segmentBarItem
        let logoutButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
        logoutButton.tintColor = .red
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbarItems = [flexibleSpace, logoutButton]
        self.navigationController?.setToolbarItems(toolbarItems, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)


    }
    
    func helpClicked(_ sender: UIBarButtonItem) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpPopUpID") as! HelpViewController
        popOverVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if(segue.identifier == "FromTeacherToProblemSelector") {
            splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryHidden
            splitViewController?.presentsWithGesture = true
        }
        
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numSections = levelNumbers.count
        return numSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellMode {
            let sectionStudents = studentsByLevel?[section]
            if sectionStudents!.count == 0{
                return 1
            } else {
                return sectionStudents!.count
            }
        } else {
            return 1
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
                    headerView.headerLabel1.text = "Level 1"
                } else if indexPath.section == 1{
                    headerView.headerLabel1.text = "Level 2"
                } else if indexPath.section == 2{
                    headerView.headerLabel1.text = "Level 3"
                } else if indexPath.section == 3{
                    headerView.headerLabel1.text = "Level 4"
                } else {
                    headerView.headerLabel1.text = "ERROR"
                }
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellMode == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentCell", for: indexPath) as! StudentCollectionViewCell
            if indexPath.section == 0{
                cell.backgroundColor = UIColor.red
            } else if indexPath.section == 1{
                cell.backgroundColor = UIColor(red:0.14, green:0.59, blue:0.85, alpha:1.0)
            } else if indexPath.section == 2{
                cell.backgroundColor = UIColor(red:0.14, green:0.85, blue:0.16, alpha:1.0)
            } else if indexPath.section == 3{
                cell.backgroundColor = UIColor.yellow
            }
            
            let sectionStudents = studentsByLevel?[indexPath.section]
            if sectionStudents?.count == 0{
                cell.backgroundColor = UIColor.lightGray
                cell.studentNameLabel.text = "No Students"
                cell.frame.size.width = CGFloat(100.0)
                cell.frame.size.height = CGFloat(100.0)
            } else {
                let student = sectionStudents?[indexPath.row]
                cell.studentNameLabel.text = (student?[0] as! String)
                cell.frame.size.width = CGFloat(100.0)
                cell.frame.size.height = CGFloat(100.0)
            }
             return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCell", for: indexPath) as! GraphCollectionViewCell
            cell.backgroundColor = UIColor.white
            let collectionWidth = floor(collectionView.frame.size.width)
           // CHANGE THIS, a buggy fix so that it doesn't break with no students in classroom
            var totalStudentsDouble = 0.0
            if !(studentsByLevel != nil) {
                totalStudentsDouble = 1.0
            } else {
                let totalStudents = (studentsByLevel?[0].count)! + (studentsByLevel?[1].count)! + (studentsByLevel?[2].count)! + (studentsByLevel?[3].count)!
                totalStudentsDouble = Double(totalStudents)
                if totalStudentsDouble == 0.0 {
                    totalStudentsDouble = 1.0
                }
            }
            
            if indexPath.section == 0 {
                var percent = (Double(level1Students.count) / totalStudentsDouble)
                let width1 = Double(collectionWidth) * percent
                percent = Double(round(1000*percent)/10)
                cell.barLabel.text = String(percent) + "%"
                cell.graphBar.backgroundColor = UIColor.red
                cell.graphBar.frame.size.width = CGFloat(width1)
            } else if indexPath.section == 1 {
                var percent = (Double(level2Students.count) / totalStudentsDouble)
                let width2 = Double(collectionWidth) * percent
                percent = Double(round(1000*percent)/10)
                cell.barLabel.text = String(percent) + "%"
                cell.graphBar.backgroundColor = UIColor(red:0.14, green:0.59, blue:0.85, alpha:1.0)
                cell.graphBar.frame.size.width = CGFloat(width2)
            } else if indexPath.section == 2 {
                var percent = (Double(level3Students.count) / totalStudentsDouble)
                let width3 = Double(collectionWidth) * percent
                percent = Double(round(1000*percent)/10)
                cell.barLabel.text = String(percent) + "%"
                cell.graphBar.backgroundColor = UIColor(red:0.14, green:0.85, blue:0.16, alpha:1.0)
                cell.graphBar.frame.size.width = CGFloat(width3)
            } else if indexPath.section == 3 {
                var percent = (Double(level4Students.count) / totalStudentsDouble)
                let width4 = Double(collectionWidth) * percent
                percent = Double(round(1000*percent)/10)
                cell.barLabel.text = String(percent) + "%"
                cell.graphBar.backgroundColor = UIColor.yellow
                cell.graphBar.frame.size.width = CGFloat(width4)
            } else {
                print("ALERT!! SAM!! A student is in a level not 1,2,3,or 4. This should not happen!")
            }
             return cell
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = floor(collectionView.frame.size.width)
        if cellMode == true {
            return CGSize(width: 100.0, height: 100.0)
        } else {
            return CGSize(width: collectionWidth, height: 100.0)
        }
    }
    
    @IBAction func showButtonClicked(_ sender: AnyObject) {
         self.showTable()
    }
    
//    func getStudentData(studentList: [NSArray]) {
//        ///This is where we will requestClassroomInfo
//        students = studentList
//        
//        level1Students.removeAll()
//        level2Students.removeAll()
//        level3Students.removeAll()
//        level4Students.removeAll()
//        
//        for student in students {
//            if student[1] as! String == "1"{
//                level1Students.append(student)
//            } else if student[1] as! String == "2"{
//                level2Students.append(student)
//            } else if student[1] as! String == "3"{
//                level3Students.append(student)
//            } else if student[1] as! String == "4"{
//                level4Students.append(student)
//            } else {
//                print("ALERT!! SAM!! A student is in a level not 1,2,3,or 4. This should not happen!")
//            }
//        }
//        
//        studentsByLevel = [level1Students, level2Students, level3Students, level4Students] 
//    }
    
    func hideTable() {
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryHidden
        splitViewController?.presentsWithGesture = true
        self.navigationItem.leftBarButtonItem = showTableButton
        showTableButton.title = "<My Classes"
        self.collectionView?.reloadData()
    }
    
    func showTable() {
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
        splitViewController?.presentsWithGesture = true
        self.navigationItem.leftBarButtonItem = showTableButton
        showTableButton.title = ""
        self.collectionView?.reloadData()
    }
    
    func setTitle(className: String) {
        self.navigationItem.title = className
        self.collectionView?.reloadData()
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
