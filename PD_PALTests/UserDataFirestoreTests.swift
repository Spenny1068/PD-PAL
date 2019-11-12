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

    //Test to confirm we can read the UserInfo for tester using the class method.
    func test_ReadTester() {
        //Example call for Get_UserInfo(). Looks like this due to the asynchronous nature of Firestore.firestore().getDocument()
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
    }
    
}
