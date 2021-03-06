//
//  Account.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
// A super class of teacher and student, to hold account information
// THIS SHOULD BE MADE SO THAT YOU CAN'T INSTANTIATE IT

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
    
    func getHighestLevel() ->Int {
        return 4
    }

    func getClassRoomID() -> Int {
        return 0
    }

}


