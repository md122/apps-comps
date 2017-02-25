//
//  ProgressSplitViewController.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/16/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ProgressSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Student Progress"
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "FromTeacherToProblemSelector") {
            self.navigationController?.setToolbarHidden(true, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
}
