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
    
    // this is an example of how to use the APIConnector
    func testAPIConnector() {
        let connector = APIConnector()
        connector.requestTeacherDashInfo(callingDelegate: self, teacherID: "Teacher1")
        connector.attemptAddClassroom(callingDelegate: self, teacherID: "Teacher1", classroomName: "Cats Room")
        connector.attemptRemoveClassroom(callingDelegate: self, classroomID: "Classroom1")
    }
    
    // Function that gets called when teacher Dash Info gets back
    func handleTeacherDashInfo(data: [NSArray]) {
        print(data)
    }
    
    // Function that gets called when attempt to add classroom gets back
    func handleAddClassroomAttempt(data: Bool) {
        print(data)
    }
    
    // Function that gets called when attempt to remove classroom gets back
    func handleRemoveClassroomAttempt(data: Bool) {
        print(data)
    }
    
    
    
    
    
}
