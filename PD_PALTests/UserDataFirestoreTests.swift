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
        let remoteData = UserDataFirestore()
        
        let remoteUserData = remoteData.Get_UserInfo(targetUser: "tester")
     
        XCTAssert( remoteUserData.UserUUID == "tester" )
        XCTAssert( remoteUserData.UserName == "Tester" )
        XCTAssert( remoteUserData.QuestionsAnswered == true )
        XCTAssert( remoteUserData.WalkingDuration == 15 )
        XCTAssert( remoteUserData.ChairAccessible == true )
        XCTAssert( remoteUserData.WeightsAccessible == false )
        XCTAssert( remoteUserData.ResistBandAccessible == true )
        XCTAssert( remoteUserData.PoolAccessible == false )
        XCTAssert( remoteUserData.Intensity == "Moderate" )
        XCTAssert( remoteUserData.PushNotifications == true )
    }
    
}
