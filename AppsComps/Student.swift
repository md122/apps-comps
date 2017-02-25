//
//  Student.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//


import UIKit

class Student: Account, APIDataDelegate {
    var classroomID: Int = 0
    
    override init?(idToken: String, name: String){
        super.init(idToken: idToken, name: name)
        
        if idToken.isEmpty || name.isEmpty {
            return nil
        }
    }
    
    override func getType()->String{
        return "student"
    }
 

    override func getClassRoomID()->Int{
        return classroomID
    }
    
    func setClassRoomID(id: Int) {
        classroomID = id
    }
}
