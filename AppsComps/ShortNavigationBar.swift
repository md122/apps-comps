//
//  ShortNavigationBar.swift
//  AppsComps
//
//  Created by Brynna Mering on 2/16/17.
//  Copyright © 2017 appscomps. All rights reserved.
//

import UIKit

class ShortNavigationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize :CGSize = CGSize(width: 1026, height: 30)
        return newSize
    }

}
