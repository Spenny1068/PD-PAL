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
 - 16/11/2019 : William Huong
    Implemented test for Update_Routines()
 - 17/11/2019 : William Huong
    Each test method now uses its own instance of the UserData class
 */

/*
Known Bugs
 
 - 16/11/2019 : William Huong --- Fixed
    The functions being tested are asynchronous, so it is possible for any test function to return before an XTCAssert() has had a chance to throw.
    When an XTCAssert() throws after the function it is inside of has already returned, we get a hard SIGABRT error which crashes the app.
 - 17/11/2019 : William Huong
    The test methods all start at the same time, but also all use the global_UserData instance of the UserData class. This causes an issue where some functions will not do anything because a different test method cleared the database.
 - 17/11/2019 : William Huong
    Get_Routines(), Get_ExerciseData(), Routines() all throw an error : API violation - multiple calls made to -[XCTestExpectation fulfill]
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
    
    func test_Get_UserInfo() {
        
        //Initialize a new UserData class that only this method will interact with, along with a UserDataFirestore class using that Database
        let Get_UserInfoDB = UserData(DatabaseIdentifier: "Get_UserInfo")
        let Get_UserInfoFirestore = UserDataFirestore(sourceGiven: Get_UserInfoDB)
        
        var nullUserAsyncExpectation: XCTestExpectation? = expectation(description: "Get_UserInfo(\"nullUser\") async block started")
        DispatchQueue.main.async {
            
            //Check reading a non-existant user returns as expected
            Get_UserInfoFirestore.Get_UserInfo(targetUser: "nullUser") { remoteUserData in
                XCTAssert( remoteUserData.Status == "NO_DOCUMENT" )
                XCTAssert( remoteUserData.UserName == "DEFAULT_NAME" )
                XCTAssert( remoteUserData.QuestionsAnswered == false )
                XCTAssert( remoteUserData.WalkingDuration == 0 )
                XCTAssert( remoteUserData.ChairAccessible == false )
                XCTAssert( remoteUserData.WeightsAccessible == false )
                XCTAssert( remoteUserData.ResistBandAccessible == false )
                XCTAssert( remoteUserData.PoolAccessible == false )
                XCTAssert( remoteUserData.Intensity == "Light" )
                XCTAssert( remoteUserData.PushNotifications == false )
                
                nullUserAsyncExpectation?.fulfill()
                nullUserAsyncExpectation = nil
            }
            
        }
        
        var emptyUserAsyncExpectation: XCTestExpectation? = expectation(description: "Get_UserInfo(\"Empty\") async block started")
        DispatchQueue.main.async {
            
            //Check reading an empty user returns as expected
            Get_UserInfoFirestore.Get_UserInfo(targetUser: "Empty") { remoteUserData in
                XCTAssert( remoteUserData.Status == "NO_DATA" )
                XCTAssert( remoteUserData.UserName == "USERNAME_NIL" )
                XCTAssert( remoteUserData.QuestionsAnswered == false )
                XCTAssert( remoteUserData.WalkingDuration == -1 )
                XCTAssert( remoteUserData.ChairAccessible == false )
                XCTAssert( remoteUserData.WeightsAccessible == false )
                XCTAssert( remoteUserData.ResistBandAccessible == false )
                XCTAssert( remoteUserData.PoolAccessible == false )
                XCTAssert( remoteUserData.Intensity == "INTENSITY_NIL" )
                XCTAssert( remoteUserData.PushNotifications == false )
                
                emptyUserAsyncExpectation?.fulfill()
                emptyUserAsyncExpectation = nil
            }
            
        }
        
        var testerUserAsyncExpectation: XCTestExpectation? = expectation(description: "Get_UserInfo(\"tester\") async block started")
        DispatchQueue.main.async {
            
            //Check reading a properly filled user returns as expected
            Get_UserInfoFirestore.Get_UserInfo(targetUser: "tester") { remoteUserData in
                //These values are pre-defined in the Firestore.
                XCTAssert( remoteUserData.Status == "SUCCESS" )
                XCTAssert( remoteUserData.UserName == "Tester" )
                XCTAssert( remoteUserData.QuestionsAnswered == true )
                XCTAssert( remoteUserData.WalkingDuration == 15 )
                XCTAssert( remoteUserData.ChairAccessible == true )
                XCTAssert( remoteUserData.WeightsAccessible == true )
                XCTAssert( remoteUserData.ResistBandAccessible == true )
                XCTAssert( remoteUserData.PoolAccessible == true )
                XCTAssert( remoteUserData.Intensity == "Moderate" )
                XCTAssert( remoteUserData.PushNotifications == true )
                
                testerUserAsyncExpectation?.fulfill()
                testerUserAsyncExpectation = nil
            }
            
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_Get_Routines() {
        
        //Initialize a new UserData class that only this method will interact with, along with a UserDataFirestore class using that Database
        let Get_RoutinesDB = UserData(DatabaseIdentifier: "Get_Routines")
        let Get_RoutinesFirestore = UserDataFirestore(sourceGiven: Get_RoutinesDB)
        
        var nullRoutineAsyncExpectation: XCTestExpectation? = expectation(description: "Get_Routines(\"nullUser\") async block started")
        DispatchQueue.main.async {
            
            //Check reading a non-existant user returns as expected
            Get_RoutinesFirestore.Get_Routines(targetUser: "nullUser") { remoteRoutineData in
                XCTAssert( remoteRoutineData[0].RoutineName == "NO_COLLECTION" )
                
                nullRoutineAsyncExpectation?.fulfill()
                nullRoutineAsyncExpectation = nil
            }
            
        }
        
        var emptyRoutineAsyncExpectation: XCTestExpectation? = expectation(description: "Get_Routines(\"Empty\") async block started")
        DispatchQueue.main.async {
            
            //Check that reading an empty user returns as expected
            Get_RoutinesFirestore.Get_Routines(targetUser: "Empty") { remoteRoutineData in
                XCTAssert( remoteRoutineData[0].RoutineName == "NO_DOCUMENTs" )
                
                emptyRoutineAsyncExpectation?.fulfill()
                emptyRoutineAsyncExpectation = nil
            }
        
        }
        
        var testerRoutineAsyncExpectation: XCTestExpectation? = expectation(description: "Get_Routines(\"tester\") async block started")
        DispatchQueue.main.async {
            
            //Check that reading a properly filled user returns as expected
            Get_RoutinesFirestore.Get_Routines(targetUser: "tester") { remoteRoutineData in
                XCTAssert( remoteRoutineData.count == 2 )
                XCTAssert( remoteRoutineData[0].RoutineName == "Friday Night Chill" )
                XCTAssert( remoteRoutineData[0].RoutineContents == ["Quad Stretch", "Walking", "Single Leg Stance"] )
                XCTAssert( remoteRoutineData[1].RoutineName == "Happy Day Workout" )
                XCTAssert( remoteRoutineData[1].RoutineContents == ["Walking", "Wall Push-up", "Single Leg Stance"] )
                
                testerRoutineAsyncExpectation?.fulfill()
                testerRoutineAsyncExpectation = nil
            }
        
        }
       
        waitForExpectations(timeout: 10, handler: nil)

    }
    
    func test_Get_ExercisesData() {
        
        //Initialize a new UserData class that only this method will interact with, along with a UserDataFirestore class using that Database
        let Get_ExerciseDataDB = UserData(DatabaseIdentifier: "Get_ExerciseData")
        let ExerciseDataFirestore = UserDataFirestore(sourceGiven: Get_ExerciseDataDB)
        
        let nullUserAsyncExpectation = expectation(description: "Get_ExerciseData(\"nullUser\") async block started")
        DispatchQueue.main.async {
            
            ExerciseDataFirestore.Get_ExerciseData(targetUser: "nullUser") { remoteExerciseData in
                XCTAssert( remoteExerciseData.isEmpty == true )
                
                nullUserAsyncExpectation.fulfill()
            }
            
        }
        
        let emptyAsyncExpectation = expectation(description: "Get_ExerciseData(\"Empty\") async block started")
        DispatchQueue.main.async {
            
            ExerciseDataFirestore.Get_ExerciseData(targetUser: "Empty") { remoteExerciseData in
                XCTAssert( remoteExerciseData.isEmpty == true )
                
                emptyAsyncExpectation.fulfill()
            }
            
        }
        
        let testerAsyncExpectation = expectation(description: "Get_ExerciseData(\"tester\") async block started")
        DispatchQueue.main.async {
            
            ExerciseDataFirestore.Get_ExerciseData(targetUser: "tester") { remoteExerciseData in
                XCTAssert( remoteExerciseData.count == 2 )
                XCTAssert( remoteExerciseData[0].Year == 2018 )
                XCTAssert( remoteExerciseData[0].Month == 10 )
                XCTAssert( remoteExerciseData[0].Day == 31 )
                XCTAssert( remoteExerciseData[0].Hour == 19 )
                XCTAssert( remoteExerciseData[0].ExercisesDone == ["Quad Stretch", "Walking", "Single Leg Stance"] )
                XCTAssert( remoteExerciseData[0].StepsTaken == 456 )
                XCTAssert( remoteExerciseData[1].Year == 2019 )
                XCTAssert( remoteExerciseData[1].Month == 11 )
                XCTAssert( remoteExerciseData[1].Day == 16 )
                XCTAssert( remoteExerciseData[1].Hour == 12 )
                XCTAssert( remoteExerciseData[1].ExercisesDone == ["Walking", "Single Leg Stance", "Wall Push-up"] )
                XCTAssert( remoteExerciseData[1].StepsTaken == 123)
                
                testerAsyncExpectation.fulfill()
            }
            
        }
        
        wait(for: [nullUserAsyncExpectation, emptyAsyncExpectation, testerAsyncExpectation], timeout: 10)
        
    }
    
    func test_UserInfo() {
        
        //Initialize a new UserData class that only this method will interact with, along with a UserDataFirestore class using that Database
        let UserInfoDB = UserData(DatabaseIdentifier: "UserInfo")
        let UserInfoFirestore = UserDataFirestore(sourceGiven: UserInfoDB)
        
        //Clear out the database to generate a new UUID and set some values for our user
        UserInfoDB.Clear_UserInfo_Database()
        UserInfoDB.Update_User_Data(nameGiven: "UserInfoTester", questionsAnswered: true, walkingDuration: 15, chairAvailable: true, weightsAvailable: false, resistBandAvailable: true, poolAvailable: false, intensityDesired: "Light", pushNotificationsDesired: true, firestoreOK: true)
        
        let nullUserAsyncExpectation = expectation(description: "Get_UserInfo() on non-existant user asnyc block started")
        DispatchQueue.main.async {
            
            //At this point we should not have a user available. Confirm
            UserInfoFirestore.Get_UserInfo(targetUser: nil) { remoteUserData in
                print("Null user status : \(remoteUserData)")
                XCTAssert( remoteUserData.Status == "NO_DOCUMENT" )
                
                nullUserAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [nullUserAsyncExpectation], timeout: 10)
        
        
        let firstInsertAsnycExpectation = expectation(description: "Initial Update_UserInfo() asnyc block started")
        DispatchQueue.main.async {
            
            //Add the user to Firestore
            UserInfoFirestore.Update_UserInfo() { returnVal in
                XCTAssert( returnVal == 0 )
                
                firstInsertAsnycExpectation.fulfill()
            }
            
        }
        wait(for: [firstInsertAsnycExpectation], timeout: 10)
        
        let firstReadAsyncExpectation = expectation(description: "First Get_UserInfo() async block started")
        DispatchQueue.main.async {
            
            //Confirm the the user was uploaded to Firestore
            UserInfoFirestore.Get_UserInfo(targetUser: nil) { remoteUserData in
                XCTAssert( remoteUserData.UserName == UserInfoDB.Get_User_Data().UserName )
                XCTAssert( remoteUserData.QuestionsAnswered == UserInfoDB.Get_User_Data().QuestionsAnswered )
                XCTAssert( remoteUserData.WalkingDuration == UserInfoDB.Get_User_Data().WalkingDuration )
                XCTAssert( remoteUserData.ChairAccessible == UserInfoDB.Get_User_Data().ChairAccessible )
                XCTAssert( remoteUserData.WeightsAccessible == UserInfoDB.Get_User_Data().WeightsAccessible )
                XCTAssert( remoteUserData.ResistBandAccessible == UserInfoDB.Get_User_Data().ResistBandAccessible )
                XCTAssert( remoteUserData.PoolAccessible == UserInfoDB.Get_User_Data().PoolAccessible )
                XCTAssert( remoteUserData.Intensity == UserInfoDB.Get_User_Data().Intensity )
                XCTAssert( remoteUserData.PushNotifications == UserInfoDB.Get_User_Data().PushNotifications )
                
                firstReadAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [firstReadAsyncExpectation], timeout: 10)
        
        //Update UserInfo
        UserInfoDB.Update_User_Data(nameGiven: "UserInfoTester2", questionsAnswered: true, walkingDuration: 20, chairAvailable: false, weightsAvailable: false, resistBandAvailable: false, poolAvailable: false, intensityDesired: "Moderate", pushNotificationsDesired: true, firestoreOK: true)
        
        let secondInsertAsyncExpectation = expectation(description: "Second Update_UserInfo() async block started")
        DispatchQueue.main.async {
            
            //Update the user in Firestore
            UserInfoFirestore.Update_UserInfo() { returnVal in
                XCTAssert( returnVal == 0 )
                
                secondInsertAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [secondInsertAsyncExpectation], timeout: 10)
        
        let secondReadAsyncExpectation = expectation(description: "Second Get_UserInfo() async block started")
        DispatchQueue.main.async {
            
            //Confirm the update went through
            UserInfoFirestore.Get_UserInfo(targetUser: nil) { remoteUserData in
                XCTAssert( remoteUserData.UserName == UserInfoDB.Get_User_Data().UserName )
                XCTAssert( remoteUserData.QuestionsAnswered == UserInfoDB.Get_User_Data().QuestionsAnswered )
                XCTAssert( remoteUserData.WalkingDuration == UserInfoDB.Get_User_Data().WalkingDuration )
                XCTAssert( remoteUserData.ChairAccessible == UserInfoDB.Get_User_Data().ChairAccessible )
                XCTAssert( remoteUserData.WeightsAccessible == UserInfoDB.Get_User_Data().WeightsAccessible )
                XCTAssert( remoteUserData.ResistBandAccessible == UserInfoDB.Get_User_Data().ResistBandAccessible )
                XCTAssert( remoteUserData.PoolAccessible == UserInfoDB.Get_User_Data().PoolAccessible )
                XCTAssert( remoteUserData.Intensity == UserInfoDB.Get_User_Data().Intensity )
                XCTAssert( remoteUserData.PushNotifications == UserInfoDB.Get_User_Data().PushNotifications )
                
                secondReadAsyncExpectation.fulfill()
            }
        
        }
        wait(for: [secondReadAsyncExpectation], timeout: 10)

    }
    
    func test_Routines() {
        
        //Initialize a new UserData class that only this method will interact with, along with a UserDataFirestore class using that Database
        let RoutinesDB = UserData(DatabaseIdentifier: "Routines")
        let RoutinesFirestore = UserDataFirestore(sourceGiven: RoutinesDB)
        
        //Set some routines
        let firstName = "First"
        let firstContents = ["ex1", "ex2", "ex3"]
        let secondName = "Second"
        let secondContents = ["ex4", "ex5", "ex6"]
        let thirdName = "Third"
        let thirdContents = ["ex7", "ex8", "ex9"]
        let modifiedContents = ["ex10", "ex11", "ex12"]
        
        //Set some values for our user and then insert into Firestore
        RoutinesDB.Clear_UserInfo_Database()
        RoutinesDB.Clear_Routines_Database()
        RoutinesDB.Update_User_Data(nameGiven: "RoutinesTester", questionsAnswered: true, walkingDuration: 15, chairAvailable: true, weightsAvailable: false, resistBandAvailable: true, poolAvailable: false, intensityDesired: "Light", pushNotificationsDesired: false, firestoreOK: true)
        
        let userInsertAsyncExpectation = expectation(description: "User insert for Routine testing async block started")
        DispatchQueue.main.async {
            
            global_UserDataFirestore.Update_UserInfo() { returnVal in
                XCTAssert( returnVal == 0 )
                
                userInsertAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [userInsertAsyncExpectation], timeout: 10)
        
        //Insert the first 2 routines to confirm they insert properly
        RoutinesDB.Add_Routine(NameOfRoutine: firstName, ExercisesIncluded: firstContents)
        RoutinesDB.Add_Routine(NameOfRoutine: secondName, ExercisesIncluded: secondContents)
       
        let initialInsertAsyncExpectation = expectation(description: "Initial insert async block started")
        DispatchQueue.main.async {
            
            RoutinesFirestore.Update_Routines() { returnVal in
                XCTAssert( returnVal == 0 )
                
                initialInsertAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [initialInsertAsyncExpectation], timeout: 10)
        
        let initialReadAsyncExpectation = expectation(description: "Initial read async block started")
        DispatchQueue.main.async {
            
            RoutinesFirestore.Get_Routines(targetUser: nil) { returnedData in
                XCTAssert( returnedData.count == 3 )
                XCTAssert( returnedData[0].RoutineName == firstName )
                XCTAssert( returnedData[0].RoutineContents == firstContents )
                XCTAssert( returnedData[1].RoutineName == secondName )
                XCTAssert( returnedData[1].RoutineContents == secondContents )
                
                initialReadAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [initialReadAsyncExpectation], timeout: 10)
        
        //Clear out the routine database and set to insert all 3, plus modifying one
        RoutinesDB.Clear_Routines_Database()
        RoutinesDB.Add_Routine(NameOfRoutine: firstName, ExercisesIncluded: firstContents)
        RoutinesDB.Add_Routine(NameOfRoutine: secondName, ExercisesIncluded: modifiedContents)
        RoutinesDB.Add_Routine(NameOfRoutine: thirdName, ExercisesIncluded: thirdContents)
        
        //Push to Firestore
        let secondInsertAsyncExpectation = expectation(description: "Second insert async block started")
        DispatchQueue.main.async {
            
            RoutinesFirestore.Update_Routines() { returnVal in
                XCTAssert( returnVal == 0 )
                
                secondInsertAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [secondInsertAsyncExpectation], timeout: 10)
        
        //Confirm the push went through
        let secondReadAsyncExpectation = expectation(description: "Second read async block started")
        DispatchQueue.main.async {
            
            RoutinesFirestore.Get_Routines(targetUser: nil) { returnedData in
                XCTAssert( returnedData.count == 3 )
                XCTAssert( returnedData[0].RoutineName == firstName )
                XCTAssert( returnedData[0].RoutineContents == firstContents )
                XCTAssert( returnedData[1].RoutineName == secondName )
                XCTAssert( returnedData[1].RoutineContents == modifiedContents )
                XCTAssert( returnedData[2].RoutineName == thirdName )
                XCTAssert( returnedData[2].RoutineContents == thirdContents )
                
                secondReadAsyncExpectation.fulfill()
            }
            
        }
        wait(for: [secondReadAsyncExpectation], timeout: 10)
        
    }
    
}
