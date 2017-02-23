
//
//  MasterViewController.swift
//  MasterDetailTest
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit

class ClassroomTableMasterViewController: UITableViewController, APIDataDelegate {

    //@IBOutlet var collapseButton: UIBarButtonItem!
    //@IBOutlet var rightBarButton: UIBarButtonItem!
    //@IBOutlet var leftBarButton: UIBarButtonItem!
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    var detailViewController: StudentCollectionViewController? = nil
    var classrooms = [NSArray]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? StudentCollectionViewController
        }
        tableView.allowsMultipleSelectionDuringEditing = true
        
        APIConnector().requestGetClassroomsForTeacher(callingDelegate: self, teacherID: currentUser!.getIdToken())
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.isEditing == false{
            self.isEditing = true
            sender.title = "Done"
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteClassroomList(_:)))
            self.navigationItem.leftBarButtonItem = trashButton
//            let indexPath = IndexPath(row: self.classrooms.count, section: 0)
//            self.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            self.isEditing = false
            sender.title = "Edit"
            self.navigationItem.leftBarButtonItem = nil
            //let indexPath = IndexPath(row: self.classrooms.count, section: 0)
           // self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
//    @IBAction func collapseClicked(_ sender: AnyObject) {
//        //splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryHidden
//        detailViewController?.hideTable()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleGetClassroomsForTeacherRequest(data: NSDictionary) {
        if data["error"] as! String == "none" {
            classrooms = data["data"] as! [NSArray]
            self.tableView.reloadData()
            if classrooms.count > 0 {
                let firstClassroomRow = IndexPath(row: 0, section: 0)
                self.tableView.selectRow(at: firstClassroomRow, animated: true, scrollPosition: UITableViewScrollPosition.none)
                let firstClassroomID = String(classrooms[0][1] as! Int)
                APIConnector().requestClassroomData(callingDelegate: self, classroomID: firstClassroomID)
                self.detailViewController?.setTitle(className: (classrooms[0][0] as! String))
            }
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        } else {
            print("Database error, run and scream")
        }
    }
    
    func handleAddClassroomAttempt(data: NSDictionary) {
        if data["error"] as! String == "none" {
            print(data["data"])
            let classroomData = data["data"] as! [NSArray]
            self.classrooms.insert([classroomData[0][0], classroomData[0][1]], at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            //let firstClassroomRow = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
            let newClassroomID = String(classrooms[0][1] as! Int)
            APIConnector().requestClassroomData(callingDelegate: self, classroomID: newClassroomID)
            self.detailViewController?.setTitle(className: (classrooms[0][0] as! String))
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        } else {
            print("Database error, run and scream")
        }
    }
    
    // Called after attempting to remove a classroom
    // If success removes the classroom
    func handleRemoveClassroomAttempt(data: NSDictionary, classID: Int) {
        if(data["error"] as! String == "none") {
            var removeIndex = -1
            print(classrooms.count)
            for i in 0...(classrooms.count - 1) {
                if classrooms[i][1] as! Int == classID {
                    removeIndex = i
                }
            }
            if removeIndex > -1 {
                classrooms.remove(at: removeIndex)
                let path = IndexPath(row: removeIndex, section: 0)
                tableView.deleteRows(at: [path], with: .automatic)
            }
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        } else {
            print("Database error, need to handle this")
        }
    }
    
    func handleClassroomDataRequest(data: NSDictionary) {
        if(data["error"] as! String == "none") {
            detailViewController?.loadStudentList(studentsInClassroom: data["data"] as! [NSArray])
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        }
    }

    func insertNewObject() {
        let createClassroomAlert = UIAlertController(title: "New Classroom", message: "Enter classroom name:", preferredStyle: UIAlertControllerStyle.alert)
        
        // Text field to enter Classroom name
        createClassroomAlert.addTextField(configurationHandler: nil)
        
        // cancel option
        createClassroomAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in}))
        // adds new classroom to table
        createClassroomAlert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: { (action: UIAlertAction!) in
            if self.isEditing == true {
                self.isEditing = false
                self.editButton.title = "Edit"
                self.navigationItem.leftBarButtonItem = nil
            }
            let classroomName = createClassroomAlert.textFields![0].text!
            APIConnector().attemptAddClassroom(callingDelegate: self, teacherID: currentUser!.getIdToken(), classroomName: classroomName)
        }))
        
        present(createClassroomAlert, animated: true, completion: nil)
    }
    
    func deleteClassroomList(_ sender: UIBarButtonItem) {
        let deleteClassroomsAlert = UIAlertController(title: "Delete Classrooms", message: "Are you sure you want to delete these classrooms?", preferredStyle: UIAlertControllerStyle.alert)
        
        // cancel option
        deleteClassroomsAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in}))
        // deletes classrooms from table
        deleteClassroomsAlert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: { (action: UIAlertAction!) in
            
            if let selection = self.tableView.indexPathsForSelectedRows
            {
                for indexPath in selection {
                    let classroom = self.classrooms[indexPath.row]
                    APIConnector().attemptRemoveClassroom(callingDelegate: self, classroomID: classroom[1] as! Int)
                }
            }
        }))
        
        present(deleteClassroomsAlert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.isEditing == false {
            if indexPath.row < classrooms.count {
                APIConnector().requestClassroomData(callingDelegate: self, classroomID: String(classrooms[indexPath.row][1] as! Int))
                self.detailViewController?.setClassroomIDAndName(id: classrooms[indexPath.row][1] as! Int, name: classrooms[indexPath.row][0] as! String)
                //self.detailViewController?.setTitle(className: classrooms[indexPath.row][0] as! String)
            } else {
                self.insertNewObject()
            }
        } else if indexPath.row == classrooms.count {
            self.insertNewObject()
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.classrooms.count + (self.isEditing ? 1 : 0)
        return self.classrooms.count + 1
    }

    // Called to get cell contents for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // If editing, make the last cell an Add Classroom button
        if (indexPath.row < classrooms.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
            let classroom = self.classrooms[indexPath.row][0]
            cell.textLabel?.text = classroom as? String
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryView = nil
            return cell
            //cell.accessoryType = UITableViewCellAccessoryNone
        } else if (indexPath.row >= classrooms.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addClassroomCell", for: indexPath) as! AddClassroomTableViewCell
            //cell.textLabel?.text = "Add Classroom"
            cell.addLabel.textColor = UIColor(red:0.14, green:0.85, blue:0.16, alpha:1.0)
            //let button = UIButton(type: UIButtonType.contactAdd)
            cell.addButton.tintColor = UIColor(red:0.14, green:0.85, blue:0.16, alpha:1.0)
            cell.addButton.addTarget(self, action: #selector(insertNewObject), for: .touchUpInside)
            //cell.accessoryView = button
           // cell.selectionStyle = UITableViewCellSelectionStyleNone
            return cell
        }
        else{
            // otherwise get classroom name from classrooms array
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
            //let classroom = self.classrooms[indexPath.row][0]
            cell.textLabel?.text = "ERROR"
            return cell
        }
        //return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row >= classrooms.count) {
            return false
        }
        return true
    }

}

