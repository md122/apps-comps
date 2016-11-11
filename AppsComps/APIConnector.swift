//
//  APIConnector.swift
//  AppsComps
//
//  Created by Sam Neubauer on 10/31/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import Alamofire

class APIConnector: NSObject  {
    
    

    
    func testRequest() {
        
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
