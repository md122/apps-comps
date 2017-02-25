#!/usr/bin/env python3
'''
    api.py
    By Sam Neubauer and Marco Dow
    Things to remember: json.dumps(data) will return data is JSON format!
'''
import sys
import flask
import json
from queries import *
from datetime import datetime
from oauth2client import client, crypt

app = flask.Flask(__name__, static_folder='static', template_folder='templates')
CLIENT_ID = "674430839285-nu3fd5t9vfe8e7p3oqm77olhvd0091kb.apps.googleusercontent.com"

# Receives google idtoken and returns verified [userid,username] or throws an error
def verifyToken(token):
    # copied from google tutorial
    try:
        idinfo = client.verify_id_token(token, CLIENT_ID)
        if idinfo['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise crypt.AppIdentityError("Wrong issuer.")
    except crypt.AppIdentityError:
        # Invalid token
        return "ERROR: invalid token"
    userid = idinfo['sub']
    name = idinfo['name']
    return [userid,name]

@app.route('/')
def get_main_page():
    return "API is up"



# Creates a new user in the database using userID, user's full name,
# and account type where 0=student 1=teacher
# user_id, user_full_name, user_type, last_login
# Returns userID
@app.route('/attemptCreateUser/<idToken>/<accountType>')
def apiCreateUser(idToken, accountType):
    userinfo = verifyToken(idToken)
    userid = userinfo[0]
    username = userinfo[1]
    result = addAccount(userid, username, accountType)
    return username

# Checks to see if userid from token is in database of existing users
# If so, returns True, else False
@app.route('/attemptLogin/<token>')
def apiLogin(token):
    userid = verifyToken(token)[0] # Checks to see if token is valid google token
    result = checkLogin(userid) # Checks to see if userid is in db
    data = result['data']
    print data
    if str(data) == "[]":
        result['error'] = "ERROR: Account does not exist"
    if str(data) == "[('0',)]":
        result['data'] = "Student"
    if str(data) == "[('1',)]":
        result['data'] = "Teacher"
    return json.dumps(result)


# Takes userID, checks which problem is next, and returns the text
# for that problem
@app.route('/attemptGetNextProblem/<token>/<level>')
def apiGetNextProblem(token, level):
    userid = verifyToken(token)[0] # Checks to see if token is valid google token
    result = getNextProblem(userid, level)
    print "About to the return the next problem. Got back this:" + str(result)
    return json.dumps(result)

# Checks if problem answer is correct and if so updates database
# TODO needs to handle new dictionary return format
@app.route('/attemptSubmitAnswer/<token>/<answer>/<level>/<num>')
def apiSubmitAnswer(token, answer, level, num):
    userid = verifyToken(token)[0]
    result = checkAnswer(userid, answer, level, num)
    return json.dumps(result)


@app.route('/attemptSkipProblem/<token>/<level>/<num>')
def apiSkipProblem(token, level, num):
    userid = verifyToken(token)[0]
    result = updateProgress(userid, level, num, False, True)[0]
    return json.dumps(result)



# Creates a new classroom with an associated teacher
@app.route('/attemptAddClassroom/<teacherID>/<classroomName>')
def apiAddClassroom(teacherID, classroomName):
    teacherID = verifyToken(teacherID)[0]
    result = addClassroom(teacherID, classroomName)
    print result
    # Error that results if accounts doesn't include teacherID
    if "violates foreign key constraint" in result['error']:
        result['error'] = "ERROR: teacherID is invalid or does not exist"
    return json.dumps(result)

# Attempts to delete the classroom with associated classroomID
# If there is not classroom with given ID still returns True
@app.route('/attemptRemoveClassroom/<classroomID>')
def apiRemoveClassroom(classroomID):
    result = removeClassroom(classroomID)
    return json.dumps(result)

# Attempt to add student to class
@app.route('/attemptAddStudentToClassroom/<studentID>/<classroomID>')
def apiAddStudentToClassroom(studentID, classroomID):
    studentID = verifyToken(studentID)[0]
    result = addStudentToClassroom(studentID, classroomID)
    if "is not present in table" in  result['error1']:
        result['error1'] = "ERROR: classroom does not exist"
    if "violates foreign key constraint" in result['error']:
        result['error'] = "ERROR: student id or classroom id invalid"
    if "value violates unique constraint" in result['error1']:
        result['error1'] = "ERROR: student already in classroom"
    if "invalid input syntax for integer" in result['error1']:
        result['error1'] = "ERROR: invalid classroom ID format"
        result['error'] = "ERROR: invalid classroom ID format"
    return json.dumps(result)

# Attempts to remove a student from a classroom
# If there is not classroom with given ID still returns True
@app.route('/attemptRemoveStudentFromClassroom/<studentID>/<classroomID>')
def apiRemoveStudentFromClassroom(studentID, classroomID):
    studentID = verifyToken(studentID)[0]
    result = removeStudentFromClassroom(studentID, classroomID)
    print result
    return json.dumps(result)


# Returns all of the teacherdash info for a given teacherID
# If there is not classroom with given ID still returns True
@app.route('/requestTeacherDashInfo/<teacherID>')
def apiRequestTeacherDashInfo(teacherID):
    teacherID = verifyToken(teacherID)[0]
    result = requestTeacherDashInfo(teacherID)
    return json.dumps(result)

# Returns all of the studentdash info for a given studentID
# If there is not classroom with given ID still returns True
@app.route('/requestStudentDashInfo/<studentID>')
def apiRequestStudentDashInfo(studentID):
    studentID = verifyToken(studentID)[0]
    result = requestStudentDashInfo(studentID)
    return json.dumps(result)

# Returns all of the students for given classroom
@app.route('/requestClassroomData/<classroomID>')
def apiRequestClassroomData(classroomID):
    result = requestClassroomData(classroomID)
    return json.dumps(result)

if __name__ == '__main__':
    host = "cmc307-05.mathcs.carleton.edu"
    port = "5000"
    app.run(host=host, port=port)
