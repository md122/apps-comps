//
//  ClassroomTableViewCell.swift
//  TeacherDashSingleView
//
//  Created by Brynna Mering on 11/7/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class ClassroomTableViewCell: UITableViewCell {
    //MARK: Properties

    @IBOutlet weak var classroomNameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
