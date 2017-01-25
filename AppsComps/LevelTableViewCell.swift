//
//  LevelTableViewCell.swift
//  AppsComps
//
//  Created by Brynna Mering on 1/23/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {

    @IBOutlet var problemsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
