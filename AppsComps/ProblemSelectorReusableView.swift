//
//  ProblemSelectorReusableView.swift
//  AppsComps
//
//  Created by appscomps on 2/19/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ProblemSelectorReusableView: UICollectionReusableView {
    @IBOutlet weak var classroomText: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
