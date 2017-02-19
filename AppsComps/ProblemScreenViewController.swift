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
    @IBOutlet weak var levelLabel: UILabel!
    
    var level: Int = 1
    var currentProblem: Int?
    var incorrectAttempts: Int = 0
    var scene: GameScene?

    override func viewDidLoad() {
        
        levelLabel.text = "Level: \(self.level)"
        setProblemText()
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        

        gameView.showsFPS = false
        gameView.showsNodeCount = false
        gameView.ignoresSiblingOrder = true
        
        scene = GameScene(size: gameView.bounds.size, parent: self)

        gameView.layer.borderWidth = 5
        gameView.layer.cornerRadius = 0
        gameView.layer.masksToBounds = true
        gameView.presentScene(scene)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @IBAction func submitAnswer(_ sender: AnyObject) {
        //!!!!!!!! Right now problem screen always clears when you submit an answer, need to only clear when correct answer submitted
        scene?.clearProblemScreen()
        let answer = submitTextField.text
        APIConnector().attemptSubmitAnswer(callingDelegate: self, studentID: currentUser!.getIdToken(), studentAnswer: answer!, level: self.level, problemNum: self.currentProblem!)
    }
    
    func setProblemText() {
        let connector = APIConnector()
        connector.requestNextProblem(callingDelegate: self, studentID: currentUser!.getIdToken(), level: level)
    }
    
    
    func updateLevel(){
        self.level += 1
        levelLabel.text = "Level: \(self.level)"
        
    }
    
    
    // Function that gets called when problem answer comes back
    func handleSubmitAnswer(data: [NSDictionary]) {
        if (data[0]["isCorrect"] as! String == "correct") {
            let rightAnswerAlert = UIAlertController(title: "Correct!", message: "Great job!", preferredStyle: UIAlertControllerStyle.alert)
            rightAnswerAlert.addAction(UIAlertAction(title: "Go to next problem", style: .default, handler: { (action: UIAlertAction!) in
                self.submitTextField.text = ""
                self.setProblemText()
            }))
            present(rightAnswerAlert, animated: true, completion: nil)

        }
        else {
            incorrectAttempts += 1
            if (incorrectAttempts < 3) {
                let wrongAnswerAlert = UIAlertController(title: "Incorrect", message: "Your answer is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                wrongAnswerAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action: UIAlertAction!) in
                    self.submitTextField.text = ""
                }))
                wrongAnswerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                present(wrongAnswerAlert, animated: true, completion: nil)
            }
            else {
                let temp = data[1]["data"] as! [NSArray]
                let correctAnswer = temp[0][0] as? String
                let errorMessage = "Correct answer: " + correctAnswer!
                let wrongAnswerAlert = UIAlertController(title: "Incorrect", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                wrongAnswerAlert.addAction(UIAlertAction(title: "Go to next problem", style: .default, handler: { (action: UIAlertAction!) in
                    APIConnector().attemptSkipProblem(callingDelegate: self, studentID: currentUser!.getIdToken(), level: self.level, problemNum: self.currentProblem!)
                }))
                wrongAnswerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                present(wrongAnswerAlert, animated: true, completion: nil)
            }
        }
    }
    
    // Function that gets called when next problem comes back
    func handleNextProblem(data: NSDictionary) {
        incorrectAttempts = 0
        if (data["error"] as! String == "none") {
            let tempData = data["data"] as! [NSArray]
            self.problemLabel.text = tempData[0][0] as? String
            self.currentProblem = tempData[0][1] as? Int
        }
    }

    func handleSkipProblemAttempt(data: NSDictionary) {
        if (data["error"] as! String == "none") {
            self.setProblemText()
        }
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
