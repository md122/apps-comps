//
//  APIConnector.swift
//  AppsComps
//
//  Created by Sam Neubauer on 10/31/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import Alamofire

class APIConnector: NSObject  {
    
    func requestNextProblem(callingDelegate: APIDataDelegate, level: Int, studentID: String) {
        let dummyData: [NSArray] = [["Problem Data"], ["Problem Data"]]
        callingDelegate.handleNextProblem?(data: dummyData)
    }
    
    func attemptAddProblemData(callingDelegate: APIDataDelegate, start_time: String, end_time: String, answer: String, wasCorrect: Bool) {
        let dummyData = false
        callingDelegate.handleAddProblemDataAttempt?(data: dummyData)
    }
    
    func requestStudentDashInfo(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleStudentDashInfo?(data: dummyData)
    }
    
    func attemptRemoveStudentFromClass(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData = false
        callingDelegate.handleRemoveStudentFromClassAttempt?(data: dummyData)
    }
    
    func requestProblemHistory(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleProblemHistory?(data: dummyData)
    }
    
    func requestCorrectIncorrectRatio(callingDelegate: APIDataDelegate, studentID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleCorrectIncorrectRatio?(data: dummyData)
    }
    
    func requestTeacherDashInfo(callingDelegate: APIDataDelegate, teacherID: String) {
        let dummyData: [NSArray] = [["Dash Data"], ["Dash Data"]]
        callingDelegate.handleTeacherDashInfo?(data: dummyData)
    }
    
    // Attempts to add class room, returns null if not able, otherwise returns ID
    func attemptAddClassroom(callingDelegate: APIDataDelegate, teacherID: String,classroomName: String) {
        let dummyData = "FakeClassroomID"
        callingDelegate.handleAddClassroomAttempt?(data: dummyData)
    }
    
    func attemptRemoveClassroom(callingDelegate: APIDataDelegate, teacherID: String, classroomID: String) {
        let dummyData = false
        callingDelegate.handleRemoveClassroomAttempt?(data: dummyData)
    }
    
    func attemptLogin(callingDelegate: APIDataDelegate, idToken: String) {
        Alamofire.request("http://cmc307-05.mathcs.carleton.edu:5000/attemptLogin/" + idToken).responseJSON { response in
            //print(response.request)  // original URL request
            //print(response.response) // HTTP URL response
            //print(response.data)     // server data
            //print(response.result)   // result of response serialization
            if let JSON = response.result.value {
                //print("JSON: \(JSON)")
                callingDelegate.handleLoginAttempt?(data: JSON as! NSDecimalNumber)
                
                //callingDelegate.handleStudentData!(data: retrievedData)
            }
            
        }

    }
    
    // possibly change 
    func attemptCreateAccount(callingDelegate: APIDataDelegate, idToken: String, accountType: String) {
        Alamofire.request("http://cmc307-05.mathcs.carleton.edu:5000/attemptCreateUser/" + idToken + "/" + accountType).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                //callingDelegate.handleCreateAccountAttempt?(data: JSON as! [NSArray])
            }
        }
    }
    
    
    
    func testRequest(callingDelegate: APIDataDelegate) {
        
        // This is some test code for getting a JSON response from server
        Alamofire.request("http://cmc307-05.mathcs.carleton.edu:5000/").responseJSON { response in
            //print(response.request)  // original URL request
            //print(response.response) // HTTP URL response
            //print(response.data)     // server data
            //print(response.result)   // result of response serialization
            
            
            
            if let JSON = response.result.value {
                print("________________________________")
                print("Got some JSON")
                print("JSON: \(JSON)")
                
                callingDelegate.handleStudentData?(data: JSON as! [NSArray])
                
                //callingDelegate.handleStudentData!(data: retrievedData)
            }
            
        }
        
        /*
        // Puts in a request for some data
        Alamofire.request("http://cmc307-05.mathcs.carleton.edu:5000/hello").responseData { response in
            
            print("______Response Info___________")
            debugPrint("All Response Info: \(response)")
            print("_____End Response Info_________")
            
            // Creates a response handler that will fire whenever the data gets back
            // It is asynchronous, meaning it will run whenever it comes back
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("________________________________")
                print("Got some data from our API")
                print("Data: \(utf8Text)")
                print("End Data")
                print("________________________________")
            }
        }
 
        */
    }
    
    
}
