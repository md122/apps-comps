//
//  LevelButtonCollectionCell.swift
//  AppsComps
//
//  Created by WANCHEN YAO on 2/25/17.
//  Copyright © 2017 appscomps. All rights reserved.
//
import UIKit

class LevelButtonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var levelButton: LevelButton!
    @IBOutlet weak var levelView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
}
