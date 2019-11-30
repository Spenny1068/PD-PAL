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
                XCTAssert( remoteUserData.UserName == "tester" )
                XCTAssert( remoteUserData.QuestionsAnswered == true )
                XCTAssert( remoteUserData.WalkingDuration == 30 )
                XCTAssert( remoteUserData.ChairAccessible == true )
                XCTAssert( remoteUserData.WeightsAccessible == true )
                XCTAssert( remoteUserData.ResistBandAccessible == true )
                XCTAssert( remoteUserData.PoolAccessible == true )
                XCTAssert( remoteUserData.Intensity == "Intense" )
                XCTAssert( remoteUserData.PushNotifications == true )
                
                testerUserAsyncExpectation?.fulfill()
                testerUserAsyncExpectation = nil
            }
            
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func test_Get_ExercisesData() {
 
        //Initialize a new UserData class that only this method will interact with, along with a UserDataFirestore class using that Database
        let Get_ExerciseDataDB = UserData(DatabaseIdentifier: "Get_ExerciseData")
        let ExerciseDataFirestore = UserDataFirestore(sourceGiven: Get_ExerciseDataDB)
 
        var nullUserAsyncExpectation: XCTestExpectation? = expectation(description: "Get_ExerciseData(\"nullUser\") async block started")
        DispatchQueue.main.async {
            
            ExerciseDataFirestore.Get_ExerciseData(targetUser: "nullUser") { remoteExerciseData in
                XCTAssert( remoteExerciseData.first?.ExercisesDone.first == "NO_DOCUMENTS" )
                
                nullUserAsyncExpectation?.fulfill()
                nullUserAsyncExpectation = nil
            }
            
        }
        
        var emptyAsyncExpectation: XCTestExpectation? = expectation(description: "Get_ExerciseData(\"Empty\") async block started")
        DispatchQueue.main.async {
            
            ExerciseDataFirestore.Get_ExerciseData(targetUser: "Empty") { remoteExerciseData in
                //XCTAssert( remoteExerciseData[0].ExercisesDone[0] == "NO_DOCUMENTS" )
                
                emptyAsyncExpectation?.fulfill()
                emptyAsyncExpectation = nil
            }
            
        }
 
        var testerAsyncExpectation: XCTestExpectation? = expectation(description: "Get_ExerciseData(\"tester\") async block started")
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
                
                testerAsyncExpectation?.fulfill()
                testerAsyncExpectation = nil
            }
            
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        
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
        wait(for: [nullUserAsyncExpectation], timeout: 1)
        
        
        let firstInsertAsnycExpectation = expectation(description: "Initial Update_UserInfo() asnyc block started")
        DispatchQueue.main.async {
            
            //Add the user to Firestore
            UserInfoFirestore.Update_UserInfo() { returnVal in
                XCTAssert( returnVal == 0 )
                
                firstInsertAsnycExpectation.fulfill()
            }
            
        }
        wait(for: [firstInsertAsnycExpectation], timeout: 1)
        
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
        wait(for: [firstReadAsyncExpectation], timeout: 1)
        
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
        wait(for: [secondInsertAsyncExpectation], timeout: 1)
        
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
        wait(for: [secondReadAsyncExpectation], timeout: 1)

    }
    
    func test_Name_Check() {
        
        //Instantiate the class for this test
        let nameCheckFirestore = UserDataFirestore(sourceGiven: global_UserData)
        
        //Check looking for a name in use returns false.
        let falseExpectation = expectation(description: "False check")
        nameCheckFirestore.Name_Available(nameToCheck: "tester") { returnVal in
            XCTAssert( returnVal == false )
            falseExpectation.fulfill()
        }
        
        //Check looking for a name not in use returns true.
        let trueExpectation = expectation(description: "True check")
        nameCheckFirestore.Name_Available(nameToCheck: "Mr. Non-existant") { returnVal in
            XCTAssert( returnVal == true )
            trueExpectation.fulfill()
        }
        
        wait(for: [falseExpectation, trueExpectation], timeout: 2)
        
    }
    
    func test_Name_Check_Synchro() {
        let nameCheckFirestore_Synchro = UserDataFirestore(sourceGiven: global_UserData)
        
        //Check looking for a name in use returns false.
        //let falseReturn = nameCheckFirestore_Synchro.Name_Available_Synchro(nameToCheck: "tester")
        //XCTAssert( falseReturn == false )
        
        //Check looking for a name not in use returns true.
        let trueReturn = nameCheckFirestore_Synchro.Name_Available_Synchro(nameToCheck: "Mr. Non-Existant")
        XCTAssert( trueReturn == true )
    }
    
}
