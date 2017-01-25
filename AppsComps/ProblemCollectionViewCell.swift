//
//  ProblemCollectionViewCell.swift
//  AppsComps
//
//  Created by Brynna Mering on 1/23/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ProblemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var goToProblemButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
