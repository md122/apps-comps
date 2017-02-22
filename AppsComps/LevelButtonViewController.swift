
//
//  LevelButtonViewController.swift
//  AppsComps
//
//  Created by appscomps on 1/18/17.
//  Copyright © 2017 appscomps. All rights reserved.
//
import UIKit


class LevelButtonViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIToolbarDelegate, APIDataDelegate {
    /*Code referenced from https://www.youtube.com/watch?v=UH3HoPar_xg
     Got tips about labeling the cell from http://stackoverflow.com/questions/31735228/how-to-make-a-simple-collection-view-with-swift
     */
    var classroomName: String = ""
    var inClassRoom: Bool = false
    var classroomID: Int = 0
    var highestLevel: Int = 4
    var levelProgress: Int = 3
    
    var levelLabels = ["Level 1", "Level 2", "Level 3", "Level 4"]
    var levels = [1,2,3,4]
    let screen: CGRect = UIScreen.main.bounds
    let connector = APIConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor(red:0.95, green:0.88, blue:0.93, alpha:1.0)
        
        
        //Setting the buttons on the navigation bar
        self.navigationItem.title = "Home"
        let helpButton: UIBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(self.helpClicked(_:)))
        let logoutButton: UIBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
        logoutButton.tintColor = .red
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbarItems = [helpButton, flexibleSpace, logoutButton]
        self.navigationController?.setToolbarItems(toolbarItems, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Get Student dash info to show up on header
        connector.requestStudentDashInfo(callingDelegate: self, studentID: currentUser!.getIdToken())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    //Header Resuable View
    //    www.raywenderlich.com/136161/uicollectionview-tutorial-reusable-views-selection-reordering
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "psHeader", for: indexPath) as! ProblemSelectorReusableView
            
            //Set up header with a coordinate scale
            let width = screen.width
            let height = headerView.frame.height
            let widthUnit = width/100
            let heightUnit = height/100
            
            //Aligning the labels to the left and right of the header. App logo will be in the center of the header
            headerView.classroomText.frame = CGRect(x: widthUnit*5, y: heightUnit*25, width: widthUnit*95, height: heightUnit*25)
            headerView.classroomText.textAlignment = NSTextAlignment.left
            headerView.greetingLabel.frame = CGRect(x: 0, y: heightUnit*25, width: widthUnit*95, height: heightUnit*25)
            headerView.greetingLabel.textAlignment = NSTextAlignment.right
            headerView.levelLabel.frame = CGRect(x: 0, y: heightUnit*25 + headerView.greetingLabel.frame.height, width: widthUnit*95, height: heightUnit*50)
            headerView.levelLabel.textAlignment = NSTextAlignment.right
            headerView.classroomText.text = classroomName
            headerView.greetingLabel.text = "Hello " + currentUser!.getName()
            headerView.levelLabel.text = "You are on level \(highestLevel)"
            headerView.joinButton.setTitle("Join Classroom", for: .normal)
            headerView.leaveButton.setTitle("Leave Class", for: .normal)
            
            //SET COLORS OF EVERYTHING
            //let lightPink = UIColor(red:0.95, green:0.88, blue:0.93, alpha:1.0)
            let brightYellow = UIColor(red:0.94, green:0.80, blue:0.41, alpha:1.0)
            let darkBlue = UIColor(red:0.05, green:0.11, blue:0.20, alpha:1.0)
            headerView.backgroundColor = darkBlue
            headerView.classroomText.textColor = brightYellow
            headerView.greetingLabel.textColor = brightYellow
            headerView.levelLabel.textColor = brightYellow
            
            //Temporary logo
            //Check here for how to resize image: http://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
            headerView.logoView.image = UIImage(named: "logo placeholder")
            headerView.logoView.center = CGPoint(x: widthUnit*50, y: heightUnit*50)
            headerView.logoView.frame = CGRect(x: headerView.logoView.frame.origin.x, y: headerView.logoView.frame.origin.y, width: widthUnit*35, height: headerView.frame.height)
            
            //JOIN/LEAVE CLASSROOM
            if (currentUser as? Student) != nil {
                //INCLUDE IF STATEMENT TO SEE IF STUDENT IS IN CLASS -> IF YES, LEAVE CLASS. IF NO, JOIN CLASS
                if inClassRoom {
                    headerView.joinButton.isHidden = true
                    headerView.leaveButton.isHidden = false
                    
                    headerView.leaveButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
                    headerView.leaveButton.backgroundColor = brightYellow
                    headerView.leaveButton.layer.cornerRadius = 5
                    headerView.leaveButton.setTitleColor(darkBlue, for: .normal)
                    headerView.leaveButton.contentHorizontalAlignment = .left
                    headerView.leaveButton.frame = CGRect(x: widthUnit*5, y: heightUnit*25 + headerView.classroomText.frame.height + heightUnit*15, width: headerView.leaveButton.frame.size.width, height: headerView.leaveButton.frame.size.height)
                }
                else{
                    headerView.leaveButton.isHidden = true
                    headerView.joinButton.isHidden = false
                    
                    headerView.classroomText.text = ""
                    headerView.joinButton.backgroundColor = brightYellow
                    headerView.joinButton.layer.cornerRadius = 5
                    headerView.joinButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
                    headerView.joinButton.frame = CGRect(x: widthUnit*5, y: heightUnit*25 + headerView.classroomText.frame.height + heightUnit*15, width: headerView.joinButton.frame.size.width, height: headerView.joinButton.frame.size.height)
                    headerView.joinButton.setTitleColor(darkBlue, for: .normal)
                    headerView.joinButton.contentHorizontalAlignment = .left
                    
                }
                
            }
                //TEACHER SIDE REMOVES JOIN/LEAVE CLASSROOM ABILITY
            else {
                headerView.joinButton.isHidden = true
                headerView.leaveButton.isHidden = true
                headerView.classroomText.text = "Teacher Mode"
                headerView.levelLabel.text = "All levels accessible"
            }
            
            
            //Set up join/leave classroom button actions
            headerView.joinButton.addTarget(self, action: #selector(self.joinClassroom), for: .touchUpInside)
            headerView.leaveButton.addTarget(self, action: #selector(self.leaveClassroom), for: .touchUpInside)
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
    }
    
    /*Referenced from http://stackoverflow.com/questions/40019875/set-collectionview-size-sizeforitematindexpath-function-is-not-working-swift
     This method should control the size and layout of the cells
     
     Check here for FlowLayout tut: https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/UsingtheFlowLayout/UsingtheFlowLayout.html
     https://developer.apple.com/reference/coregraphics/cgsize
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = screen.width
        
        let unit: CGFloat = width/100
        
        let size = CGSize(width: unit*20, height: unit*30)
        return size
    }
    
    //Setting the padding between the level cells. Currently set up so that 4 buttons are vertically centered.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets{
        let height: CGFloat = screen.height
        let hUnit: CGFloat = height/100
        return UIEdgeInsets(top: hUnit*20, left: 5, bottom: hUnit*20, right: 5)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath) as! LevelButtonCollectionCell
        
        
        //Got help for indexing at: http://stackoverflow.com/questions/36074827/swift-2-1-how-to-pass-index-path-row-of-collectionview-cell-to-segue
        
        cell.levelButton.setTitle(self.levelLabels[indexPath.row], for: .normal)
        cell.levelButton.setLevel(lev: self.levels[indexPath.row])
        let locked: Bool = (cell.levelButton?.checkAccess(curLev: highestLevel))!
        let width: CGFloat = screen.width
        
        let unit: CGFloat = width/100
        cell.levelButton.frame.size = CGSize(width: unit*20, height: unit*20)
        cell.levelButton.layer.cornerRadius = CGFloat(roundf(Float(cell.frame.size.width/2.0)))
        cell.levelButton.setTitleColor(UIColor(red:0.95, green:0.88, blue:0.93, alpha:1.0), for: .normal)
        cell.levelButton.addTarget(self, action: #selector(self.goToProblemScreen), for: .touchUpInside)
        var image : String = "emptystars"
        
        if (!locked) {
            if (cell.levelButton.getLevel() == highestLevel) {
                switch levelProgress {
                case 1: image = "onestars"
                case 2: image = "twostars"
                case 3: image = "threestars"
                default: image = "emptystars"
                }
            }
            else{
                image = "threestars"
            }
            
        }
        cell.levelView.image = UIImage(named: image)
        
        return cell
    }
    @IBAction func goToProblemScreen(_ sender: AnyObject) {
        let curLevel = sender.getLevel()
        print(curLevel)
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "probScreenID") as! ProblemScreenViewController
        
        vc.setLevel(level: curLevel)
        vc.setHighestLevel(level: highestLevel)
        vc.setLevelProgress(progress: levelProgress)
        self.navigationController?.pushViewController(vc, animated:true)
    }
    

    
    
    @IBAction func joinClassroom(_ sender: AnyObject) {
        let joinClassAlert = UIAlertController(title: "Enter Classroom ID", message: "", preferredStyle: .alert)
        
        //joinClassAlert.addTextField(configurationHandler: nil)
        joinClassAlert.addTextField { (textField: UITextField!) in
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        // Join option
        let joinAction = UIAlertAction(title: "Join", style: .default, handler: {
            alert -> Void in
            
            let idTextField = joinClassAlert.textFields![0].text
            //CHECK IF IT'S AN INT > 0, IF NOT TELL THEM IT'S INVALID
            let connector = APIConnector()
            connector.attemptAddStudentToClassroom(callingDelegate: self, studentID: (currentUser?.getIdToken())!, classroomID: idTextField!)
            
        })
        joinClassAlert.addAction(joinAction)
        
        // cancel option
        joinClassAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(joinClassAlert, animated: true, completion: nil)
    }
    
    @IBAction func leaveClassroom(_ sender: AnyObject) {
        let leaveClassAlert = UIAlertController(title: "Leave Classroom", message: "Are you sure you want to leave the classroom?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Log out option
        leaveClassAlert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { (action: UIAlertAction!) in
            //CHANGE CLASSROOMID TO ACTUAL ID LATER
            self.connector.attemptRemoveStudentFromClassroom(callingDelegate: self, studentID: (currentUser?.getIdToken())!, classroomID: String(describing: self.classroomID))
        }))
        
        // cancel option
        leaveClassAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(leaveClassAlert, animated: true, completion: nil)    }
    
    //RETURNS A BOOL THEN A LIST: 1) name of teacher 2) name of classroom
    func handleAddStudentToClassAttempt(data: NSDictionary) {
        print("Incoming handleAddStudentToClassAttempt data")
        print(data)
        //CHANGE JOIN CLASSROOM TO LEAVE
        if data["error"] as? String == "none" && data["error1"] as? String == "none" {
            inClassRoom = true
            let studentsClassroom = data["data"] as! [NSArray]
            let className = studentsClassroom[0][0] as! String
            let classID = studentsClassroom[0][1] as! Int
            classroomName = className
            classroomID = classID
        }
        self.collectionView?.reloadData()
        
    }
    
    // Function that gets called when attempt to remove student from class gets back
    func handleRemoveStudentFromClassAttempt(data: NSDictionary) {
        print("Incoming handleRemoveStudentFromClassAttempt data")
        print(data)
        //CHANGE LEAVE CLASSROOM TO JOIN
        if data["error"] as? String == "none" {
            inClassRoom = false
            classroomName = ""
            classroomID = 0
        }
        self.collectionView?.reloadData()
    }
    
    func handleStudentDashInfoRequest(data: [NSDictionary]) {
        print("TESTING STUDENT DASH")
        //print(data)
        let progressDictionary = data[0]
        let classroomDataDictionary = data[1]
        if progressDictionary["error"] as? String == "none" {
            let studentProgress = progressDictionary["data"] as! [NSArray]
            levelProgress = studentProgress[0][0] as! Int
            highestLevel = studentProgress[0][1] as! Int
        }
        
        if classroomDataDictionary["error"] as? String == "none" {
            let studentsClassroom = classroomDataDictionary["data"] as! [NSArray]
            if studentsClassroom != [] {
                let className = studentsClassroom[0][0] as! String
                let classID = studentsClassroom[0][1] as! Int
                print(className)
                print(classID)
                classroomName = className
                classroomID = classID
                inClassRoom = true
            }
            else {
                classroomName = ""
                inClassRoom = false
            }
        }
        self.collectionView?.reloadData()
        
    }
    
    func logoutClicked(_ sender: UIBarButtonItem) {
        let logOutAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Log out option
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
                GIDSignIn.sharedInstance().signOut()
            }
            currentUser = nil
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        // cancel option
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(logOutAlert, animated: true, completion: nil)
    }
    
    func helpClicked(_ sender: UIBarButtonItem) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpPopUpID") as! HelpViewController
        popOverVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

}
