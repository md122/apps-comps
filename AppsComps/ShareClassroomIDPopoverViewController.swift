//
//  ShareClassroomIDPopoverViewController.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/22/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ShareClassroomIDPopoverViewController: UIViewController {

   // @IBOutlet var classroomNameLabel: UILabel!
  
   // @IBOutlet var classroomIDLabel: UILabel!
    @IBOutlet weak var classroomNameLabel: UILabel!
    
    @IBOutlet weak var classroomIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setClassroomNameLabel(name: String?){
        if name != nil {
            classroomNameLabel?.text = name!
        } else {
            classroomNameLabel?.text = "EMPTY"
        }
        
    }
    
    func setClassroomIDLabel(id: String?){
        if id != nil {
            classroomIDLabel?.text = id!
        } else {
            classroomIDLabel?.text = "EMPTY"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
