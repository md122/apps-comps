//
//  StudentCollectionViewController.swift
//  MasterDetailTest
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit


class StudentCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIToolbarDelegate {

    var classroomName : String? = nil
    var classroomID : String? = nil
    
    var students = [NSArray]()

//    var level1Students = [NSArray]()
//    var level2Students = [NSArray]()
//    var level3Students = [NSArray]()
//    var level4Students = [NSArray]()
    var studentsByLevel : [[NSArray]]? = nil
    
    var cellMode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let emptyLevel = [NSArray]()
        studentsByLevel = [emptyLevel, emptyLevel, emptyLevel, emptyLevel]
        
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
        splitViewController?.presentsWithGesture = false
        

        let cellModeSegment = UISegmentedControl(items: ["Students", "Overview"])
        cellModeSegment.selectedSegmentIndex = 0
        cellModeSegment.addTarget(self, action: #selector(modeSegmentChanged), for: .allEvents)
        
        let segmentBarItem = UIBarButtonItem(customView: cellModeSegment)
        segmentBarItem.target = self
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
        logoutButton.tintColor = .red
        
        toolbarItems = [segmentBarItem, flexibleSpace, logoutButton]
        self.navigationController?.setToolbarItems(toolbarItems, animated: false)
        
        let addStudentsButton = UIBarButtonItem(title: "Add Students", style: .plain, target: self, action: #selector(self.shareClicked(_:)))
        self.navigationItem.rightBarButtonItem = addStudentsButton
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadStudentList(studentsInClassroom: [NSArray]) {
        
        students = studentsInClassroom
        
        studentsByLevel?.removeAll()
        let emptyLevel = [NSArray]()
        studentsByLevel = [emptyLevel, emptyLevel, emptyLevel, emptyLevel]
        
        for student in students {
            if student[1] as! Int == 1{
                studentsByLevel?[0].append(student)
                //level1Students.append(student)
            } else if student[1] as! Int == 2{
                studentsByLevel?[1].append(student)
                //level2Students.append(student)
            } else if student[1] as! Int == 3{
                studentsByLevel?[2].append(student)
                //level3Students.append(student)
            } else if student[1] as! Int == 4{
                studentsByLevel?[3].append(student)
                //level4Students.append(student)
            } else {
                //print("ALERT!! SAM!! A student is in a level not 1,2,3,or 4. This should not happen!")
            }
        }
        //studentsByLevel = [level1Students, level2Students, level3Students, level4Students]
        self.collectionView?.reloadData()
    }
    
    func setClassroomIDAndName(id: Int, name: String) {
        self.classroomName = name
        self.classroomID = String(id)
    }
    
    func modeSegmentChanged(_ sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 {
            self.cellMode = true
        } else {
            self.cellMode = false
        }
        self.collectionView?.reloadData()
    }
    
    func logoutClicked(_ sender: UIBarButtonItem) {
        let logOutAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
                GIDSignIn.sharedInstance().signOut()
            }
            currentUser = nil
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))

        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(logOutAlert, animated: true, completion: nil)
    }
    
    func shareClicked(_ sender: UIBarButtonItem) {
        let shareAlert = UIAlertController(title: classroomID, message: "Share this number with your students", preferredStyle: UIAlertControllerStyle.alert)
        
        shareAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(shareAlert, animated: true, completion: nil)
    }
 
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
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

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeaderCollectionReusableView
                headerView.headerLabel.text = "Level " + String(indexPath.section + 1)
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
//                cell.frame.size.width = CGFloat(100.0)
//                cell.frame.size.height = CGFloat(100.0)
            } else {
                let student = sectionStudents?[indexPath.row]
                cell.studentNameLabel.text = (student?[0] as! String)
                cell.studentNameLabel.adjustsFontSizeToFitWidth = true
//                cell.frame.size.width = CGFloat(100.0)
//                cell.frame.size.height = CGFloat(100.0)
            }
             return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCell", for: indexPath) as! GraphCollectionViewCell
            cell.backgroundColor = UIColor.white
            let width = floor(collectionView.frame.size.width) - 20
            
            if indexPath.section == 0 {
                cell.graphBar.backgroundColor = UIColor.red
                self.resizeGraphBar(cell: cell, level: 0, cellWidth: width)
            } else if indexPath.section == 1 {
                cell.graphBar.backgroundColor = UIColor(red:0.14, green:0.59, blue:0.85, alpha:1.0)
                self.resizeGraphBar(cell: cell, level: 1, cellWidth: width)
            } else if indexPath.section == 2 {
                cell.graphBar.backgroundColor = UIColor(red:0.14, green:0.85, blue:0.16, alpha:1.0)
                self.resizeGraphBar(cell: cell, level: 2, cellWidth: width)
            } else if indexPath.section == 3 {
                cell.graphBar.backgroundColor = UIColor.yellow
                self.resizeGraphBar(cell: cell, level: 3, cellWidth: width)
            }
             return cell
        }
    }
    
    func resizeGraphBar(cell: GraphCollectionViewCell, level: Int, cellWidth: CGFloat) {
        
        //let barWidth = collectionWidth - 20
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
        var percent = (Double((studentsByLevel?[level].count)!) / totalStudentsDouble)
        let barWidth = Double(cellWidth) * percent
        percent = Double(round(1000*percent)/10)
        cell.percentLabel.text = String(percent) + "%"
        if (studentsByLevel?[level].count)! == 1 {
            cell.studentsLabel.text = String((studentsByLevel?[level].count)!) + " Student"
        } else {
            cell.studentsLabel.text = String((studentsByLevel?[level].count)!) + " Students"
        }

        if (studentsByLevel?[level].count)! > 0 {
            cell.graphBar.frame.size.width = CGFloat(barWidth)
        } else {
            cell.graphBar.frame.size.width = CGFloat(5.0)
            cell.graphBar.backgroundColor = UIColor.lightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let graphCellWidth = floor(collectionView.frame.size.width)-20
        if cellMode == true {
            return CGSize(width: 100.0, height: 100.0)
        } else {
            return CGSize(width: graphCellWidth, height: 100.0)
        }
    }

}
