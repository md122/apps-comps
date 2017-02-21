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
    @IBOutlet weak var stars: UIImageView!
    
    var level: Int = 3
    var highestLevel: Int = 3
    var incorrectAttempts: Int = 0
    var currentProblem: Int?
    var levelProgress: Int = 2
    var scene: GameScene?

    override func viewDidLoad() {
        
        levelLabel.text = "Level: \(self.level)"
        setProblemText()
        setStars(correctAnswers: self.levelProgress)
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
    
    
    func setHighestLevel(level: Int) {
        self.highestLevel = level
    }
    
    func setLevel(level: Int) {
        self.level = level
        levelLabel.text = "Level: \(self.level)"
    }
    

    
    func setStars(correctAnswers: Int) {
        var image : String = "emptystars"
        if (self.highestLevel == self.level) {
            self.levelProgress = correctAnswers
            switch levelProgress {
                case 1: image = "onestars"
                case 2: image = "twostars"
                case 3: image = "threestars"
                default: image = "emptystars"
            }
        }
        else {
            self.levelProgress = 3
            image = "threestars"
        }
        stars.image = UIImage(named: image)
    }
    
    func rightAnswerAlert() {
        let rightAnswerAlert = UIAlertController(title: "Correct!", message: "Great job!", preferredStyle: UIAlertControllerStyle.alert)
        rightAnswerAlert.addAction(UIAlertAction(title: "Go to next problem", style: .default, handler: { (action: UIAlertAction!) in
            self.submitTextField.text = ""
            self.setProblemText()
        }))
        present(rightAnswerAlert, animated: true, completion: nil)
    }
    
    
    func unlockLevelAlert() {
        let unlockAlert = UIAlertController(title: "Correct!", message: "Great job! Level " + String(self.highestLevel) + " unlocked.", preferredStyle: UIAlertControllerStyle.alert)
        unlockAlert.addAction(UIAlertAction(title: "Go to next level", style: .default, handler: { (action: UIAlertAction!) in
            self.submitTextField.text = ""
            self.setLevel(level: self.level+1)
            self.levelProgress = 0
            self.setStars(correctAnswers: 0)
            self.setProblemText()
        }))
        unlockAlert.addAction(UIAlertAction(title: "Stay on this level", style: .default, handler: { (action: UIAlertAction!) in
            self.submitTextField.text = ""
            self.setProblemText()
            
        }))
        present(unlockAlert, animated: true, completion: nil)
    }
    
    func endOfProblemsAlert() {
        let endOfProblems = UIAlertController(title: "Correct!", message: "Great job! You solved all the levels!", preferredStyle: UIAlertControllerStyle.alert)
        endOfProblems.addAction(UIAlertAction(title: "Keep doing problems", style: .default, handler: { (action: UIAlertAction!) in
            self.submitTextField.text = ""
            self.setProblemText()
            
        }))
        present(endOfProblems, animated: true, completion: nil)
    }
    
    func skipProblemAlert(answerMessage: String) {
        let wrongAnswerAlert = UIAlertController(title: "Incorrect", message: answerMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        wrongAnswerAlert.addAction(UIAlertAction(title: "Go to next problem", style: .default, handler: { (action: UIAlertAction!) in
        
        APIConnector().attemptSkipProblem(callingDelegate: self, studentID: currentUser!.getIdToken(), level: self.level, problemNum: self.currentProblem!)
        }))
        present(wrongAnswerAlert, animated: true, completion: nil)
    }
    
    func wrongAnswerAlert() {
        let wrongAnswerAlert = UIAlertController(title: "Incorrect", message: "Your answer is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
        wrongAnswerAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action: UIAlertAction!) in
            self.submitTextField.text = ""
        }))
        wrongAnswerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(wrongAnswerAlert, animated: true, completion: nil)
    }
    

    // Function that gets called when problem answer comes back
    func handleSubmitAnswer(data: [NSDictionary]) {
        if (data[0]["isCorrect"] as! String == "correct") {
            if (self.level == self.highestLevel) {
                self.levelProgress += 1
                self.setStars(correctAnswers: self.levelProgress)
                if (levelProgress == 3) {
                    self.highestLevel += 1
                    if (self.highestLevel < 5) {
                        
                        unlockLevelAlert()
                    }
                    else {
                        endOfProblemsAlert()
                    }
                }
                else {
                    rightAnswerAlert()
                }
            }
            else {
                rightAnswerAlert()
            }
        }
        else {
            incorrectAttempts += 1
            if (incorrectAttempts < 3) {
                wrongAnswerAlert()
            }
            else {
                let temp = data[1]["data"] as! [NSArray]
                let correctAnswer = temp[0][0] as? String
                let errorMessage = "Correct answer: " + correctAnswer!
                skipProblemAlert(answerMessage: errorMessage)
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
            if self.highestLevel == self.level {
                self.levelProgress = 0
                self.setStars(correctAnswers: 0)
            }
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
