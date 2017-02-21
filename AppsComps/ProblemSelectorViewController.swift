//
//  ProblemSelectorViewController.swift
//  TeacherDashSingleView
//
//  Created by Wanchen Yao on 11/9/16.
//  Copyright © 2016 appscomps. All rights reserved.
//


/* PLANS FOR NEXT TERM
 -user should retrieve information from Teacher or Student class, not Account class.
 //Actually it might need to be global
 -create a UIButton class which takes in the level and accordingly becomes enable/disabled (green or grey). 
 -level should also be taken from teacher/student class, or the global class
*/
import UIKit

class ProblemSelectorViewController: UIViewController, APIDataDelegate {
//    @IBOutlet weak var greetingText: UILabel!
//    @IBOutlet weak var levelText: UILabel!
//    @IBOutlet weak var leaveButton: UIButton!
//    @IBOutlet weak var joinButton: UIButton!
//    @IBOutlet weak var classroomText: UILabel!
    @IBOutlet weak var levelContainerView: UIView!
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var studentLogoutButton: UIBarButtonItem!
//    @IBOutlet weak var logoView: UIImageView!


    
    let screen: CGRect = UIScreen.main.bounds
    let connector = APIConnector()
    //TODO: level should also be taken from teacher/student class, or the global class

    override func viewDidLoad() {
        
        // Creates a fake user for testing purposes
        if(currentUser == nil) {
            currentUser = Student(idToken: "fakeID", name: "W")
        }
        
        // Sam put this in an if statement because it crashes the program
        // Basically it assumes the user is a student, so it crashes the db call
        if(currentUser != nil && (currentUser as? Student) != nil) {
            //Get Student dash info to show up on header
            connector.requestStudentDashInfo(callingDelegate: self, studentID: currentUser!.getIdToken())
        }
    
        
        super.viewDidLoad()
        //Set up header with a coordinate scale
//        let width = screen.width
//        let height = headerView.frame.height
//        let widthUnit = width/100
//        let heightUnit = height/100
//        
//        
//        
//        //Aligning the labels to the left and right of the header. App logo will be in the center of the header
//        
//        headerView.frame = CGRect(x: headerView.frame.origin.x, y: headerView.frame.origin.y, width: screen.width, height: headerView.frame.height)
//        classroomText.frame = CGRect(x: widthUnit*5, y: heightUnit*25, width: widthUnit*95, height: heightUnit*25)
//        classroomText.textAlignment = NSTextAlignment.left
//        greetingText.frame = CGRect(x: 0, y: heightUnit*25, width: widthUnit*95, height: heightUnit*25)
//        greetingText.textAlignment = NSTextAlignment.right
//        levelText.frame = CGRect(x: 0, y: heightUnit*25 + greetingText.frame.height, width: widthUnit*95, height: heightUnit*50)
//        levelText.textAlignment = NSTextAlignment.right
//        greetingText.text = "Hello " + currentUser!.getName()
//        levelText.text = "You are on level \(currentUser!.getHighestLevel())"
//        joinButton.setTitle("Join Classroom", for: .normal)
//        leaveButton.setTitle("Leave Class", for: .normal)
//        
//        //SET COLORS OF EVERYTHING
//        let lightPink = UIColor(red:0.95, green:0.88, blue:0.93, alpha:1.0)
//        let brightYellow = UIColor(red:0.94, green:0.80, blue:0.41, alpha:1.0)
//        let darkBlue = UIColor(red:0.05, green:0.11, blue:0.20, alpha:1.0)
//        headerView.backgroundColor = darkBlue
//        classroomText.textColor = brightYellow
//        greetingText.textColor = brightYellow
//        levelText.textColor = brightYellow
//        view.backgroundColor = lightPink
//        
//        //JOIN/LEAVE CLASSROOM
//        if (currentUser as? Student) != nil {
//            //INCLUDE IF STATEMENT TO SEE IF STUDENT IS IN CLASS -> IF YES, LEAVE CLASS. IF NO, JOIN CLASS
//            
//            leaveButton.isHidden = false
//            leaveButton.frame = CGRect(x: widthUnit*5, y: heightUnit*25 + classroomText.frame.height + heightUnit*15, width: leaveButton.frame.size.width, height: leaveButton.frame.size.height)
//            
//            leaveButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
//            leaveButton.backgroundColor = brightYellow
//            leaveButton.layer.cornerRadius = 5
//            leaveButton.setTitleColor(darkBlue, for: .normal)
//            leaveButton.contentHorizontalAlignment = .left
//            joinButton.backgroundColor = brightYellow
//            joinButton.layer.cornerRadius = 5
//            joinButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
//            joinButton.frame = CGRect(x: widthUnit*5, y: heightUnit*25 + classroomText.frame.height + heightUnit*15, width: joinButton.frame.size.width, height: joinButton.frame.size.height)
//            joinButton.setTitleColor(darkBlue, for: .normal)
//            joinButton.contentHorizontalAlignment = .left
//
//        }
//            //TEACHER SIDE REMOVES JOIN/LEAVE CLASSROOM ABILITY
//        else {
//            joinButton.isHidden = true
//            leaveButton.isHidden = true
//            classroomText.text = "Teacher Mode"
//            levelText.text = "All levels accessible"
//        }
//        
//        //Temporary logo
//        //Check here for how to resize image: http://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
//        logoView.image = UIImage(named: "mathlogo")
//        logoView.center = CGPoint(x: widthUnit*50, y: heightUnit*50)
//        
        // Set the UIButton to Logout if the less than 2 items on navigation stack
        // This occurs when a going straight from the login to student view
        // In other words make a logout button on student view, but not if coming from teacher
<<<<<<< HEAD
        if let navController = self.navigationController, navController.viewControllers.count < 2 {
            let leftButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
            leftButton.tintColor = .red
            self.navigationItem.leftBarButtonItem = leftButton
        }
        
//        //Set up join/leave classroom button actions
//        joinButton.addTarget(self, action: #selector(self.joinClassroom), for: .touchUpInside)
//        leaveButton.addTarget(self, action: #selector(self.leaveClassroom), for: .touchUpInside)
=======
//        if let navController = self.navigationController, navController.viewControllers.count < 2 {
//            let leftButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
//            leftButton.tintColor = .red
//            self.navigationItem.rightBarButtonItem = leftButton
//        }
//        
        //Set up join/leave classroom button actions
        joinButton.addTarget(self, action: #selector(self.joinClassroom), for: .touchUpInside)
        leaveButton.addTarget(self, action: #selector(self.leaveClassroom), for: .touchUpInside)
>>>>>>> 25f4e3fa4869ea9051ccb0f6dbe3c1ddd614f3af
        
        //Toolbar Inclusion
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        
        

    }
    
    //Tutorial from https://www.youtube.com/watch?v=FgCIRMz_3dE
    @IBAction func helpPopup(_ sender: AnyObject) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpPopUpID") as! HelpViewController
        popOverVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    // Note there is a similar logout in Teacher, changes to one should also go in the other
    // At some point Sam should figure out how to just merge the two, because this is sloppy
    @IBAction func logoutClicked(_ sender: AnyObject) {
        let createAccountAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Log out option
        createAccountAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            GIDSignIn.sharedInstance().signOut()
        }
        currentUser = nil
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        // cancel option
        createAccountAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(createAccountAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func joinClassroom(_ sender: AnyObject) {
        let joinClassAlert = UIAlertController(title: "Enter Classroom ID", message: "", preferredStyle: .alert)
        
        joinClassAlert.addTextField(configurationHandler: nil)

        // Join option
        let joinAction = UIAlertAction(title: "Join", style: .default, handler: {
            alert -> Void in
            
            let idTextField = joinClassAlert.textFields![0].text
            
            let connector = APIConnector()
            connector.attemptAddStudentToClassroom(callingDelegate: self, studentID: (currentUser?.getIdToken())!, classroomID: idTextField!)
            
        })
        joinClassAlert.addAction(joinAction)
        
        // cancel option
        joinClassAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(joinClassAlert, animated: true, completion: nil)
    }
    
//    @IBAction func leaveClassroom(_ sender: AnyObject) {
//        let leaveClassAlert = UIAlertController(title: "Leave Classroom", message: "Are you sure you want to leave the classroom?", preferredStyle: UIAlertControllerStyle.alert)
//        
//        // Log out option
//        leaveClassAlert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { (action: UIAlertAction!) in
//            //CHANGE CLASSROOMID TO ACTUAL ID LATER
//            self.connector.attemptRemoveStudentFromClassroom(callingDelegate: self, studentID: (currentUser?.getIdToken())!, classroomID: self.classroomText.text!)
//        }))
//        
//        // cancel option
//        leaveClassAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//        }))
//        present(leaveClassAlert, animated: true, completion: nil)    }
//    
//    //RETURNS A BOOL THEN A LIST: 1) name of teacher 2) name of classroom
//    func handleAddStudentToClassAttempt(data: NSDictionary) {
//        print("Incoming handleAddStudentToClassAttempt data")
//        print(data)
//        //CHANGE JOIN CLASSROOM TO LEAVE
//        if data["error"] as? String == "none" && data["error1"] as? String == "none" {
//            joinButton.isHidden = true
//            leaveButton.isHidden = false
//            //CHANGE THE CLASSROOM NAME
//            let classRoom = data["data"] as! [NSArray]
//            self.classroomText.text = classRoom[0][0] as? String
//        }
//        
//
//    }
//    
//    // Function that gets called when attempt to remove student from class gets back
//    func handleRemoveStudentFromClassAttempt(data: NSDictionary) {
//        print("Incoming handleRemoveStudentFromClassAttempt data")
//        print(data)
//        //CHANGE LEAVE CLASSROOM TO JOIN
//        if data["error"] as? String == "none" {
//            joinButton.isHidden = false
//            leaveButton.isHidden = true
//        }
//        
//    }
    
    func handleStudentDashInfoRequest(data: [NSDictionary]) {
        print("TESTING STUDENT DASH")
        //print(data)
        let progressDictionary = data[0]
        let classroomDataDictionary = data[1]
        if progressDictionary["error"] as? String == "none" {
            let studentProgress = progressDictionary["data"] as! [NSArray]
            let stars = studentProgress[0][0] as! Int
            let level = studentProgress[0][1] as! Int
            print(level)
            print(stars)
        }
        
        if classroomDataDictionary["error"] as? String == "none" {
            let studentsClassroom = classroomDataDictionary["data"] as! [NSArray]
            if studentsClassroom != [] {
                let classroomName = studentsClassroom[0][0] as! String
                let classroomID = studentsClassroom[0][1] as! Int
                print(classroomName)
                print(classroomID)
            }
        }
        
        
    }

}
