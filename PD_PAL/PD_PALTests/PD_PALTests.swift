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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
