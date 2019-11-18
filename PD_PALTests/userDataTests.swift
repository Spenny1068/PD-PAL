//
//  UserDataTests.swift
//  UserDataTests
//
//  Created by SpenC on 2019-10-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
Revision History
 
 - 26/10/2019 : William Xue
     Added simple database test, "testDatabase_insertion"
 - 01/11/2019 : William Huong
     Added Tests for UserData class.
 - 01/11/2019 : William Xue
     Moved testDatabase_insertion to it's own file
 - 01/11/2019 : William Huong
    Updated test for greater coverage
 - 01/11/2019 : William Huong
    Updated test_UserInfo()
 - 02/11/2019 : William Huong
    test_UserData_UserInfo() now checks state after calling Delete_userInfo()
 - 02/11/2019 : William Huong
    Changed test_UserInfo() for slightly better coverage
 - 02/11/2019 : William Huong
    Udated test_UserExerciseData() for Get_Exercise_All()
 - 11/11/2019 : William Huong
    Updated test_UserInfo() for UUID column
 - 14/11/2019 : William Huong
    Removed example performance test
 - 14/11/2019 : William Huong
    Updated test_UserInfo() for FirestoreOK column
 - 14/11/2019 : William Huong
    Added test_LastBackup()
 - 16/11/2019 : William Huong
    Updated test for LastBackup
 */


import XCTest
@testable import PD_PAL

class UserDataTests: XCTestCase {


    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //

    
/*
UserData Class Tests
*/
    
    func test_UserInfo() {
        
        //Create the object.
        let userDB = UserData()
        userDB.Clear_UserInfo_Database()
        userDB.Clear_Routines_Database()
        userDB.Clear_UserExerciseData_Database()
        userDB.Clear_StepCount_Database()
        
        //Check that User_Exists() returns false right now.
        XCTAssert( userDB.User_Exists() == false )
        
        //Check that the default values before inserting.
        var userData = userDB.Get_User_Data()
        
        //Grab the UUID, it should never change.
        let originalUUID = userData.UserUUID
        
        print("\(originalUUID)")
        
        XCTAssert( userData.UserUUID != "NULL" )
        XCTAssert( userData.UserName == "DEFAULT_NAME" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Provide just the user name.
        userDB.Update_User_Data(nameGiven: "Margaret", questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        
        //Check that User_Exists() returns true right now.
        XCTAssert( userDB.User_Exists() == true )
        
        //Get the user info
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Margaret" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Change some of the values to check we only update the values given.
        userDB.Update_User_Data(nameGiven: nil, questionsAnswered: true, walkingDuration: 30, chairAvailable: nil, weightsAvailable: true, resistBandAvailable: nil, poolAvailable: true, intensityDesired: nil, pushNotificationsDesired: true, firestoreOK: nil)
        
        userData = userDB.Get_User_Data()
        
        //Check values.
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Margaret" )
        XCTAssert( userData.QuestionsAnswered == true )
        XCTAssert( userData.WalkingDuration == 30 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == true )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == true )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == true )
        XCTAssert( userData.FirestoreOK == false )
        
        //Change the rest of the values.
        userDB.Update_User_Data(nameGiven: "Ebenezer Scrooge", questionsAnswered: false, walkingDuration: nil, chairAvailable: true, weightsAvailable: false, resistBandAvailable: true, poolAvailable: false, intensityDesired: "Intense", pushNotificationsDesired: false, firestoreOK: true)
        
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Ebenezer Scrooge" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 30 )
        XCTAssert( userData.ChairAccessible == true )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == true )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Intense" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == true )
        
        //Check Get_User_Data() returns the default values after deleting the user data. Important because of the way I have implemented this database.
        userDB.Delete_userInfo()
        
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Ebenezer Scrooge" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Check that User_Exists() returns false right now.
        XCTAssert( userDB.User_Exists() == true )
        
        //Call the clear function.
        userDB.Clear_UserInfo_Database()
        
        userData = userDB.Get_User_Data()
        
        //Clear_UserInfo_Database() is not meant to be used normally, so it will generate a new UUID on next read.
        XCTAssert( userData.UserUUID != "NULL" )
        XCTAssert( userData.UserName == "DEFAULT_NAME" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Check that User_Exists() returns false right now.
        XCTAssert( userDB.User_Exists() == false )
        
    }
    
    func test_UserInfo_Custom() {
        
        //Create the object.
        let userDB = UserData(DatabaseIdentifier: "UserInfo_Custom")
        userDB.Clear_UserInfo_Database()
        userDB.Clear_UserExerciseData_Database()
        userDB.Clear_StepCount_Database()
        
        //Check that User_Exists() returns false right now.
        XCTAssert( userDB.User_Exists() == false )
        
        //Check that the default values before inserting.
        var userData = userDB.Get_User_Data()
        
        //Grab the UUID, it should never change.
        let originalUUID = userData.UserUUID
        
        print("\(originalUUID)")
        
        XCTAssert( userData.UserUUID != "NULL" )
        XCTAssert( userData.UserName == "DEFAULT_NAME" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Provide just the user name.
        userDB.Update_User_Data(nameGiven: "Margaret", questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: nil)
        
        //Check that User_Exists() returns true right now.
        XCTAssert( userDB.User_Exists() == true )
        
        //Get the user info
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Margaret" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Change some of the values to check we only update the values given.
        userDB.Update_User_Data(nameGiven: nil, questionsAnswered: true, walkingDuration: 30, chairAvailable: nil, weightsAvailable: true, resistBandAvailable: nil, poolAvailable: true, intensityDesired: nil, pushNotificationsDesired: true, firestoreOK: nil)
        
        userData = userDB.Get_User_Data()
        
        //Check values.
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Margaret" )
        XCTAssert( userData.QuestionsAnswered == true )
        XCTAssert( userData.WalkingDuration == 30 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == true )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == true )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == true )
        XCTAssert( userData.FirestoreOK == false )
        
        //Change the rest of the values.
        userDB.Update_User_Data(nameGiven: "Ebenezer Scrooge", questionsAnswered: false, walkingDuration: nil, chairAvailable: true, weightsAvailable: false, resistBandAvailable: true, poolAvailable: false, intensityDesired: "Intense", pushNotificationsDesired: false, firestoreOK: true)
        
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Ebenezer Scrooge" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 30 )
        XCTAssert( userData.ChairAccessible == true )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == true )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Intense" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == true )
        
        //Check Get_User_Data() returns the default values after deleting the user data. Important because of the way I have implemented this database.
        userDB.Delete_userInfo()
        
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserUUID == originalUUID )
        XCTAssert( userData.UserName == "Ebenezer Scrooge" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Check that User_Exists() returns false right now.
        XCTAssert( userDB.User_Exists() == true )
        
        //Call the clear function.
        userDB.Clear_UserInfo_Database()
        
        userData = userDB.Get_User_Data()
        
        //Clear_UserInfo_Database() is not meant to be used normally, so it will generate a new UUID on next read.
        XCTAssert( userData.UserUUID != "NULL" )
        XCTAssert( userData.UserName == "DEFAULT_NAME" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        XCTAssert( userData.FirestoreOK == false )
        
        //Check that User_Exists() returns false right now.
        XCTAssert( userDB.User_Exists() == false )
        
    }
    
    func test_LastBackup() {
        
        //Use string comparison because the Date object is too precise.
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = "MMM d, yyyy, hh:mm:ss a"
        let defaultDateString = "Jan 1, 1000, 12:00:00 AM"
        
        let userData = UserData()
        
        //Check the default value is there
        var currentBackup = userData.Get_LastBackup()
        var userInfoBackup = dateFormatter.string(from: currentBackup.UserInfo)
        var routinesBackup = dateFormatter.string(from: currentBackup.Routines)
        var exerciseBackup = dateFormatter.string(from: currentBackup.Exercise)
        print("\(currentBackup)")
        XCTAssert( userInfoBackup == defaultDateString )
        XCTAssert( routinesBackup == defaultDateString )
        XCTAssert( exerciseBackup == defaultDateString )
        
        let currentDate = Date()
        let currentDateString = dateFormatter.string(from: currentDate)
        print("\(currentDate)")
        
        //Update the dates one by one and confirm it worked
        userData.Update_LastBackup(UserInfo: currentDate, Routines: nil, Exercise: nil)
        currentBackup = userData.Get_LastBackup()
        userInfoBackup = dateFormatter.string(from: currentBackup.UserInfo)
        routinesBackup = dateFormatter.string(from: currentBackup.Routines)
        exerciseBackup = dateFormatter.string(from: currentBackup.Exercise)
        print("\(currentBackup)")
        XCTAssert( userInfoBackup == currentDateString )
        XCTAssert( routinesBackup == defaultDateString )
        XCTAssert( exerciseBackup == defaultDateString )
        
        userData.Update_LastBackup(UserInfo: nil, Routines: currentDate, Exercise: nil)
        currentBackup = userData.Get_LastBackup()
        userInfoBackup = dateFormatter.string(from: currentBackup.UserInfo)
        routinesBackup = dateFormatter.string(from: currentBackup.Routines)
        exerciseBackup = dateFormatter.string(from: currentBackup.Exercise)
        print("\(currentBackup)")
        XCTAssert( userInfoBackup == currentDateString )
        XCTAssert( routinesBackup == currentDateString )
        XCTAssert( exerciseBackup == defaultDateString )
        
        userData.Update_LastBackup(UserInfo: nil, Routines: nil, Exercise: currentDate)
        currentBackup = userData.Get_LastBackup()
        userInfoBackup = dateFormatter.string(from: currentBackup.UserInfo)
        routinesBackup = dateFormatter.string(from: currentBackup.Routines)
        exerciseBackup = dateFormatter.string(from: currentBackup.Exercise)
        print("\(currentBackup)")
        XCTAssert( userInfoBackup == currentDateString )
        XCTAssert( routinesBackup == currentDateString )
        XCTAssert( exerciseBackup == currentDateString )
        
    }
    
    func test_Routines() {
        
        //Define some variables to test with
        let defaultRoutine1Name = "Happy Day Workout"
        let defaultRoutine2Name = "Friday Night Chill"
        let defaultRoutine3Name = "Monday Morning Mood"
        let routine1name = "Happy Days Workout"
        let routine2name = "Happier Days Workout"
        let nullRoutineName = "Immaginary Workout"
        
        let defaultRoutine1Exercises = ["WALL PUSH-UP", "WALKING", "SINGLE LEG STANCE"]
        let defaultRoutine2Exercises = ["WALKING", "WALKING", "WALKING"]
        let defaultRoutine3Exercises = ["WALL PUSH-UP", "WALL PUSH-UP", "WALL PUSH-UP"]
        let routine1exercises = ["Bicep Curls", "5 minute walk", "one legged stand"]
        let routine2exercises = ["squats", "sit ups", "bulgarian hamstring stretch", "whatever involved the chair"]
        
        let userData = UserData()
        userData.Clear_UserInfo_Database()
        userData.Clear_UserExerciseData_Database()
        userData.Clear_StepCount_Database()
        
        print("\(userData.Get_Routines())")
        
        //Due to file persistance, runnning this test a second time after clearing will remove the default routiens without replacing them
        if( userData.Get_Routines().isEmpty ) {
            //Add them back in for the sake of the test.
            print("The routines database is empty. Adding back in the default routines")
            userData.Add_Routine(NameOfRoutine: "Happy Day Workout", ExercisesIncluded: ["WALL PUSH-UP", "WALKING", "SINGLE LEG STANCE"])
            userData.Add_Routine(NameOfRoutine: "Friday Night Chill", ExercisesIncluded: ["WALKING", "WALKING", "WALKING"])
            userData.Add_Routine(NameOfRoutine: "Monday Morning Mood", ExercisesIncluded: ["WALL PUSH-UP", "WALL PUSH-UP", "WALL PUSH-UP"])
        } else {
            print("There are \(userData.Get_Routines().count) routines in the routines database")
        }
        
        //Confirm the database has the default routines, and that Get_Routine() and Get_Routines() work correctly.
        let initialRoutines = userData.Get_Routines()
        var nullRoutine = userData.Get_Routine(NameOfRoutine: nullRoutineName)
        var defaultRoutine1 = userData.Get_Routine(NameOfRoutine: defaultRoutine1Name)
        var defaultRoutine2 = userData.Get_Routine(NameOfRoutine: defaultRoutine2Name)
        var defaultRoutine3 = userData.Get_Routine(NameOfRoutine: defaultRoutine3Name)
        
        XCTAssert( initialRoutines.count == 3 )
        XCTAssert( initialRoutines[0].RoutineName == defaultRoutine1Name )
        XCTAssert( initialRoutines[0].Exercises == defaultRoutine1Exercises )
        XCTAssert( initialRoutines[1].RoutineName == defaultRoutine2Name )
        XCTAssert( initialRoutines[1].Exercises == defaultRoutine2Exercises )
        XCTAssert( initialRoutines[2].RoutineName == defaultRoutine3Name )
        XCTAssert( initialRoutines[2].Exercises == defaultRoutine3Exercises )
        
        XCTAssert( defaultRoutine1 == defaultRoutine1Exercises )
        XCTAssert( defaultRoutine2 == defaultRoutine2Exercises )
        XCTAssert( defaultRoutine3 == defaultRoutine3Exercises )
        XCTAssert( nullRoutine.isEmpty == true )
        
        //Insert our 2 routines
        userData.Add_Routine(NameOfRoutine: routine1name, ExercisesIncluded: routine1exercises)
        userData.Add_Routine(NameOfRoutine: routine2name, ExercisesIncluded: routine2exercises)
        
        //Confirm they were successfully added.
        let filledRoutines = userData.Get_Routines()
        nullRoutine = userData.Get_Routine(NameOfRoutine: nullRoutineName)
        defaultRoutine1 = userData.Get_Routine(NameOfRoutine: defaultRoutine1Name)
        defaultRoutine2 = userData.Get_Routine(NameOfRoutine: defaultRoutine2Name)
        defaultRoutine3 = userData.Get_Routine(NameOfRoutine: defaultRoutine3Name)
        let filledRoutine1 = userData.Get_Routine(NameOfRoutine: routine1name)
        let filledRoutine2 = userData.Get_Routine(NameOfRoutine: routine2name)
        
        XCTAssert( filledRoutines.count == 5 )
        XCTAssert( filledRoutines[0].RoutineName == defaultRoutine1Name )
        XCTAssert( filledRoutines[0].Exercises == defaultRoutine1Exercises )
        XCTAssert( filledRoutines[1].RoutineName == defaultRoutine2Name )
        XCTAssert( filledRoutines[1].Exercises == defaultRoutine2Exercises )
        XCTAssert( filledRoutines[2].RoutineName == defaultRoutine3Name )
        XCTAssert( filledRoutines[2].Exercises == defaultRoutine3Exercises )
        XCTAssert( filledRoutines[3].RoutineName == routine1name )
        XCTAssert( filledRoutines[3].Exercises == routine1exercises )
        XCTAssert( filledRoutines[4].RoutineName == routine2name )
        XCTAssert( filledRoutines[4].Exercises == routine2exercises )
        
        XCTAssert( defaultRoutine1 == defaultRoutine1Exercises )
        XCTAssert( defaultRoutine2 == defaultRoutine2Exercises )
        XCTAssert( defaultRoutine3 == defaultRoutine3Exercises )
        XCTAssert( filledRoutine1 == routine1exercises )
        XCTAssert( filledRoutine2 == routine2exercises )
        XCTAssert( nullRoutine.isEmpty == true )
        
        //Confirm deletion works.
        userData.Delete_Routine(NameOfRoutine: routine2name)
        
        //Confirm other 4 routines still exist
        let deletionRoutines = userData.Get_Routines()
        nullRoutine = userData.Get_Routine(NameOfRoutine: nullRoutineName)
        defaultRoutine1 = userData.Get_Routine(NameOfRoutine: defaultRoutine1Name)
        defaultRoutine2 = userData.Get_Routine(NameOfRoutine: defaultRoutine2Name)
        defaultRoutine3 = userData.Get_Routine(NameOfRoutine: defaultRoutine3Name)
        let deletionRoutine1 = userData.Get_Routine(NameOfRoutine: routine1name)
        let deletionRoutine2 = userData.Get_Routine(NameOfRoutine: routine2name)
        
        XCTAssert( deletionRoutines.count == 4 )
        XCTAssert( deletionRoutines[0].RoutineName == defaultRoutine1Name )
        XCTAssert( deletionRoutines[0].Exercises == defaultRoutine1Exercises )
        XCTAssert( deletionRoutines[1].RoutineName == defaultRoutine2Name )
        XCTAssert( deletionRoutines[1].Exercises == defaultRoutine2Exercises )
        XCTAssert( deletionRoutines[2].RoutineName == defaultRoutine3Name )
        XCTAssert( deletionRoutines[2].Exercises == defaultRoutine3Exercises )
        XCTAssert( deletionRoutines[3].RoutineName == routine1name )
        XCTAssert( deletionRoutines[3].Exercises == routine1exercises )
        
        XCTAssert( deletionRoutine1 == routine1exercises )
        XCTAssert( deletionRoutine2.isEmpty == true )
        
        //Call the clear function
        userData.Clear_Routines_Database()
        
        let clearedRoutines = userData.Get_Routines()
        nullRoutine = userData.Get_Routine(NameOfRoutine: nullRoutineName)
        defaultRoutine1 = userData.Get_Routine(NameOfRoutine: defaultRoutine1Name)
        defaultRoutine2 = userData.Get_Routine(NameOfRoutine: defaultRoutine2Name)
        defaultRoutine3 = userData.Get_Routine(NameOfRoutine: defaultRoutine3Name)
        let clearedRoutine1 = userData.Get_Routine(NameOfRoutine: routine1name)
        let clearedRoutine2 = userData.Get_Routine(NameOfRoutine: routine2name)
        let clearedRoutineNull = userData.Get_Routine(NameOfRoutine: nullRoutineName)
        
        XCTAssert( clearedRoutines.isEmpty == true )
        XCTAssert( defaultRoutine1.isEmpty == true )
        XCTAssert( defaultRoutine2.isEmpty == true )
        XCTAssert( defaultRoutine3.isEmpty == true )
        XCTAssert( clearedRoutine1.isEmpty == true )
        XCTAssert( clearedRoutine2.isEmpty == true )
        XCTAssert( clearedRoutineNull.isEmpty == true )
        
    }
    
    func test_UserExerciseData() {
        
        //Define some variables to test with. Defined so that we can have an exercise done twice in the same hour, multiple difference exercise the same hour, same exercise on two different days
        let targetYear1 = 2019
        let targetMonth1 = 11
        let targetDay1 = 01
        let targetHour1 = 13
        
        let targetYear2 = 2018
        let targetMonth2 = 10
        let targetDay2 = 31
        let targetHour2 = 15
        
        let nullYear = 2017
        let nullMonth = 12
        let nullDay = 17
        let nullHour = 09
        
        let firstName = "Bicep Curls"
        let firstYear = targetYear1
        let firstMonth = targetMonth1
        let firstDay = targetDay1
        let firstHour = targetHour1
        
        let secondName = "Bicep Curls"
        let secondYear = targetYear1
        let secondMonth = targetMonth1
        let secondDay = targetDay1
        let secondHour = targetHour1
        
        let thirdName = "Squats"
        let thirdYear = targetYear1
        let thirdMonth = targetMonth1
        let thirdDay = targetDay1
        let thirdHour = targetHour1
        
        let fourthName = "Bicep Curls"
        let fourthYear = targetYear2
        let fourthMonth = targetMonth2
        let fourthDay = targetDay2
        let fourthHour = targetHour2
        
        let userData = UserData()
        userData.Clear_UserInfo_Database()
        userData.Clear_UserExerciseData_Database()
        userData.Clear_StepCount_Database()
        
        //Make sure there aren't any exercies already in place, and that Get_Exercises() behaves as expected when nothing is found.
        let emptyDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let emptyDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        
        XCTAssert( emptyDay1.isEmpty == true )
        XCTAssert( emptyDay2.isEmpty == true )
        
        //Insert our exercises and confirm
        userData.Add_Exercise_Done(ExerciseName: firstName, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        
        let insert1Day1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let insert1Day2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let insert1Null = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( insert1Day1 == ["Bicep Curls"] )
        XCTAssert( insert1Day2.isEmpty == true )
        XCTAssert( insert1Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: secondName, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let insert2Day1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let insert2Day2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let insert2Null = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( insert2Day1 == ["Bicep Curls", "Bicep Curls"] )
        XCTAssert( insert2Day2.isEmpty == true )
        XCTAssert( insert2Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: thirdName, YearDone: thirdYear, MonthDone: thirdMonth, DayDone: thirdDay, HourDone: thirdHour)
        
        let insert3Day1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let insert3Day2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let insert3Null = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( insert3Day1 == ["Bicep Curls", "Bicep Curls", "Squats"] )
        XCTAssert( insert3Day2.isEmpty == true )
        XCTAssert( insert3Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: fourthName, YearDone: fourthYear, MonthDone: fourthMonth, DayDone: fourthDay, HourDone: fourthHour)
        
        let filledDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let filledDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let filledNull = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( filledDay1 == ["Bicep Curls","Bicep Curls","Squats"] )
        XCTAssert( filledDay2 == ["Bicep Curls"] )
        XCTAssert( filledNull.isEmpty == true )
        
        //Check Get_Exercise_All() works
        
        let allExercises = userData.Get_Exercises_all()
        
        XCTAssert( allExercises.count == 4 )
        
        XCTAssert( allExercises[0].nameOfExercise == firstName)
        XCTAssert( allExercises[0].Year == firstYear )
        XCTAssert( allExercises[0].Month == firstMonth )
        XCTAssert( allExercises[0].Day == firstDay )
        XCTAssert( allExercises[0].Hour == firstHour )
        
        XCTAssert( allExercises[1].nameOfExercise == secondName)
        XCTAssert( allExercises[1].Year == secondYear )
        XCTAssert( allExercises[1].Month == secondMonth )
        XCTAssert( allExercises[1].Day == secondDay )
        XCTAssert( allExercises[1].Hour == secondHour )
        
        XCTAssert( allExercises[2].nameOfExercise == thirdName)
        XCTAssert( allExercises[2].Year == thirdYear )
        XCTAssert( allExercises[2].Month == thirdMonth )
        XCTAssert( allExercises[2].Day == thirdDay )
        XCTAssert( allExercises[2].Hour == thirdHour )
        
        XCTAssert( allExercises[3].nameOfExercise == fourthName)
        XCTAssert( allExercises[3].Year == fourthYear )
        XCTAssert( allExercises[3].Month == fourthMonth )
        XCTAssert( allExercises[3].Day == fourthDay )
        XCTAssert( allExercises[3].Hour == fourthHour )
        
        //Delete an exercise and confirm
        userData.Delete_Exercise_Done(ExerciseName: "Squats", YearDone: targetYear1, MonthDone: targetMonth1, DayDone: targetDay1, HourDone: targetHour1)
        
        let deletedDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let deletedDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let deletedNull = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( deletedDay1 == ["Bicep Curls","Bicep Curls"] )
        XCTAssert( deletedDay2 == ["Bicep Curls"] )
        XCTAssert( deletedNull.isEmpty == true )
        
        //Call clear function
        userData.Clear_UserExerciseData_Database()
        
        let clearedDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let clearedDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let clearedNull = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert(clearedDay1.isEmpty == true )
        XCTAssert(clearedDay2.isEmpty == true )
        XCTAssert(clearedNull.isEmpty == true )
        
    }
    
    func test_UserExerciseData_Custom() {
        
        //Define some variables to test with. Defined so that we can have an exercise done twice in the same hour, multiple difference exercise the same hour, same exercise on two different days
        let targetYear1 = 2019
        let targetMonth1 = 11
        let targetDay1 = 01
        let targetHour1 = 13
        
        let targetYear2 = 2018
        let targetMonth2 = 10
        let targetDay2 = 31
        let targetHour2 = 15
        
        let nullYear = 2017
        let nullMonth = 12
        let nullDay = 17
        let nullHour = 09
        
        let firstName = "Bicep Curls"
        let firstYear = targetYear1
        let firstMonth = targetMonth1
        let firstDay = targetDay1
        let firstHour = targetHour1
        
        let secondName = "Bicep Curls"
        let secondYear = targetYear1
        let secondMonth = targetMonth1
        let secondDay = targetDay1
        let secondHour = targetHour1
        
        let thirdName = "Squats"
        let thirdYear = targetYear1
        let thirdMonth = targetMonth1
        let thirdDay = targetDay1
        let thirdHour = targetHour1
        
        let fourthName = "Bicep Curls"
        let fourthYear = targetYear2
        let fourthMonth = targetMonth2
        let fourthDay = targetDay2
        let fourthHour = targetHour2
        
        let userData = UserData(DatabaseIdentifier: "UserExerciseData_Custom")
        userData.Clear_UserInfo_Database()
        userData.Clear_UserExerciseData_Database()
        userData.Clear_StepCount_Database()
        
        //Make sure there aren't any exercies already in place, and that Get_Exercises() behaves as expected when nothing is found.
        let emptyDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let emptyDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        
        XCTAssert( emptyDay1.isEmpty == true )
        XCTAssert( emptyDay2.isEmpty == true )
        
        //Insert our exercises and confirm
        userData.Add_Exercise_Done(ExerciseName: firstName, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        
        let insert1Day1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let insert1Day2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let insert1Null = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( insert1Day1 == ["Bicep Curls"] )
        XCTAssert( insert1Day2.isEmpty == true )
        XCTAssert( insert1Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: secondName, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let insert2Day1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let insert2Day2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let insert2Null = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( insert2Day1 == ["Bicep Curls", "Bicep Curls"] )
        XCTAssert( insert2Day2.isEmpty == true )
        XCTAssert( insert2Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: thirdName, YearDone: thirdYear, MonthDone: thirdMonth, DayDone: thirdDay, HourDone: thirdHour)
        
        let insert3Day1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let insert3Day2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let insert3Null = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( insert3Day1 == ["Bicep Curls", "Bicep Curls", "Squats"] )
        XCTAssert( insert3Day2.isEmpty == true )
        XCTAssert( insert3Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: fourthName, YearDone: fourthYear, MonthDone: fourthMonth, DayDone: fourthDay, HourDone: fourthHour)
        
        let filledDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let filledDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let filledNull = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( filledDay1 == ["Bicep Curls","Bicep Curls","Squats"] )
        XCTAssert( filledDay2 == ["Bicep Curls"] )
        XCTAssert( filledNull.isEmpty == true )
        
        //Check Get_Exercise_All() works
        
        let allExercises = userData.Get_Exercises_all()
        
        XCTAssert( allExercises.count == 4 )
        
        XCTAssert( allExercises[0].nameOfExercise == firstName)
        XCTAssert( allExercises[0].Year == firstYear )
        XCTAssert( allExercises[0].Month == firstMonth )
        XCTAssert( allExercises[0].Day == firstDay )
        XCTAssert( allExercises[0].Hour == firstHour )
        
        XCTAssert( allExercises[1].nameOfExercise == secondName)
        XCTAssert( allExercises[1].Year == secondYear )
        XCTAssert( allExercises[1].Month == secondMonth )
        XCTAssert( allExercises[1].Day == secondDay )
        XCTAssert( allExercises[1].Hour == secondHour )
        
        XCTAssert( allExercises[2].nameOfExercise == thirdName)
        XCTAssert( allExercises[2].Year == thirdYear )
        XCTAssert( allExercises[2].Month == thirdMonth )
        XCTAssert( allExercises[2].Day == thirdDay )
        XCTAssert( allExercises[2].Hour == thirdHour )
        
        XCTAssert( allExercises[3].nameOfExercise == fourthName)
        XCTAssert( allExercises[3].Year == fourthYear )
        XCTAssert( allExercises[3].Month == fourthMonth )
        XCTAssert( allExercises[3].Day == fourthDay )
        XCTAssert( allExercises[3].Hour == fourthHour )
        
        //Delete an exercise and confirm
        userData.Delete_Exercise_Done(ExerciseName: "Squats", YearDone: targetYear1, MonthDone: targetMonth1, DayDone: targetDay1, HourDone: targetHour1)
        
        let deletedDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let deletedDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let deletedNull = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( deletedDay1 == ["Bicep Curls","Bicep Curls"] )
        XCTAssert( deletedDay2 == ["Bicep Curls"] )
        XCTAssert( deletedNull.isEmpty == true )
        
        //Call clear function
        userData.Clear_UserExerciseData_Database()
        
        let clearedDay1 = userData.Get_Exercises(TargetYear: targetYear1, TargetMonth: targetMonth1, TargetDay: targetDay1, TargetHour: targetHour1)
        let clearedDay2 = userData.Get_Exercises(TargetYear: targetYear2, TargetMonth: targetMonth2, TargetDay: targetDay2, TargetHour: targetHour2)
        let clearedNull = userData.Get_Exercises(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert(clearedDay1.isEmpty == true )
        XCTAssert(clearedDay2.isEmpty == true )
        XCTAssert(clearedNull.isEmpty == true )
        
    }
    
    func test_StepCount() {
        
        //Declare some vaiables to use
        let firstSteps1 = Int64(1337)
        let firstSteps2 = Int64(404)
        let firstStepsIncrement = Int64(9000)
        let firstYear = 2019
        let firstMonth = 10
        let firstDay = 31
        let firstHour = 12
        
        let secondSteps1 = Int64(7887)
        let secondSteps2 = Int64(818)
        let secondStepsIncrement = Int64(604)
        let secondYear = 2020
        let secondMonth = 11
        let secondDay = 01
        let secondHour = 03
        
        let nullYear = 2017
        let nullMonth = 01
        let nullDay = 02
        let nullHour = 00
        
        let userData = UserData()
        userData.Clear_UserInfo_Database()
        userData.Clear_Routines_Database()
        userData.Clear_UserExerciseData_Database()
        userData.Clear_StepCount_Database()
        
        //Confirm nothing is in the target rows currently
        let firstEmpty = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let secondEmpty = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        
        XCTAssert( firstEmpty == 0 )
        XCTAssert( secondEmpty == 0 )
        
        //Insert and confirm
        userData.Update_Steps_Taken(Steps: firstSteps1, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Update_Steps_Taken(Steps: secondSteps1, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let first1 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second1 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null1 = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( first1 == firstSteps1 )
        XCTAssert( second1 == secondSteps1 )
        XCTAssert( null1 == 0 )
        
        //Modify the values and confirm again
        userData.Update_Steps_Taken(Steps: firstSteps2, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Update_Steps_Taken(Steps: secondSteps2, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let first2 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second2 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null2 = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( first2 == firstSteps2 )
        XCTAssert( second2 == secondSteps2 )
        XCTAssert( null2 == 0 )
        
        //Confirm the deletion of an item
        userData.Delete_Steps_Taken(YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        
        let first3 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second3 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null3 = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( first3 == 0 )
        XCTAssert( second3 == secondSteps2 )
        XCTAssert( null3 == 0 )
        
        //Confirm increment works
        userData.Increment_Steps_Taken(Steps: firstStepsIncrement, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Increment_Steps_Taken(Steps: secondStepsIncrement, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let firstIncrement = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let secondIncrement = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let nullIncrement = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( firstIncrement == first3 + firstStepsIncrement )
        XCTAssert( secondIncrement == second3 + secondStepsIncrement )
        XCTAssert( nullIncrement == 0 )
        
        //Call clear function
        userData.Clear_StepCount_Database()
        
        let firstCleared = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstDay)
        let secondCleared = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondDay)
        let nullCleared = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( firstCleared == 0 )
        XCTAssert( secondCleared == 0 )
        XCTAssert( nullCleared == 0 )
        
    }
    
    func test_StepCount_Custom() {
        
        //Declare some vaiables to use
        let firstSteps1 = Int64(1337)
        let firstSteps2 = Int64(404)
        let firstStepsIncrement = Int64(9000)
        let firstYear = 2019
        let firstMonth = 10
        let firstDay = 31
        let firstHour = 12
        
        let secondSteps1 = Int64(7887)
        let secondSteps2 = Int64(818)
        let secondStepsIncrement = Int64(604)
        let secondYear = 2020
        let secondMonth = 11
        let secondDay = 01
        let secondHour = 03
        
        let nullYear = 2017
        let nullMonth = 01
        let nullDay = 02
        let nullHour = 00
        
        let userData = UserData(DatabaseIdentifier: "StepCount_Custom")
        userData.Clear_UserInfo_Database()
        userData.Clear_Routines_Database()
        userData.Clear_UserExerciseData_Database()
        userData.Clear_StepCount_Database()
        
        //Confirm nothing is in the target rows currently
        let firstEmpty = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let secondEmpty = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        
        XCTAssert( firstEmpty == 0 )
        XCTAssert( secondEmpty == 0 )
        
        //Insert and confirm
        userData.Update_Steps_Taken(Steps: firstSteps1, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Update_Steps_Taken(Steps: secondSteps1, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let first1 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second1 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null1 = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( first1 == firstSteps1 )
        XCTAssert( second1 == secondSteps1 )
        XCTAssert( null1 == 0 )
        
        //Modify the values and confirm again
        userData.Update_Steps_Taken(Steps: firstSteps2, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Update_Steps_Taken(Steps: secondSteps2, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let first2 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second2 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null2 = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( first2 == firstSteps2 )
        XCTAssert( second2 == secondSteps2 )
        XCTAssert( null2 == 0 )
        
        //Confirm the deletion of an item
        userData.Delete_Steps_Taken(YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        
        let first3 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second3 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null3 = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( first3 == 0 )
        XCTAssert( second3 == secondSteps2 )
        XCTAssert( null3 == 0 )
        
        //Confirm increment works
        userData.Increment_Steps_Taken(Steps: firstStepsIncrement, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Increment_Steps_Taken(Steps: secondStepsIncrement, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let firstIncrement = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let secondIncrement = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let nullIncrement = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( firstIncrement == first3 + firstStepsIncrement )
        XCTAssert( secondIncrement == second3 + secondStepsIncrement )
        XCTAssert( nullIncrement == 0 )
        
        //Call clear function
        userData.Clear_StepCount_Database()
        
        let firstCleared = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstDay)
        let secondCleared = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondDay)
        let nullCleared = userData.Get_Steps_Taken(TargetYear: nullYear, TargetMonth: nullMonth, TargetDay: nullDay, TargetHour: nullHour)
        
        XCTAssert( firstCleared == 0 )
        XCTAssert( secondCleared == 0 )
        XCTAssert( nullCleared == 0 )
        
    }
    
    func test_UserName_Check() {
        
        let userData = UserData()
        userData.Clear_UserInfo_Database()
        userData.Clear_Routines_Database()
        userData.Clear_UserExerciseData_Database()
        userData.Clear_StepCount_Database()
        
        //Confirm a name in use returns false
        let firstExp = expectation(description: "Name taken")
        DispatchQueue.main.async {
            
            userData.Name_Available(desiredName: "tester") { returnVal in
                XCTAssert( returnVal == false )
            }
            
            firstExp.fulfill()
            
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        //Confurm a name that is not in use returns true
        let secondExp = expectation(description: "Name available")
        DispatchQueue.main.async {
            
            userData.Name_Available(desiredName: "non existant user") { returnVal in
                XCTAssert( returnVal == true )
            }
            
            secondExp.fulfill()
            
        }
        waitForExpectations(timeout: 10, handler: nil)
        
    }

}
