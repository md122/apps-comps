//
//  DetailViewController.swift
//  getDetail
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit

class TeacherDashboardDetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    func configureView() {
                if let detail = self.detailItem {
                    if let label = self.detailDescriptionLabel {
                        label.text = detail.description
                    }
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var detailItem: String? {
        didSet {
            self.configureView()
        }
    }
    
    
}
