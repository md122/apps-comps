//
//  GraphCollectionViewCell.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/18/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class GraphCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var graphBar: UIView!
    
    @IBOutlet var studentsLabel: UILabel!
    
    @IBOutlet var percentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
