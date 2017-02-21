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
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    
    var level: Int = 1
    var incorrectAttempts: Int = 0
    var currentProblem: Int?
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
    
    func submitAnswerAlert() {
        let invalidAnswerAlert = UIAlertController(title: "Invalid submission", message: "Your submission was invalid :(. Make sure you're submitting only a number!", preferredStyle: UIAlertControllerStyle.alert)
        invalidAnswerAlert.addAction(UIAlertAction(title: "Submit another answer", style: .default, handler: { (action: UIAlertAction!) in
            self.submitAnswerAlert()
        }))
        invalidAnswerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        let submitAnswerAlert = UIAlertController(title: "Submit answer", message: "Enter your number answer!", preferredStyle: UIAlertControllerStyle.alert)
        submitAnswerAlert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        submitAnswerAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in }))
        submitAnswerAlert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (action: UIAlertAction!) in
            if let valueEntered = submitAnswerAlert.textFields![0].text {
                if Double(valueEntered) != nil {
                    APIConnector().attemptSubmitAnswer(callingDelegate: self, studentID: currentUser!.getIdToken(), studentAnswer: valueEntered, level: self.level, problemNum: self.currentProblem!)
                } else {
                    self.present(invalidAnswerAlert, animated: true, completion: nil)
                }
                
            } else {
                self.present(invalidAnswerAlert, animated: true, completion: nil)
            }
        }))
        self.present(submitAnswerAlert, animated: true, completion: nil)
    }
    

    @IBAction func submitAnswer(_ sender: AnyObject) {
        submitAnswerAlert()
    }
    
    func setProblemText() {
        let connector = APIConnector()
        connector.requestNextProblem(callingDelegate: self, studentID: currentUser!.getIdToken(), level: level)
    }
    
    func setLevel(level: Int){
        self.level = level
        levelLabel.text = "Level: \(self.level)"
        
    }
    
    // Function that gets called when problem answer comes back
    func handleSubmitAnswer(data: [NSDictionary]) {
        if (data[0]["isCorrect"] as! String == "correct") {
            if (data[0]["nextLevelUnlocked"] as! String != "false") {
                let nextLevel = data[0]["nextLevelUnlocked"] as? String
                let rightAnswerAlert = UIAlertController(title: "Correct!", message: "Great job! Level " + nextLevel! + "  unlocked.", preferredStyle: UIAlertControllerStyle.alert)
                rightAnswerAlert.addAction(UIAlertAction(title: "Go to next level", style: .default, handler: { (action: UIAlertAction!) in
                    self.setLevel(level: self.level+1)
                    self.setProblemText()
                }))
                rightAnswerAlert.addAction(UIAlertAction(title: "Stay on this level", style: .default, handler: { (action: UIAlertAction!) in
                    self.setProblemText()
                }))
                present(rightAnswerAlert, animated: true, completion: nil)
            }
            else {
                let rightAnswerAlert = UIAlertController(title: "Correct!", message: "Great job!", preferredStyle: UIAlertControllerStyle.alert)
                rightAnswerAlert.addAction(UIAlertAction(title: "Go to next problem", style: .default, handler: { (action: UIAlertAction!) in
                    self.setProblemText()
                    self.scene?.clearProblemScreen()
                }))
                present(rightAnswerAlert, animated: true, completion: nil)
            }

        }
        else {
            incorrectAttempts += 1
            if (incorrectAttempts < 3) {
                let wrongAnswerAlert = UIAlertController(title: "Incorrect", message: "Your answer is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                wrongAnswerAlert.addAction(UIAlertAction(title: "Keep Working on Problem", style: .default, handler: { (action: UIAlertAction!) in
                }))
                wrongAnswerAlert.addAction(UIAlertAction(title: "Start Over Problem", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.scene?.clearProblemScreen()
                }))
                present(wrongAnswerAlert, animated: true, completion: nil)
            }
            else {
                let temp = data[1]["data"] as! [NSArray]
                let correctAnswer = temp[0][0] as? String
                let errorMessage = "Correct answer: " + correctAnswer!
                let wrongAnswerAlert = UIAlertController(title: "Incorrect", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                wrongAnswerAlert.addAction(UIAlertAction(title: "Go to Next Problem", style: .default, handler: { (action: UIAlertAction!) in
                    APIConnector().attemptSkipProblem(callingDelegate: self, studentID: currentUser!.getIdToken(), level: self.level, problemNum: self.currentProblem!)
                }))
                wrongAnswerAlert.addAction(UIAlertAction(title: "Keep Working on Problem", style: .cancel, handler: { (action: UIAlertAction!) in
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
