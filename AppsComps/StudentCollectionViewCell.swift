//
//  StudentCollectionViewCell.swift
//  MasterDetailTest
//
//  Created by Brynna Mering on 1/18/17.
//  Copyright © 2017 Brynna Mering. All rights reserved.
//

import UIKit

class StudentCollectionViewCell: UICollectionViewCell {
    @IBOutlet var studentNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
