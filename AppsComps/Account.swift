//
//  Account.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
// A super class of teacher and student, to hold account information

import UIKit

class Account {
    
    //static let sharedInstance = Account()
    //private init() { }
    var idToken: String
    var name: String
    //var type: String?
    
    init?(idToken: String, name: String){
        self.idToken = idToken
        self.name = name
        if idToken.isEmpty || name.isEmpty {
            return nil
        }
    }
    
    // Implemented by student and teacher subclass
    func getType()->String {
        return "account"
    }
    
    func getIdToken()->String {
        return idToken
    }
    
    func getName()->String{
        return name
    }

    
}


