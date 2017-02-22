//
//  MasterViewController.swift
//  MasterDetailTest
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit

class ClassroomTableMasterViewController: UITableViewController, APIDataDelegate {

    @IBOutlet var collapseButton: UIBarButtonItem!
    @IBOutlet var rightBarButton: UIBarButtonItem!
    @IBOutlet var leftBarButton: UIBarButtonItem!
    var detailViewController: StudentCollectionViewController? = nil
    var classrooms = [NSArray]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? StudentCollectionViewController
        }
        tableView.allowsMultipleSelectionDuringEditing = true
        
        APIConnector().requestTeacherDashInfo(callingDelegate: self, teacherID: currentUser!.getIdToken())

        
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if tableView.isEditing == false{
            self.isEditing = true
            sender.title = "Done"
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteClassroomList(_:)))
            self.navigationItem.leftBarButtonItem = trashButton
            let indexPath = IndexPath(row: self.classrooms.count, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            self.isEditing = false
            sender.title = "Edit"
            self.navigationItem.leftBarButtonItem = collapseButton
            let indexPath = IndexPath(row: self.classrooms.count, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    @IBAction func collapseClicked(_ sender: AnyObject) {
        //splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryHidden
        detailViewController?.hideTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleTeacherDashInfoRequest(data: NSDictionary) {
        if data["error"] as! String == "none" {
            classrooms = data["data"] as! [NSArray]
            self.tableView.reloadData()
            if classrooms.count > 0 {
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
            detailViewController?.loadData(studentsData: data["data"] as! [NSArray])
        } else if data["error"] as! String == "HTTP" {
            APIConnector().connectionDropped(callingDelegate: self)
        }
    }

    func insertNewObject(_ sender: Any) {
        let createClassroomAlert = UIAlertController(title: "New Classroom", message: "Enter classroom name:", preferredStyle: UIAlertControllerStyle.alert)
        
        // Text field to enter Classroom name
        createClassroomAlert.addTextField(configurationHandler: nil)
        
        // cancel option
        createClassroomAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in}))
        // adds new classroom to table
        createClassroomAlert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: { (action: UIAlertAction!) in
            
            let classroomName = createClassroomAlert.textFields![0].text!
            APIConnector().attemptAddClassroom(callingDelegate: self, teacherID: currentUser!.getIdToken(), classroomName: classroomName)
        }))
        
        present(createClassroomAlert, animated: true, completion: nil)
    }
    
    func deleteClassroomList(_ sender: UIBarButtonItem) {
        if let selection = tableView.indexPathsForSelectedRows
        {
            for indexPath in selection {
                let classroom = classrooms[indexPath.row]
                APIConnector().attemptRemoveClassroom(callingDelegate: self, classroomID: classroom[1] as! Int)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.isEditing == false {
            APIConnector().requestClassroomData(callingDelegate: self, classroomID: String(classrooms[indexPath.row][1] as! Int))
            self.detailViewController?.setTitle(className: classrooms[indexPath.row][0] as! String)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classrooms.count + (self.isEditing ? 1 : 0)
    }

    // Called to get cell contents for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        // If editing, make the last cell an Add Classroom button
        if(indexPath.row >= classrooms.count && self.isEditing){
            cell.textLabel?.text = "Add Classroom";
            let button = UIButton(type: UIButtonType.contactAdd)
            button.addTarget(self, action: #selector(insertNewObject), for: .touchUpInside)
            cell.accessoryView = button;
        } else{
            // otherwise get classroom name from classrooms array
            let classroom = self.classrooms[indexPath.row][0]
            cell.textLabel?.text = classroom as? String
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row >= classrooms.count) {
            return false
        }
        return true
    }

}

