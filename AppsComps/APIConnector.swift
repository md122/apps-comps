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
    func requestNextProblem(callingDelegate: APIDataDelegate, studentID: String) {
        let url = baseURL + "attemptGetNextProblem/" + studentID
        Alamofire.request(url).responseData { response in
            if let responseData = response.result.value, let utf8Text = String(data: responseData, encoding: .utf8) {
                /* var result = false
                 if (utf8Text == "True") {
                 result = true
                 } */
                callingDelegate.handleNextProblem?(data: utf8Text)
            }
        }
    }
    
    /*func attemptAddProblemData(callingDelegate: APIDataDelegate, start_time: String, end_time: String, answer: String, wasCorrect: Bool) {
        let dummyData = false
        callingDelegate.handleAddProblemDataAttempt?(data: dummyData)
    }*/
    
    func attemptSubmitAnswer(callingDelegate: APIDataDelegate, studentID: String, studentAnswer: String) {
        let url = baseURL + "attemptSubmitAnswer/" + studentID + "/" + studentAnswer
        Alamofire.request(url).responseData { response in
            if let responseData = response.result.value, let utf8Text = String(data: responseData, encoding: .utf8) {
                /* var result = false
                 if (utf8Text == "True") {
                 result = true
                 } */
                callingDelegate.handleSubmitAnswer?(data: utf8Text)
            }
        }
        
    }
    
    // STUDENT ACCOUNT
    func requestStudentDashInfo(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleStudentDashInfo?(data: dummyData)
    }
    
    
    
    func attemptAddStudentToClassroom(callingDelegate: APIDataDelegate, studentID: String, classroomID: String) {
        let url = baseURL + "attemptAddStudentToClassroom/" + studentID + "/" + classroomID
        Alamofire.request(url).responseData { response in
            if let responseData = response.result.value, let utf8Text = String(data: responseData, encoding: .utf8) {
                var result = false
                if (utf8Text == "True") {
                    result = true
                } else if (utf8Text == "ERROR: student id or classroom id invalid") {
                    print("Need to figure out how to handle this")
                } else if (utf8Text == "ERROR: Student already in classroom") {
                    print("Need to figure out how to handle this")
                }
                callingDelegate.handleAddStudentToClassAttempt?(data: result)
            }
        }
    }
    
    func attemptRemoveStudentFromClassroom(callingDelegate: APIDataDelegate, studentID: String, classroomID: String) {
        let url = baseURL + "attemptRemoveStudentFromClassroom/" + studentID + "/" + classroomID
        Alamofire.request(url).responseData { response in
            if let responseData = response.result.value, let utf8Text = String(data: responseData, encoding: .utf8) {
                var result = false
                if (utf8Text == "True") {
                    result = true
                }
                callingDelegate.handleRemoveStudentFromClassAttempt?(data: result)
            }
        }
    }
    
    func requestProblemHistory(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleProblemHistory?(data: dummyData)
    }
    
    func requestCorrectIncorrectRatio(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleCorrectIncorrectRatio?(data: dummyData)
    }
    
    // TEACHER ACOUNT
    
    func requestTeacherDashInfo(callingDelegate: APIDataDelegate, teacherID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleTeacherDashInfo?(data: dummyData)
    }
    
    // Attempts to add class room, returns null if not able, otherwise returns ID
    func attemptAddClassroom(callingDelegate: APIDataDelegate, teacherID: String, classroomName: String) {
        let url = baseURL + "attemptAddClassroom/" + teacherID + "/" + classroomName
        Alamofire.request(url).responseData { response in
            if let responseData = response.result.value, let utf8Text = String(data: responseData, encoding: .utf8) {
                var result = false
                if (utf8Text == "True") {
                    result = true
                }
                if (utf8Text == "ERROR: Account id invalid") {
                    print("Need to figure out how to handle this")
                }
                callingDelegate.handleAddClassroomAttempt?(data: result)
            }
        }
    }
    
    // API call to attempt to remove a classroom
    func attemptRemoveClassroom(callingDelegate: APIDataDelegate, classroomID: String) {
        let url = baseURL + "attemptRemoveClassroom/" + classroomID
        Alamofire.request(url).responseData { response in
            if let responseData = response.result.value, let utf8Text = String(data: responseData, encoding: .utf8) {
                var result = false
                if (utf8Text == "True") {
                    result = true
                }
                if (utf8Text == "ERROR: Account id invalid") {
                    print("Need to figure out how to handle this")
                }
                callingDelegate.handleRemoveClassroomAttempt?(data: result)
            }
        }
    }
    

    // Have to figure out how to return and properly handle returned value
    func attemptLogin(callingDelegate: APIDataDelegate, idToken: String) {
        
        let url = baseURL + "attemptLogin/" + idToken
        Alamofire.request(url).responseData { response in
            if let responseData = response.result.value, let utf8Text = String(data: responseData, encoding: .utf8) {
                /* var result = false
                if (utf8Text == "True") {
                    result = true
                } */
                callingDelegate.handleLoginAttempt?(data: utf8Text)
            }
        }
    }
    
    // possibly change as the return doesn't get used
    func attemptCreateAccount(callingDelegate: APIDataDelegate, idToken: String, accountType: String) {
        let url = baseURL + "attemptCreateUser/" + idToken + "/" + accountType
        Alamofire.request(url).responseJSON { response in
            if let responseData = response.result.value{
                /*
                var result = false
                if (utf8Text == "True") {
                    result = true
                }
                if (utf8Text == "ERROR: Account already exists") {
                    print("Need to figure out how to handle this")
                }
                */
                callingDelegate.handleCreateAccountAttempt?(data: responseData as! [NSArray])
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
                
                callingDelegate.handleStudentData?(data: JSON as! [NSArray])
            }
            
        }
    }
    
    
}
