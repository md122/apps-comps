
//
//  ClassroomTableMasterViewController.swift
//  AppsComps
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit

class ClassroomTableMasterViewController: UITableViewController, APIDataDelegate {
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    var detailViewController: StudentCollectionViewController? = nil
    var classrooms = [NSArray]()
    var lastIndexPath = IndexPath()
    
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
            trashButton.tintColor = .red
            self.navigationItem.leftBarButtonItem = trashButton
        } else {
            self.isEditing = false
            sender.title = "Edit"
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
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
                self.autoSelectClassroom(indexPath: IndexPath(row: 0, section: 0))
                self.detailViewController?.hasClassrooms = true
            } else {
                self.detailViewController?.hasClassrooms = false
                self.detailViewController?.title = "(No Classes)"
            }
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        } else {
            let errorAlert = UIAlertController(title: "Something went wrong...", message: "Sorry for the inconvenience, please try again later.", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func handleAddClassroomAttempt(data: NSDictionary) {
        if data["error"] as! String == "none" {
            print(data["data"])
            let classroomData = data["data"] as! [NSArray]
            self.classrooms.insert([classroomData[0][0], classroomData[0][1]], at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.autoSelectClassroom(indexPath: indexPath)
            self.detailViewController?.hasClassrooms = true
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        } else {
            let errorAlert = UIAlertController(title: "Something went wrong...", message: "Sorry for the inconvenience, please try again later.", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in}))
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
    // Called after attempting to remove a classroom
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
            if self.isEditing == true {
                self.isEditing = false
                self.editButton.title = "Edit"
                self.navigationItem.leftBarButtonItem = nil
            }
            if self.classrooms.count > 0 {
                self.autoSelectClassroom(indexPath: IndexPath(row: 0, section: 0))
            } else {
                self.detailViewController?.hasClassrooms = false
                self.detailViewController?.title = "(No Classes)"
                let emptyArray = [NSArray]()
                self.detailViewController?.loadStudentList(studentsInClassroom: emptyArray)
            }
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        } else {
            let errorAlert = UIAlertController(title: "Something went wrong...", message: "Sorry for the inconvenience, please try again later.", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(errorAlert, animated: true, completion: nil)
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
        let createClassroomAlert = UIAlertController(title: "New Class", message: "Enter class name:", preferredStyle: UIAlertControllerStyle.alert)
        
        // Text field to enter Classroom name
        createClassroomAlert.addTextField(configurationHandler: nil)
        
        // cancel option
        createClassroomAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
            if self.classrooms.count > 0{
                self.autoSelectClassroom(indexPath: self.lastIndexPath)
            }
            self.tableView.deselectRow(at: IndexPath(row: self.classrooms.count, section: 0), animated: true)
        }))
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
        if let selection = self.tableView.indexPathsForSelectedRows {
            let deleteClassroomsAlert = UIAlertController(title: "Delete Classes", message: "Are you sure you want to delete the selected classes?", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteClassroomsAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in}))
            
            deleteClassroomsAlert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: { (action: UIAlertAction!) in

            for indexPath in selection {
                let classroom = self.classrooms[indexPath.row]
                APIConnector().attemptRemoveClassroom(callingDelegate: self, classroomID: classroom[1] as! Int)
            }
        }))
            present(deleteClassroomsAlert, animated: true, completion: nil)
            
        } else {
            let noSelectedClassroomsAlert = UIAlertController(title: "No Classes Selected", message: "You must select classes to delete them", preferredStyle: UIAlertControllerStyle.alert)
            
            noSelectedClassroomsAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in}))
            present(noSelectedClassroomsAlert, animated: true, completion: nil)
        }
    }
    
    func autoSelectClassroom(indexPath: IndexPath){
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        self.setUpSelectedClassroom(indexPath: indexPath)
    }
    
    func setUpSelectedClassroom(indexPath: IndexPath){
        lastIndexPath = indexPath
        APIConnector().requestClassroomData(callingDelegate: self, classroomID: String(classrooms[indexPath.row][1] as! Int))
        self.detailViewController?.navigationItem.title = classrooms[indexPath.row][0] as! String
        self.detailViewController?.setClassroomIDAndName(id: classrooms[indexPath.row][1] as! Int, name: classrooms[indexPath.row][0] as! String)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row < classrooms.count {
            if self.isEditing == true {
                tableView.cellForRow(at: indexPath)!.tintColor = UIColor.red
            }
            self.setUpSelectedClassroom(indexPath: indexPath)
        } else {
            self.insertNewObject()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classrooms.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < classrooms.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
            let classroom = self.classrooms[indexPath.row][0]
            cell.textLabel?.text = classroom as? String
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryView = nil
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addClassroomCell", for: indexPath) as! AddClassroomTableViewCell
            cell.addButton.addTarget(self, action: #selector(insertNewObject), for: .touchUpInside)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row >= classrooms.count) {
            return false
        }
        return true
    }

}

