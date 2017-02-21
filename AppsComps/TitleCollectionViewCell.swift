//
//  TitleCollectionViewCell.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/10/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var classroomNameLabel: UILabel!
    @IBOutlet var classroomCodeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
