//
//  PD_PALTests.swift
//  PD_PALTests
//
//  Created by SpenC on 2019-10-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
Revision History
 
 - 26/10/2019 : William Xue
     Added simple database test, "testDatabase_insertion"
 - 31/10/2019 : William Huong
     Added Tests for UserData class.
 */


import XCTest
@testable import PD_PAL

class PD_PALTests: XCTestCase {


    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //
    func testDatabase_insertion() {
        
        let exDB = ExerciseDatabase()
        
        let desc = "Elevate Weights while keepings arms still"
        let cat = "Strength"
        let body = "Arms"
        let name = "Bicep Curls"
        let link = "bicep_curl.mp4"
        exDB.insert_exercise(Name: name , Desc: desc, Category: cat, Body: body, Link: link)
        
        let readResult = exDB.read_exercise(NameOfExercise: name)
        
        //making sure we read what we written
        XCTAssert( readResult.Description == desc ) ;
        XCTAssert( readResult.Category == cat ) ;
        XCTAssert( readResult.Body == body ) ;
        XCTAssert( readResult.Link == link) ;
        
        //delete the database when we are done with it
        exDB.remove_database()
        
    }
    
    func test_userData_userInfo() {
        
        //Initialize some variables. These are all different than default assigned values.
        let testName = "John"
        let testName2 = "Jane"
        
        //Create the object.
        let userDB = UserData(nameGiven: testName, questionsAnswered: false, walkingDesired: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
        
        //Get the object when we only pass a name and check all default variables are correctly assigned.
        var userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserName == "John" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingOK == false )
        XCTAssert( userData.ChairAccess == false )
        XCTAssert( userData.WeightsAccess == false )
        XCTAssert( userData.ResistBandAccess == false )
        XCTAssert( userData.Intensity == 0 )
        XCTAssert( userData.PushNotifications == false )
        
        //Change some of the values to check we only update the values given.
        userDB.Update_User_Data(nameGiven: nil, questionsAnswered: true, walkingDesired: true, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
        
        userData = userDB.Get_User_Data()
        
        //Check values.
        XCTAssert( userData.UserName == "John" )
        XCTAssert( userData.QuestionsAnswered == true )
        XCTAssert( userData.WalkingOK == true )
        XCTAssert( userData.ChairAccess == false )
        XCTAssert( userData.WeightsAccess == false )
        XCTAssert( userData.ResistBandAccess == false )
        XCTAssert( userData.Intensity == 0 )
        XCTAssert( userData.PushNotifications == false )
        
        //Change the rest of the values.
        userDB.Update_User_Data(nameGiven: testName2, questionsAnswered: nil, walkingDesired: nil, chairAvailable: true, weightsAvailable: true, resistBandAvailable: true, intensityDesired: 5, pushNotificationsDesired: true)
        
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserName == "Jane" )
        XCTAssert( userData.QuestionsAnswered == true )
        XCTAssert( userData.WalkingOK == true )
        XCTAssert( userData.ChairAccess == true )
        XCTAssert( userData.WeightsAccess == true )
        XCTAssert( userData.ResistBandAccess == true )
        XCTAssert( userData.Intensity == 5 )
        XCTAssert( userData.PushNotifications == true )
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
