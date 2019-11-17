//
//  UserDataFirestoreTests.swift
//  PD_PALTests
//
//  Created by William Huong on 2019-11-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
Revision History
 
 - 11/11/2019 : William Huong
    Created file, read test
 - 15/11/2019 : William Huong
    Implemented test for UserInfo update
 - 16/11/2019 : William Huong
    Implemented tests for Get_Routines() and Get_ExerciseData()
 - 16/11/2019 : William Huong
    Updated tests to handle asynchronous nature of functions
 */

/*
Known Bugs
 
 -16/11/2019 : William Huong --- Fixed
    The functions being tested are asynchronous, so it is possible for any test function to return before an XTCAssert() has had a chance to throw.
    When an XTCAssert() throws after the function it is inside of has already returned, we get a hard SIGABRT error which crashes the app.
*/

import XCTest
import Firebase
@testable import PD_PAL

class UserDataFirestoreTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_FullUpdate() {
        
        //Set some values for our user.
        global_UserData.Update_User_Data(nameGiven: "tester", questionsAnswered: true, walkingDuration: 15, chairAvailable: true, weightsAvailable: false, resistBandAvailable: true, poolAvailable: false, intensityDesired: "Light", pushNotificationsDesired: true, firestoreOK: false)
        
        //Confirm the update does not go through when FirestoreOK == false
        let noAuth = global_UserDataFirestore.Update_Firebase(DayFrequency: 0, HourFrequency: 0, MinuteFrequency: 0, SecondFrequency: 0)
        
        XCTAssert( noAuth == "NO_AUTH" )
        
        //Allow Firestore uploads
        global_UserData.Update_User_Data(nameGiven: nil, questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil, firestoreOK: true)
        
        //Set the last updated time to right now to confirm that the update does not go through if we have not passed enough time
        
        global_UserData.Update_LastBackup(backupDate: Date())
        
        let noSchedule = global_UserDataFirestore.Update_Firebase(DayFrequency: 1, HourFrequency: 0, MinuteFrequency: 0, SecondFrequency: 0)
        
        XCTAssert( noSchedule == "NO_SCHEDULE" )
        
    }
    
    func test_UserInfoReader() {
        
        let nullUserAsyncExpectation = expectation(description: "Get_UserInfo(\"nullUser\") async block started")
        DispatchQueue.main.async {
            
            //Check reading a non-existant user returns as expected
            global_UserDataFirestore.Get_UserInfo(targetUser: "nullUser") { remoteUserData in
                XCTAssert( remoteUserData.UserUUID == "NO_DOCUMENT" )
                XCTAssert( remoteUserData.UserName == "DEFAULT_NAME" )
                XCTAssert( remoteUserData.QuestionsAnswered == false )
                XCTAssert( remoteUserData.WalkingDuration == 0 )
                XCTAssert( remoteUserData.ChairAccessible == false )
                XCTAssert( remoteUserData.WeightsAccessible == false )
                XCTAssert( remoteUserData.ResistBandAccessible == false )
                XCTAssert( remoteUserData.PoolAccessible == false )
                XCTAssert( remoteUserData.Intensity == "Light" )
                XCTAssert( remoteUserData.PushNotifications == false )
            }
            
            nullUserAsyncExpectation.fulfill()
        }
        
        let emptyAsyncExpectation = expectation(description: "Get_UserInfo(\"Empty\") async block started")
        DispatchQueue.main.async {
            
            //Check reading an empty user returns as expected
            global_UserDataFirestore.Get_UserInfo(targetUser: "Empty") { remoteUserData in
                XCTAssert( remoteUserData.UserUUID == "Empty" )
                XCTAssert( remoteUserData.UserName == "USERNAME_NIL" )
                XCTAssert( remoteUserData.QuestionsAnswered == false )
                XCTAssert( remoteUserData.WalkingDuration == -1 )
                XCTAssert( remoteUserData.ChairAccessible == false )
                XCTAssert( remoteUserData.WeightsAccessible == false )
                XCTAssert( remoteUserData.ResistBandAccessible == false )
                XCTAssert( remoteUserData.PoolAccessible == false )
                XCTAssert( remoteUserData.Intensity == "INTENSITY_NIL" )
                XCTAssert( remoteUserData.PushNotifications == false )
            }
            
            emptyAsyncExpectation.fulfill()
        }
        
        let testerAsyncExpectation = expectation(description: "Get_UserInfo(\"tester\") async block started")
        DispatchQueue.main.async {
            
            //Check reading a properly filled user returns as expected
            global_UserDataFirestore.Get_UserInfo(targetUser: "tester") { remoteUserData in
                //These values are pre-defined in the Firestore.
                XCTAssert( remoteUserData.UserUUID == "tester" )
                XCTAssert( remoteUserData.UserName == "Tester" )
                XCTAssert( remoteUserData.QuestionsAnswered == true )
                XCTAssert( remoteUserData.WalkingDuration == 15 )
                XCTAssert( remoteUserData.ChairAccessible == true )
                XCTAssert( remoteUserData.WeightsAccessible == true )
                XCTAssert( remoteUserData.ResistBandAccessible == true )
                XCTAssert( remoteUserData.PoolAccessible == true )
                XCTAssert( remoteUserData.Intensity == "Moderate" )
                XCTAssert( remoteUserData.PushNotifications == true )
            }
            
            testerAsyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)

    }
    
    func test_Get_Routines() {
        
        let nullUserAsyncExpectation = expectation(description: "Get_Routines(\"nullUser\") async block started")
        DispatchQueue.main.async {
            
            //Check reading a non-existant user returns as expected
            global_UserDataFirestore.Get_Routines(targetUser: "nullUser") { remoteRoutineData in
                XCTAssert( remoteRoutineData.isEmpty == true )
            }
            
            nullUserAsyncExpectation.fulfill()
        }
        
        let emptyAsyncExpectation = expectation(description: "Get_Routines(\"Empty\") async block started")
        DispatchQueue.main.async {
            
            //Check that reading an empty user returns as expected
            global_UserDataFirestore.Get_Routines(targetUser: "Empty") { remoteRoutineData in
                XCTAssert( remoteRoutineData.isEmpty == true )
            }
            
            emptyAsyncExpectation.fulfill()
        }
        
        let testerAsyncExpectation = expectation(description: "Get_Routines(\"tester\") async block started")
        DispatchQueue.main.async {
            
            //Check that reading a properly filled user returns as expected
            global_UserDataFirestore.Get_Routines(targetUser: "tester") { remoteRoutineData in
                XCTAssert( remoteRoutineData.count == 2 )
                XCTAssert( remoteRoutineData[0].RoutineName == "Happy Day Workout" )
                XCTAssert( remoteRoutineData[0].RoutineContents == ["Walking", "Wall Push-up", "Single Leg Stance"] )
                XCTAssert( remoteRoutineData[1].RoutineName == "Friday Night Chill" )
                XCTAssert( remoteRoutineData[1].RoutineContents == ["Quad Stretch", "Single Leg Stance", "Walking"] )
            }
            
            testerAsyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)

    }
    
    func test_Get_ExercisesData() {
        
        let nullUserAsynExpectation = expectation(description: "Get_ExerciseData(\"nullUser\") async block started")
        DispatchQueue.main.async {
            
            global_UserDataFirestore.Get_ExerciseData(targetUser: "nullUser") { remoteExerciseData in
                XCTAssert( remoteExerciseData.isEmpty == true )
            }
            
            nullUserAsynExpectation.fulfill()
        }
        
        let emptyAsynExpectation = expectation(description: "Get_ExerciseData(\"Empty\") async block started")
        DispatchQueue.main.async {
            
            global_UserDataFirestore.Get_ExerciseData(targetUser: "Empty") { remoteExerciseData in
                XCTAssert( remoteExerciseData.isEmpty == true )
            }
            
            emptyAsynExpectation.fulfill()
        }
        
        let testerAsynExpectation = expectation(description: "Get_ExerciseData(\"tester\") async block started")
        DispatchQueue.main.async {
            
            global_UserDataFirestore.Get_ExerciseData(targetUser: "target") { remoteExerciseData in
                XCTAssert( remoteExerciseData.count == 2 )
                XCTAssert( remoteExerciseData[0].Year == 2018 )
                XCTAssert( remoteExerciseData[0].Month == 10 )
                XCTAssert( remoteExerciseData[0].Day == 31 )
                XCTAssert( remoteExerciseData[0].Hour == 13 )
                XCTAssert( remoteExerciseData[0].ExercisesDone == ["Bicep Curls", "One Legged Stand", "Bicep Curls"] )
                XCTAssert( remoteExerciseData[0].StepsTaken == 123 )
                XCTAssert( remoteExerciseData[1].Year == 2019 )
                XCTAssert( remoteExerciseData[1].Month == 11 )
                XCTAssert( remoteExerciseData[1].Day == 12 )
                XCTAssert( remoteExerciseData[1].Hour == 15 )
                XCTAssert( remoteExerciseData[1].ExercisesDone == ["Squats", "Sit Ups", "Whatever Involves a Chair"] )
                XCTAssert( remoteExerciseData[1].StepsTaken == 456 )
            }
            
            testerAsynExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func test_UserInfo() {
        
        //Set some values for our user.
        global_UserData.Update_User_Data(nameGiven: "UserInfoTester", questionsAnswered: true, walkingDuration: 15, chairAvailable: true, weightsAvailable: false, resistBandAvailable: true, poolAvailable: false, intensityDesired: "Light", pushNotificationsDesired: true, firestoreOK: true)
        
        let nullUserAsyncExpectation = expectation(description: "Get_UserInfo() on non-existant user asnyc block started")
        DispatchQueue.main.async {
            
            //At this point we should not have a user available. Confirm
            global_UserDataFirestore.Get_UserInfo(targetUser: global_UserData.Get_User_Data().UserUUID) { remoteUserData in
                XCTAssert( remoteUserData.UserUUID == "NO_DOCUMENT")
            }
            
            nullUserAsyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        
        let firstInsertAsnycExpectation = expectation(description: "Initial Update_UserInfo() asnyc block started")
        DispatchQueue.main.async {
            
            //Add the user to Firestore
            global_UserDataFirestore.Update_UserInfo() { returnVal in
                XCTAssert( returnVal == 0 )
            }
            
            firstInsertAsnycExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        let firstReadAsyncExpectation = expectation(description: "First Get_UserInfo() async block started")
        DispatchQueue.main.async {
            
            //Confirm the the user was uploaded to Firestore
            global_UserDataFirestore.Get_UserInfo(targetUser: nil) { remoteUserData in
                XCTAssert( remoteUserData.UserName == global_UserData.Get_User_Data().UserName )
                XCTAssert( remoteUserData.QuestionsAnswered == global_UserData.Get_User_Data().QuestionsAnswered )
                XCTAssert( remoteUserData.WalkingDuration == global_UserData.Get_User_Data().WalkingDuration )
                XCTAssert( remoteUserData.ChairAccessible == global_UserData.Get_User_Data().ChairAccessible )
                XCTAssert( remoteUserData.WeightsAccessible == global_UserData.Get_User_Data().WeightsAccessible )
                XCTAssert( remoteUserData.ResistBandAccessible == global_UserData.Get_User_Data().ResistBandAccessible )
                XCTAssert( remoteUserData.PoolAccessible == global_UserData.Get_User_Data().PoolAccessible )
                XCTAssert( remoteUserData.Intensity == global_UserData.Get_User_Data().Intensity )
                XCTAssert( remoteUserData.PushNotifications == global_UserData.Get_User_Data().PushNotifications )
            }
            
            firstReadAsyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        //Update UserInfo
        global_UserData.Update_User_Data(nameGiven: "UserInfoTester2", questionsAnswered: true, walkingDuration: 20, chairAvailable: false, weightsAvailable: false, resistBandAvailable: false, poolAvailable: false, intensityDesired: "Moderate", pushNotificationsDesired: true, firestoreOK: true)
        
        let secondInsertAsyncExpectation = expectation(description: "Second Update_UserInfo() async block started")
        DispatchQueue.main.async {
            
            //Update the user in Firestore
            global_UserDataFirestore.Update_UserInfo() { returnVal in
                XCTAssert( returnVal == 0 )
            }
            
            secondInsertAsyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        let secondReadAsyncExpectation = expectation(description: "Second Get_UserInfo() async block started")
        DispatchQueue.main.async {
            
            //Confirm the update went through
            global_UserDataFirestore.Get_UserInfo(targetUser: nil) { remoteUserData in
                XCTAssert( remoteUserData.UserName == global_UserData.Get_User_Data().UserName )
                XCTAssert( remoteUserData.QuestionsAnswered == global_UserData.Get_User_Data().QuestionsAnswered )
                XCTAssert( remoteUserData.WalkingDuration == global_UserData.Get_User_Data().WalkingDuration )
                XCTAssert( remoteUserData.ChairAccessible == global_UserData.Get_User_Data().ChairAccessible )
                XCTAssert( remoteUserData.WeightsAccessible == global_UserData.Get_User_Data().WeightsAccessible )
                XCTAssert( remoteUserData.ResistBandAccessible == global_UserData.Get_User_Data().ResistBandAccessible )
                XCTAssert( remoteUserData.PoolAccessible == global_UserData.Get_User_Data().PoolAccessible )
                XCTAssert( remoteUserData.Intensity == global_UserData.Get_User_Data().Intensity )
                XCTAssert( remoteUserData.PushNotifications == global_UserData.Get_User_Data().PushNotifications )
            }
            
            secondReadAsyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

    }
    
}
