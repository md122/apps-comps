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

### Resetting the api (you must do this in order for the app to function)
- Login to cmc307-05.mathcs.carleton.edu
    -  You may either physically go to our computer in the CMC and log in or ssh in remotely. Ask Marco or Sam directly for log in credentials.
- Type "ps -e | grep "api.py"" into a terminal window and you will see a number for what process the api is running
- Type "kill [the number you found]"
- Type "python api.py &"
- After it starts type "disown"
