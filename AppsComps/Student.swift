//
//  Student.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//


import UIKit

class Student: Account, APIDataDelegate {
    
    
    override init?(idToken: String, name: String){
        super.init(idToken: idToken, name: name)
        if idToken.isEmpty || name.isEmpty {
            return nil
        }
    }
 
 
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
    
    
    // this is an example of how to use the APIConnector
    func testAPIConnector() {
        let connector = APIConnector()
        connector.requestStudentDashInfo(callingDelegate: self, studentID: "Student1")
        connector.attemptAddStudentToClassroom(callingDelegate: self, studentID: "Student1", classroomID: "5")
        connector.attemptRemoveStudentFromClassroom(callingDelegate: self, studentID: "Student1", classroomID: "5")
        connector.requestProblemHistory(callingDelegate: self, studentID: "Student1")
        connector.requestCorrectIncorrectRatio(callingDelegate: self, studentID: "Student1")
    }
    
    // Function that gets called when studentDashInfo gets back
    func handleStudentDashInfo(data: [NSArray]) {
        print("Incoming handleStudentDashInfo data")
        print(data)
    }
    
    // Function that gets called when attempt to remove student from class gets back
    func handleAddStudentToClassAttempt(data: Bool) {
        print("Incoming handleAddStudentToClassAttempt data")
        print(data)
    }
    
    // Function that gets called when attempt to remove student from class gets back
    func handleRemoveStudentFromClassAttempt(data: Bool) {
        print("Incoming handleRemoveStudentFromClassAttempt data")
        print(data)
    }
    
    // Function that gets called when problem history gets back
    func handleProblemHistory(data: [NSArray]) {
        print("Incoming handleProblemHistory data")
        print(data)
    }
    
    // Function that gets called when correct/incorrect ratio gets back
    func handleCorrectIncorrectRatio(data: [NSArray]) {
        print("Incoming handleCorrectIncorrectRatio data")
        print(data)
    }
    
}
