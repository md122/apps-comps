//
//  Student.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//


import UIKit

class Student: Account {
    func getClassRoomID()->String{
        //code that asks the database connector for the classroom id associated with the account id of this student
        return "Classroom 1"
    }
    
    func getHighestLevel()->String{
        //code that asks the database connector to send back the number of the highest level this student has unlocked (not the highest level passed, the highest level they are allowed to access)
        return "4"
    }
    
    func getCorrectIncorrectRatio(level: String, timeRange: String)->String{
        //code that asks the database connector to send back the ratio of correct to incorrect answers submited within the given constraints, if these constraints are null, then assume that the ratio should be returned for all
        return "6:3"
    }
    
    func isActive()->Bool{
        //asks the database connector for the timestamp of the last problem atempt, if it is within the last half hour return true
        return true
    }
    
    
}
