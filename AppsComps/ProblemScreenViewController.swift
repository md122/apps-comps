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
    
    var incorrectAttempts: Int = 0
    var scene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProblemText()

        gameView.showsFPS = true
        gameView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        gameView.ignoresSiblingOrder = true
        
        scene = GameScene(size: gameView.bounds.size, parent: self)
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
        scene?.tester()
        let answer = submitTextField.text
        let connector = APIConnector()
        connector.attemptSubmitAnswer(callingDelegate: self, studentID: currentUser!.getIdToken(), studentAnswer: answer!)
    }
    

    
    
    func setProblemText() {
        let connector = APIConnector()
        connector.requestNextProblem(callingDelegate: self, studentID: currentUser!.getIdToken())
        
    }
    


    
    
    // Function that gets called when problem answer comes back
    func handleSubmitAnswer(data: NSDictionary) {
        if (data["data"] as! String == "correct") {
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
                let wrongAnswerAlert = UIAlertController(title: "Incorrect", message: "Your answer is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                wrongAnswerAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action: UIAlertAction!) in
                    self.submitTextField.text = ""
                }))
                wrongAnswerAlert.addAction(UIAlertAction(title: "Go to next problem", style: .default, handler: { (action: UIAlertAction!) in
                    self.submitTextField.text = ""
                    self.setProblemText() // need to make this update student progro
                }))
                wrongAnswerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                present(wrongAnswerAlert, animated: true, completion: nil)
                
                
            }

        }
    }
    
    // Function that gets called when next problem comes back
    func handleNextProblem(data: NSDictionary) {
        problemLabel.text = data["data"] as? String

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
