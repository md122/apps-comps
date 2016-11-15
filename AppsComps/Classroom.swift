//
//  Classroom.swift
//  TeacherDashSingleView
//
//  Created by appscomps on 11/6/16.
//  Copyright © 2016 appscomps. All rights reserved.
//
import UIKit

class Classroom {
    var classroomID: String
    var classroomName: String
    var teacherID: String
    var studentIDs = [String]()  //Student object
    
    init(classroomID: String) {
        
        self.classroomID = classroomID
        
        /*get className, studentIDs, teacherID from DB based on classID*/
        classroomName = "Sunflower"
        teacherID = "Dan"
        studentIDs = ["One", "Two", "Three"]
    }
    
    //Methods: getStudents, returns list of student ids
    func getStudents()->[String]{
        return studentIDs
    }
    
    func getTeacherID()->String{
        //Maybe it should be getTeacherName? will depend later on
        return teacherID
    }
    
    func getClassroomName()->String{
        return classroomName
    }
    
    func getClassroomID()->String{
        return classroomID
    }
    
    func removeStudent(studentID: String){
        //remove student from DB in classID
    }
    
    func addStudent(studentID: String){
        //if student is associated with no other classrooms, add this studentID to this classroom in the DB
    }
    
    
}
