//
//  HelpViewController.swift
//  AppsComps
//
//  Created by appscomps on 2/16/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIToolbarDelegate {
    @IBOutlet weak var buttonsLabel: UILabel!
    @IBOutlet weak var vortexLabel: UILabel!

    //Tutorial from https://www.youtube.com/watch?v=FgCIRMz_3dE

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonsLabel.text = "The blue buttons are unlocked, and the grey buttons are locked. Answer 3 problems in a row to unlock the next level! If you get one wrong you'll need to start over on that level, so do your best in each question."
        vortexLabel.text = "Drop the vortex onto a bar with a -1 or -x to do subtraction!"
        
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        //Show toolbar again
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
            }, completion: {(finished: Bool) in
                if (finished) {self.view.removeFromSuperview()}
    
        })
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
