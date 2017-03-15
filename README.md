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
* Reset the api (instructions below)
* Try running the app!
  * If running in the XCode simulator we reccomend using iPad Air

### Resetting the api 
*As of the end of Winter Term 2017 our api is running in "developer mode" from our lab computer in the CMC at Carleton College. You mus be on campus to reset the api and use our app.*

- Login to cmc307-05.mathcs.carleton.edu
    -  You may ssh in remotely or do this on our lab computer in the CMC. Ask a member of our group directly for log in credentials.
- Type "ps -e | grep "api.py"" into a terminal window and you will see a number for what process the api is running
- Type "kill [the number you found]"
- Type "python api.py &"
- After it starts type "disown"
