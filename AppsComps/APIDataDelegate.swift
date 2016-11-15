//
//  APIDataDelegate.swift
//  AppsComps
//
//  Created by Sam Neubauer on 11/12/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import Foundation

@objc protocol APIDataDelegate {
    // protocol definition goes here
    @objc optional func handleStudentData(data: [NSArray]) ;
    
    

    
}
