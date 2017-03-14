# AlgeBar

AlgeBar is an iPad application for students and teachers. Students are able to visually model algebra problems using Bar Modeling, and teachers are able to see the students' progress.

### Tools

We wrote AlgeBar using XCode 8.0 and Swift 3.0. You will need Cocoapods to run this application.

### Build Process

* `git clone https://github.com/md122/apps-comps.git`
* If you don't already have Cocoapods:
  * `sudo gem install cocoapods`
* `pod install`
* `open AppsComps.xcworkspace`
* Try running the app!

### Instructions for merging back into master:
- git status
- git add -A
- git commit -am “Message”
    - if you don't use m you enter vim to edit message
    - To copy and paste do ":set paste"
    - Then "i" for insert mode
    - Then paste
    - Then press escape :wq
- git status
- git pull
- git push
- git status
- git pull origin master
- pod install
    - If you haven’t installed Alamofire before, you will need to update to current Swift syntax which is fine
    - It’ll give 10000 errors but once you build everything will autofix
- *fix merge conflicts*
- git status
- git add -A
- git commit -am “Fixed merge conflicts”
- git status
- git pull
- git push
- *make pull request online*


- If you have .pbxproj conflicts
    - Go to apps-comps folder
    - Right click AppsComps.xcodeproj, Click show package contents
    - Double click project.pbxproj
    - Find <<<<<<<
    - Try to fix all conlicts
- If you have Storyboard issues
    - Open xcode
    - right click Main.Storyboard
        - Choose Open As > Source Code

### Resetting the api (you must do this in order for the app to function)
- Login to cmc307-05.mathcs.carleton.edu
    -  You may either physically go to our computer in the CMC and log in or ssh in remotely. Ask Marco or Sam directly for log in credentials.
- Type "ps -e | grep "api.py"" into a terminal window and you will see a number for what process the api is running
- Type "kill [the number you found"
- Type "python api.py &"
- TAfter it starts type "disown"
