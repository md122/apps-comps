//
//  SectionHeaderCollectionReusableView.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/10/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet var headerLabel1: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
