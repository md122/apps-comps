//
//  Account.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class Account {
    
    static let sharedInstance = Account()
    private init() { }
    var idToken: String?
    var name: String?
    
}


