//
//  Account.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class Account {
    var idToken: String
    var name: String
    
    init?(idToken: String, name: String){
        self.idToken = idToken
        self.name = name
        if idToken.isEmpty || name.isEmpty {
            return nil
        }
    }
    
    func getIdToken()->String {
        return idToken
    }
    
    func getName()->String{
        return name
    }

    
}


