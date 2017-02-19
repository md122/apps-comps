//
//  APIConnector.swift
//  AppsComps
//
//  Created by Sam Neubauer on 10/31/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import Alamofire

class APIConnector: NSObject  {
    
    let baseURL = "http://cmc307-05.mathcs.carleton.edu:5000/"
    
    // PROBLEM SCREEN
    func requestNextProblem(callingDelegate: APIDataDelegate, studentID: String, level: Int) {
        let url = baseURL + "attemptGetNextProblem/" + studentID + "/" + String(level)
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleNextProblem!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }

    }
    
    
    func attemptSkipProblem(callingDelegate: APIDataDelegate, studentID: String, level: Int, problemNum: Int) {
        let url = baseURL + "attemptSkipProblem/" + studentID + "/" + String(level) + "/" + String(problemNum)
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleSkipProblemAttempt!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    
    
    
    func attemptSubmitAnswer(callingDelegate: APIDataDelegate, studentID: String, studentAnswer: String, level: Int, problemNum: Int) {
        let url = baseURL + "attemptSubmitAnswer/" + studentID + "/" + studentAnswer + "/" + String(level) + "/" + String(problemNum)
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleSubmitAnswer!(data: responseData as! [NSDictionary])
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    // STUDENT ACCOUNT
    func requestStudentDashInfo(callingDelegate: APIDataDelegate, studentID: String) {
        let url = baseURL + "requestStudentDashInfo/" + studentID
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleStudentDashInfoRequest!(data: responseData as! [NSDictionary])
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    
    
    func attemptAddStudentToClassroom(callingDelegate: APIDataDelegate, studentID: String, classroomID: String) {
        let url = baseURL + "attemptAddStudentToClassroom/" + studentID + "/" + classroomID
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleAddStudentToClassAttempt!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    func attemptRemoveStudentFromClassroom(callingDelegate: APIDataDelegate, studentID: String, classroomID: String) {
        let url = baseURL + "attemptRemoveStudentFromClassroom/" + studentID + "/" + classroomID
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleRemoveClassroomAttempt!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    func requestProblemHistory(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: NSDictionary = ["error": "none", "data": ["Dash Data"]]
        callingDelegate.handleProblemHistory?(data: dummyData)
    }
    
    func requestCorrectIncorrectRatio(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: NSDictionary = ["error": "none", "data": ["Dash Data"]]
        callingDelegate.handleCorrectIncorrectRatio?(data: dummyData)
    }
    
    // TEACHER ACOUNT
    
    func requestTeacherDashInfo(callingDelegate: APIDataDelegate, teacherID: String) {
        let url = baseURL + "requestTeacherDashInfo/" + teacherID
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleTeacherDashInfoRequest!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    func requestClassroomData(callingDelegate: APIDataDelegate, classroomID: String) {
        let url = baseURL + "requestClassroomData/" + classroomID
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleClassroomDataRequest!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    // Attempts to add class room, returns null if not able, otherwise returns ID
    func attemptAddClassroom(callingDelegate: APIDataDelegate, teacherID: String, classroomName: String) {
        let url = baseURL + "attemptAddClassroom/" + teacherID + "/" + classroomName
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleAddClassroomAttempt!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    // API call to attempt to remove a classroom
    func attemptRemoveClassroom(callingDelegate: APIDataDelegate, classroomID: String) {
        let url = baseURL + "attemptRemoveClassroom/" + classroomID
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleRemoveClassroomAttempt!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    

    // Have to figure out how to return and properly handle returned value
    func attemptLogin(callingDelegate: APIDataDelegate, idToken: String) {
        
        let url = baseURL + "attemptLogin/" + idToken
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleLoginAttempt!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    // possibly change as the return doesn't get used
    func attemptCreateAccount(callingDelegate: APIDataDelegate, idToken: String, accountType: String) {
        let url = baseURL + "attemptCreateUser/" + idToken + "/" + accountType
        Alamofire.request(url).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200...299:
                    if let responseData = response.result.value{
                        callingDelegate.handleCreateAccountAttempt!(data: responseData as! NSDictionary)
                    }
                default:
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    
    func testRequest(callingDelegate: APIDataDelegate) {
        
        // This is some test code for getting a JSON response from server
        Alamofire.request("http://cmc307-05.mathcs.carleton.edu:5000/").responseJSON { response in
            if let JSON = response.result.value {
                print("________________________________")
                print("Got some JSON")
                print("JSON: \(JSON)")
            }
        }
    }
}
