'''
This program contains helper functions for api.py to write and send
SQL queries to the database.
'''

import sys, os
import config
import psycopg2
from datetime import datetime



def createConnection():
    try:
        connection = psycopg2.connect(database=config.database, user=config.user, password=config.password)
        print "DB connection established"
        return connection
    except psycopg2.Error as e:
        return {'error': str(e)}


def addDeleteData(query, connection):
    rows = []
    try:
        cursor = connection.cursor()
        print "Running query: " + query
        cursor.execute(query)
        connection.commit()
        print "Everything went well with the db"
        return {'error': 'none'}

    except Exception as e2:
        print "Had some error with the db"
        print e2
        return {'error': str(e2)}
    print "Everything went well with the db"


def getData(query, connection):
    '''
    Returns a list of rows obtained from the database
    by the specified SQL query. If the query fails for any reason,
    an empty list is returned.
    '''
    # Fetch rows of data
    rows = []
    try:
        cursor = connection.cursor()
        print "Running query: " + query
        cursor.execute(query)
        rows = cursor.fetchall() # This can be trouble if your query results are really big.
        connection.commit()
    except Exception as e2:
        print e2
        return {'error': str(e2), 'data': []}
    data = []
    for d in rows:
        data.append(d)
    print "DB call success. Data:"
    returnValue = {'error': 'none', 'data': data}
    print returnValue
    return returnValue


# Login / Account creation methods


def addAccount(userID, name, usertype):
    conn = createConnection()
    cur = conn.cursor()
    if usertype == "teacher":
        usertype = '1'
    elif usertype == "student":
        usertype = '0'
    else:
        return "ERROR: invalid user type"
    query = cur.mogrify("INSERT INTO accounts VALUES (%s, %s, %s, now());",(userID, name, usertype))
    if usertype == '1':
        query2 = cur.mogrify("INSERT INTO progress VALUES (%s, 5, 0, 0);",(userID,))
    else:
        query2 = cur.mogrify("INSERT INTO progress VALUES (%s, 1, 0, 0);",(userID,))
    addDeleteData(query, conn)
    result = addDeleteData(query2, conn)
    conn.close()
    return result

# checks in a userID is already a part of the accounts table
def checkLogin(userID):
    conn = createConnection()
    cur = conn.cursor()
    query = cur.mogrify("SELECT user_type FROM accounts WHERE user_id = %s;",(userID,))
    result = getData(query, conn)
    conn.close()
    return result


# Dashboard methods

# Given a teacherID and classroomName adds to classrooms table
def addClassroom(teacherID, classroomName):
    conn = createConnection()
    cur = conn.cursor()
    query = cur.mogrify("INSERT INTO classrooms (classroom_name, teacher_id) VALUES  (%s, %s) RETURNING classroom_name, classroom_id;",(classroomName, teacherID))
    result = getData(query, conn)
    conn.close()
    return result


# given a classroomID, removes it from the database
# won't work if any students are currently in class, need to remove them first
# also doesn't check if class actually exists
def removeClassroom(classroomID):
    conn = createConnection()
    cur = conn.cursor()
    # remove all students from the classroom
    query1 = cur.mogrify("DELETE FROM classroom_student WHERE classroom_id = %s;",(classroomID,))
    # remove the classroom
    query2 = cur.mogrify("DELETE FROM classrooms WHERE classroom_id = %s;",(classroomID,))
    removeStudentsAttempt = addDeleteData(query1, conn)
    removeClassroomAttempt = addDeleteData(query2, conn)
    removeClassroomAttempt["error1"] = removeStudentsAttempt["error"]
    conn.close()
    return removeClassroomAttempt

# Given a studentID and classroomName adds student to classroom
def addStudentToClassroom(studentID, classroomID):
    conn = createConnection()
    cur = conn.cursor()
    query = cur.mogrify("INSERT INTO classroom_student (student_id, classroom_id) VALUES  (%s, %s);",(studentID, classroomID))
    conn1 = createConnection()
    cur1 = conn1.cursor()
    query1 = cur1.mogrify("SELECT classroom_name, classroom_id FROM classrooms WHERE classroom_id = %s;", (classroomID,))
    queryOneResult = addDeleteData(query, conn)
    queryTwoResult = getData(query1, conn1)
    queryTwoResult["error1"] = queryOneResult["error"]
    conn.close()
    return queryTwoResult

# given a studentID and classroomID, removes student from classroom
def removeStudentFromClassroom(studentID, classroomID):
    conn = createConnection()
    cur = conn.cursor()
    query = cur.mogrify("DELETE FROM classroom_student WHERE classroom_id = %s and student_id = %s;",(classroomID, studentID))
    result = addDeleteData(query, conn)
    conn.close()
    return result

def requestStudentDashInfo(studentID):
    conn = createConnection()
    cur = conn.cursor()
    classroomQuery = cur.mogrify("SELECT classroom_name, classrooms.classroom_id FROM classroom_student JOIN classrooms on classrooms.classroom_id = classroom_student.classroom_id WHERE student_id = %s;", (studentID,))
    progressQuery = cur.mogrify("SELECT num_correct, level FROM progress WHERE user_id = %s;", (studentID,))
    studentClassInfo = getData(classroomQuery, conn)
    studentProgressInfo = getData(progressQuery, conn)
    conn.close()
    return [studentProgressInfo, studentClassInfo]

# TODO: ADD AN ERROR CHECK IF NO TEACHER ID
def requestTeacherDashInfo(teacherID):
    conn = createConnection()
    cur = conn.cursor()
    teacherClassrooms = cur.mogrify("SELECT classroom_name, classroom_id FROM classrooms JOIN accounts on classrooms.teacher_id = accounts.user_id WHERE user_id = %s;", (teacherID,))
    classrooms = getData(teacherClassrooms, conn)
    conn.close()
    return classrooms

# TODO: ADD AN ERROR CHECK IN NO CLASSROOMID
def requestClassroomData(classroomID):
    conn = createConnection()
    cur = conn.cursor()
    getClassroomQuery = cur.mogrify("SELECT user_full_name, level, num_correct  FROM classroom_student JOIN progress on classroom_student.student_id = progress.user_id JOIN accounts on classroom_student.student_id = accounts.user_id WHERE classroom_id = %s;", (classroomID,))
    classroom = getData(getClassroomQuery, conn)
    conn.close()
    return classroom


# Problem Screen methods

def getCurrentProgress(userID):
    '''
    Returns the last completed problem and current highest level for userID.
    '''
    conn = createConnection()
    cur = conn.cursor()
    query = cur.mogrify("SELECT level, problem_num, num_correct FROM progress WHERE user_id = %s;",(userID,))
    result = getData(query, conn)
    conn.close()
    return result

def chooseNextNum(level,lastCompleted):
    '''
    Gets the next problem number given the last completed problem and length of level.
    '''
    conn = createConnection()
    cur = conn.cursor()
    query = cur.mogrify("SELECT COUNT(*) FROM problems where level_num = %s;",(level,))
    result = getData(query,conn)
    conn.close()
    problemsInLevel = result['data'][0][0]
    nextnum = (lastCompleted % problemsInLevel)+1
    return nextnum

def getNextProblem(userID, level):
    '''
    Returns the text and problem number of the next problem for a given user and level.
    '''
    conn = createConnection()
    cur = conn.cursor()
    usertype = checkLogin(userID)['data'][0][0]
    currentProgress = getCurrentProgress(userID)['data'][0]
    lastCompleted = currentProgress[1]
    num = chooseNextNum(level,lastCompleted)
    query = cur.mogrify("SELECT problem_text, problem_num FROM problems WHERE level_num = %s and problem_num = %s;",(level,num))
    result = getData(query, conn)
    conn.close()
    return result

def updateProgress(userID, currentLevel, num, answerCorrect, skipProblem):
    '''
    Updates progress table after a user submits an answer or skips the question.
    '''
    conn = createConnection()
    cur = conn.cursor()
    currentProgress = getCurrentProgress(userID)['data'][0]
    maxlevel = currentProgress[0]
    currentLevel = int(currentLevel)
    consecCorrect = currentProgress[2]
    nextLevelUnlocked = "false"
    if skipProblem:
        query = cur.mogrify("UPDATE progress SET problem_num = %s, num_correct = 0 WHERE user_id = %s;",(num,userID))
    else:
        if answerCorrect:
            if currentLevel == maxlevel:
                if consecCorrect + 1 == 3:
                    nextLevelUnlocked = str(currentLevel+1)
                    query = cur.mogrify("UPDATE progress SET problem_num = %s, num_correct = 0, level = level+1 WHERE user_id = %s;",(num,userID,))
                else:
                    query = cur.mogrify("UPDATE progress SET problem_num = %s, num_correct = num_correct+1 WHERE user_id = %s;",(num,userID))
            else:
                query = cur.mogrify("UPDATE progress SET problem_num = %s WHERE user_id = %s;",(num,userID,))
        else:
            query = cur.mogrify("UPDATE progress SET num_correct = 0 WHERE user_id = %s;",(userID,))

    result = addDeleteData(query,conn)
    conn.close()
    return result, nextLevelUnlocked

def checkAnswer(userID, answer, level, num):
    '''
    Checks if an answer to a question is correct and calls updateProgress.
    '''
    conn = createConnection()
    cur = conn.cursor()
    currentProgress = getCurrentProgress(userID)['data'][0]
    consecCorrect = currentProgress[2]
    query = cur.mogrify("SELECT correct_answer FROM problems WHERE level_num = %s and problem_num = %s;",(level,num))
    result = getData(query,conn)
    correct_answer = result['data'][0][0] # compare student answer with correct answer
    if float(answer) == float(correct_answer):
        unlock = updateProgress(userID, level, num, True, False)[1]
        conn.close()
        return [{'isCorrect': "correct", 'nextLevelUnlocked': unlock}, result]
    else:
        updateProgress(userID, level, num, False, False)[0]
        conn.close()
        return [{'isCorrect': "incorrect", 'nextLevelUnlocked': "false"}, result]

if __name__ == '__main__':
    '''
    Test code for different queries
    '''
    #print requestClassroomData(76)
    #print requestTeacherDashInfo(102110987992000291959)
    '''for i in range(0, 9):
        id = 270 + i
        addAccount(id, "James Potter", "student")
        addStudentToClassroom(id, 76)
        query = "delete from progress where user_id = '{0}';".format(id)
        addDeleteData(query)
        query2 = "insert into progress values ('{0}', {1}, 0, {2});".format(id, 3, id % 3)
        addDeleteData(query2)'''
    '''returnedData = addClassroom("23", "420")
    print returnedData
    print addStudentToClassroom("test", returnedData['data'][0][1])
    print removeClassroom('345')
    print removeClassroom(returnedData['data'][0][1])'''
    print "Finished"
