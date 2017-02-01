//
//  MasterViewController.swift
//  MasterDetailTest
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit

class ClassroomTableMasterViewController: UITableViewController {

    @IBOutlet var rightBarButton: UIBarButtonItem!
    @IBOutlet var leftBarButton: UIBarButtonItem!
    @IBOutlet var classroomTableView: UITableView!
    var detailViewController: StudentCollectionViewController? = nil
    var classrooms = [String]()
    
    var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enterEditMode(_:)))
   // var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditMode(_:)))
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.leftBarButton = editButton
        //self.rightBarButton = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? StudentCollectionViewController
        }
        classroomTableView.allowsMultipleSelectionDuringEditing = true
        loadSampleClassrooms(classroomList: ["Onion", "Vinegar", "Nettles", "Nyan Cat"])
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing == false{
            tableView.setEditing(!tableView.isEditing, animated: true)
            sender.title = "Done"
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteClassroomList(_:)))
            self.navigationItem.rightBarButtonItem = trashButton
        } else {
            //tableView.setEditing(!tableView.isEditing, animated: true)
            self.isEditing = false
            sender.title = "Edit"
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
            self.navigationItem.rightBarButtonItem = addButton
        
        }
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func insertNewObject(_ sender: Any) {
        let createClassroomAlert = UIAlertController(title: "New Classroom", message: "Enter classroom name:", preferredStyle: UIAlertControllerStyle.alert)
        
        // Text field to enter Classroom name
        createClassroomAlert.addTextField(configurationHandler: nil)
        
        // cancel option
        createClassroomAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in}))
        // adds new classroom to table
        createClassroomAlert.addAction(UIAlertAction(title: "Enter", style: .cancel, handler: { (action: UIAlertAction!) in
            let classroom = createClassroomAlert.textFields![0].text!
            self.classrooms.insert(classroom, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }))
        
        present(createClassroomAlert, animated: true, completion: nil)
    }
    
    func enterEditMode(_ sender: UIBarButtonItem) {
        self.isEditing = true
        //self.rightBarButton = trashButton
        self.leftBarButton = doneButton
        
    }
    
    func endEditMode(_ sender: Any) {
        self.isEditing = false
        self.navigationItem.rightBarButtonItem = editButton
        //self.navigationItem.leftBarButtonItem = addButton
        
    }
    
    func deleteClassroomList(_ sender: UIBarButtonItem) {
        
        
        if var selection = tableView.indexPathsForSelectedRows
        {
            if selection.count > 0
            {
               
                for indexPath in selection
                {
                    //contents.removeAtIndex(indexPath.row)
                    classrooms.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
                tableView.deleteRows(at: selection, with: .automatic)
                
            }
        }
        self.isEditing = false
        
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let classroom = classrooms[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! StudentCollectionViewController
                //controller.detailItem = classroom
                //controller.detailItem = "Hi!"
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classrooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        let classroom = self.classrooms[indexPath.row]
        cell.textLabel?.text = classroom
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        //cell.editingAccessoryType = UITableViewCellAccessoryType.checkmark
        if editingStyle == .delete {
            classrooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    func loadSampleClassrooms(classroomList: [String]) {
        
        classrooms = classroomList
    }

}

