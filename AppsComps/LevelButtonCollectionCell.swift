//
//  LevelButtonCollectionCell.swift
//  AppsComps
//
//  Created by appscomps on 1/21/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class LevelButtonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var levelButton: LevelButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
