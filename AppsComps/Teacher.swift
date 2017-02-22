//
//  Teacher.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class Teacher: Account, APIDataDelegate {
    var classRoomIDs = [String]()
    
    //will call DB and fill classRooms with class ids
    /*
     createClassroom
     getClassrooms
     Delete a classroom
     */
    
    
    override init?(idToken: String, name: String){
        super.init(idToken: idToken, name: name)
        if idToken.isEmpty || name.isEmpty {
            return nil
        }
    }
    
    override func getType()->String{
        return "teacher"

    }
    
}
