//
//  ProblemScreenViewController.swift
//  AppsComps
//
//  Created by Zoe Peterson on 10/29/16.
//  Copyright © 2016 appscomps. All rights reserved.
//  Based on tutorial by Rico Zuñiga
//  https://www.sitepoint.com/create-tetromino-puzzle-game-using-swift-getting-started/

import UIKit
import SpriteKit




class ProblemScreenViewController: UIViewController, APIDataDelegate {
    /* Why is this so important!!??? */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        testAPIConnector()
        
        let skView = SKView(frame: self.view.frame)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        let scene = GameScene(size: skView.bounds.size)
        view.addSubview(skView)
        
        skView.presentScene(scene)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    
    
    // this is an example of how to use the APIConnector
    func testAPIConnector() {
        print ("here")
        let connector = APIConnector()
        //connector.requestNextProblem(callingDelegate: self, level: 0, studentID: "STUDENT1")
        connector.attemptSubmitAnswer(callingDelegate: self, studentID: currentUser!.getIdToken(), studentAnswer: "3")
        
    }
    


    
    
    // Function that gets called when problem answer comes back
    /*func handleSubmitAnswer(data: String) {
        if (data == "correct") {
            
        }
        else {
            
        }
    }*/
    
    // Function that gets called when next problem comes back
    func handleNextProblem(data: String) {
        print (data)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
