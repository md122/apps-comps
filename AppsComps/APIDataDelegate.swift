//
//  APIDataDelegate.swift
//  AppsComps
//
//  Created by Sam Neubauer on 11/12/16.
//  Copyright © 2016 appscomps. All rights reserved.
//
// Errors will be returned to the handlers in different formats based off


import Foundation

@objc protocol APIDataDelegate {
    // test function
    @objc optional func handleStudentData(data: [NSArray]) ;
    
    // For the problem screen
    @objc optional func handleNextProblem(data: NSDictionary) ;
    @objc optional func handleSubmitAnswer(data: NSDictionary) ;
    //@objc optional func handleAddProblemDataAttempt(data: Bool) ;
    
    // Methods for student class
    @objc optional func handleStudentDashInfo(data: NSDictionary) ;
    @objc optional func handleAddStudentToClassAttempt(data: NSDictionary) ;
    @objc optional func handleRemoveStudentFromClassAttempt(data: NSDictionary) ;
    @objc optional func handleProblemHistory(data: NSDictionary) ;
    @objc optional func handleCorrectIncorrectRatio(data: NSDictionary) ;
    
    // Methods for teacher class
    @objc optional func handleTeacherDashInfoRequest(data: NSDictionary) ;
    @objc optional func handleClassroomDataRequest(data: NSDictionary) ;
    @objc optional func handleAddClassroomAttempt(data: NSDictionary) ;
    @objc optional func handleRemoveClassroomAttempt(data: NSDictionary) ;
    
    // Methods for login screen
    @objc optional func handleLoginAttempt(data: NSDictionary) ;
    @objc optional func handleCreateAccountAttempt(data: NSDictionary) ;
}
