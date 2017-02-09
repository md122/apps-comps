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

    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var submitTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        gameView.ignoresSiblingOrder = true
        
        let scene = GameScene(size: gameView.bounds.size)
        gameView.presentScene(scene)
        
        testAPIConnector()
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
        let connector = APIConnector()
        connector.requestNextProblem(callingDelegate: self, level: 0, studentID: "STUDENT1")
        
        connector.attemptAddProblemData(callingDelegate: self, start_time: "10/12", end_time: "10/12", answer: "6", wasCorrect: false)
    }
    
    // Function that gets called when next problem comes back
    func handleNextProblem(data: [NSArray]) {
        print("Incoming handleNextProblem data")
        print(data)
    }

    
    
    // Function that gets called when student data comes back
    func handleAddProblemDataAttempt(data: Bool) {
        print("Incoming handleAddProblemDataAttempt data")
        print(data)
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
