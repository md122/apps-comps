//
//  APIDataDelegate.swift
//  AppsComps
//
//  Created by Sam Neubauer on 11/12/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import Foundation

@objc protocol APIDataDelegate {
    // test function
    @objc optional func handleStudentData(data: [NSArray]) ;
    
    // For the problem screen
    @objc optional func handleNextProblem(data: [NSArray]) ;
    @objc optional func handleAddProblemDataAttempt(data: Bool) ;
    
    // Methods for student class
    @objc optional func handleStudentDashInfo(data: [NSArray]) ;
    @objc optional func handleAddStudentToClassAttempt(data: Bool) ;
    @objc optional func handleRemoveStudentFromClassAttempt(data: Bool) ;
    @objc optional func handleProblemHistory(data: [NSArray]) ;
    @objc optional func handleCorrectIncorrectRatio(data: [NSArray]) ;
    
    // Methods for teacher class
    @objc optional func handleTeacherDashInfo(data: [NSArray]) ;
    @objc optional func handleAddClassroomAttempt(data: Bool) ;
    @objc optional func handleRemoveClassroomAttempt(data: Bool) ;
    
    // Methods for login screen
    @objc optional func handleLoginAttempt(data: String) ;
    @objc optional func handleCreateAccountAttempt(data: [NSArray]) ;
    
    

    
}
