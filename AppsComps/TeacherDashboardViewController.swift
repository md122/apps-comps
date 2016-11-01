//
//  TeacherDashboardViewController.swift
//  AppsComps
//
//  Created by appscomps on 11/1/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class TeacherDashboardViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let frame = CGRect(x:50, y: 50, width: 50, height: 50)
        let blueSquare = UIView(frame: frame)
        blueSquare.backgroundColor = UIColor.blue
        view.addSubview(blueSquare)
        //view.addSubview(graySquare)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
