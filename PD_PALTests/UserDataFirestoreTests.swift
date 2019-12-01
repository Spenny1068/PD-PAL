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
 - 17/11/2019 : William Huong --- Fixed
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
        
        //Create a Firebase reference for use
        let FirestoreRef = Firestore.firestore()
        
        //Initialize a new UserData class that only this method will interact with, along with a UserDataFirestore class using that Database
        let UserInfoDB = UserData(DatabaseIdentifier: "UserInfo")
        let UserInfoFirestore = UserDataFirestore(sourceGiven: UserInfoDB)
        
        //Create a UUID to use as a guaranteed user name
        let currentUser = UUID().uuidString
        
        //Create the User Info document reference
        let userDocRef = FirestoreRef.collection("User").document(currentUser)
        
        UserInfoDB.Update_User_Data(nameGiven: currentUser, questionsAnswered: true, walkingDuration: 10, chairAvailable: false, weightsAvailable: false, resistBandAvailable: false, poolAvailable: false, intensityDesired: "Moderate", pushNotificationsDesired: false, firestoreOK: true)
        
        //Push the user to Firebase
        UserInfoFirestore.Update_UserInfo()
        
        //Wait 10 seconds for the push to finish
        sleep(10)
        
        //Make sure the push actually went through
        let initialExpecation = expectation(description: "Initial User Info push")
        
        userDocRef.getDocument() { (document, error) in
            guard let document = document, document.exists else {
                //The user did not exist.
                return
            }
            
            let dataReturned = document.data()
            
            //Grab the data, unwrap it.
            let returnedUserName = dataReturned?["UserName"] as? String ?? "USERNAME_NIL"
            let returnedQuestionsAnswered = dataReturned?["QuestionsAnswered"] as? Bool ?? false
            let returnedWalkingDuration = dataReturned?["WalkingDuration"] as? Int ?? -1
            let returnedChairAccessible = dataReturned?["ChairAccessible"] as? Bool ?? false
            let returnedWeightsAccessible = dataReturned?["WeightsAccessible"] as? Bool ?? false
            let returnedResistBandAccessible = dataReturned?["ResistBandAccessible"] as? Bool ?? false
            let returnedPoolAccessible = dataReturned?["PoolAccessible"] as? Bool ?? false
            let returnedIntensity = dataReturned?["Intensity"] as? String ?? "INTENSITY_NIL"
            let returnedPushNotifications = dataReturned?["PushNotifications"] as? Bool ?? false
            
            XCTAssert( returnedUserName == currentUser )
            XCTAssert( returnedQuestionsAnswered == true )
            XCTAssert( returnedWalkingDuration == 10 )
            XCTAssert( returnedChairAccessible == false )
            XCTAssert( returnedWeightsAccessible == false )
            XCTAssert( returnedResistBandAccessible == false )
            XCTAssert( returnedPoolAccessible == false )
            XCTAssert( returnedIntensity == "Moderate" )
            XCTAssert( returnedPushNotifications == false )
            
            initialExpecation.fulfill()
        }
        
        wait(for: [initialExpecation], timeout: 10)
        
        //Update the user info
        UserInfoDB.Update_User_Data(nameGiven: nil, questionsAnswered: true, walkingDuration: 30, chairAvailable: true, weightsAvailable: true, resistBandAvailable: true, poolAvailable: true, intensityDesired: "Intense", pushNotificationsDesired: true, firestoreOK: true)
        
        UserInfoFirestore.Update_UserInfo()
        
        //Wait 10 seconds for the push to finish
        sleep(10)
        
        //make sure the update actually went through
        let updateExpecation = expectation(description: "Update User Info push")
        
        userDocRef.getDocument() { (document, error) in
            guard let document = document, document.exists else {
                //The user did not exist.
                return
            }
            
            let dataReturned = document.data()
            
            //Grab the data, unwrap it.
            let returnedUserName = dataReturned?["UserName"] as? String ?? "USERNAME_NIL"
            let returnedQuestionsAnswered = dataReturned?["QuestionsAnswered"] as? Bool ?? false
            let returnedWalkingDuration = dataReturned?["WalkingDuration"] as? Int ?? -1
            let returnedChairAccessible = dataReturned?["ChairAccessible"] as? Bool ?? false
            let returnedWeightsAccessible = dataReturned?["WeightsAccessible"] as? Bool ?? false
            let returnedResistBandAccessible = dataReturned?["ResistBandAccessible"] as? Bool ?? false
            let returnedPoolAccessible = dataReturned?["PoolAccessible"] as? Bool ?? false
            let returnedIntensity = dataReturned?["Intensity"] as? String ?? "INTENSITY_NIL"
            let returnedPushNotifications = dataReturned?["PushNotifications"] as? Bool ?? false
            
            XCTAssert( returnedUserName == currentUser )
            XCTAssert( returnedQuestionsAnswered == true )
            XCTAssert( returnedWalkingDuration == 30 )
            XCTAssert( returnedChairAccessible == true )
            XCTAssert( returnedWeightsAccessible == true )
            XCTAssert( returnedResistBandAccessible == true )
            XCTAssert( returnedPoolAccessible == true )
            XCTAssert( returnedIntensity == "Intense" )
            XCTAssert( returnedPushNotifications == true )
            
            updateExpecation.fulfill()
        }
        
        wait(for: [updateExpecation], timeout: 10)

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
    
}
