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
    var detailViewController: StudentCollectionViewController? = nil
    var classrooms = [String]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? StudentCollectionViewController
        }
        tableView.allowsMultipleSelectionDuringEditing = true
        loadSampleClassrooms(classroomList: ["Onion", "Vinegar", "Nettles", "Nyan Cat"])
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing == false{
            //tableView.setEditing(!tableView.isEditing, animated: true)
            self.isEditing = true
            sender.title = "Done"
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteClassroomList(_:)))
            self.navigationItem.rightBarButtonItem = trashButton
            let indexPath = IndexPath(row: self.classrooms.count, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            //tableView.setEditing(!tableView.isEditing, animated: true)
            self.isEditing = false
            sender.title = "Edit"
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
            self.navigationItem.rightBarButtonItem = addButton
            let indexPath = IndexPath(row: self.classrooms.count, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
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
    
    func deleteClassroomList(_ sender: UIBarButtonItem) {
        if var selection = tableView.indexPathsForSelectedRows
        {
            selection.sort(by: {$0.row > $1.row})
            if selection.count > 0
            {
                for indexPath in selection
                {
                    classrooms.remove(at: indexPath.row)
                    //tableView.deleteRows(at: [indexPath], with: .fade)
                }
                tableView.deleteRows(at: selection, with: .automatic)
                //tableView.deleteRows(at: selection, with: .automatic)
            }
        }
        
        // Old code that after deleting moves out of 
        /*
        self.isEditing = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.leftBarButton.title = "Edit"
        */
        
    }


    // MARK: - Segues

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let classroom = classrooms[indexPath.row]
//                let controller = (segue.destination as! UINavigationController).topViewController as! StudentCollectionViewController
//                //controller.detailItem = classroom
//                //controller.detailItem = "Hi!"
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classrooms.count + (self.isEditing ? 1 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        if(indexPath.row >= classrooms.count && self.isEditing){
            cell.textLabel?.text = "Add Classroom";
            let button = UIButton(type: UIButtonType.contactAdd)
            button.addTarget(self, action: #selector(insertNewObject), for: .touchUpInside)
            cell.accessoryView = button;
        }else{
            let classroom = self.classrooms[indexPath.row]
            cell.textLabel?.text = classroom
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row >= classrooms.count) {
            return false
        }
        return true
    }
 
    

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
//        //cell.editingAccessoryType = UITableViewCellAccessoryType.checkmark
//        if editingStyle == .delete {
//            classrooms.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            
//        }
//    }
    func loadSampleClassrooms(classroomList: [String]) {
        
        classrooms = classroomList
    }

}

