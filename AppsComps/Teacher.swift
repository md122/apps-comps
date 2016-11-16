//
//  Teacher.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit

class Teacher: Account {
    var classRoomIDs = [String]()
    
    //will call DB and fill classRooms with class ids
    /*
     createClassroom
     getClassrooms
     Delete a classroom
     */
    func createClassroom(classroomName: String){
        //Generate some pattern for a new classroomID: maybe lowercase of classroomName plus some number
        //tell the db connector to add a new classroom to the db with classroomID, classroomName, and self.IDToken
        
        setClassrooms()
    }
    
    func setClassrooms(){
        //Will be a DB thing where we get list of all classroom ids under teacher id
        classRoomIDs = ["1","2","3"]
    }
    
    
    func getClassrooms()->[String] {
        return classRoomIDs
    }
    
    func deleteClassroom(classID: String){
        //Find class ID in DB and delete them
        setClassrooms()
    }
    
    
    
}