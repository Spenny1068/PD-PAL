//
//  testExerciseDB.swift
//  PD_PALTests
//
//  Created by Zhong Jia Xue on 2019-11-01.
//  Copyright © 2019 WareOne. All rights reserved.
//
/*
Revision History
 
 - 01/11/2019 : William Xue
     Moved exercise database testcase to it's own file
 */


import XCTest
@testable import PD_PAL

class testExerciseDB: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
        
        //check that the return all names function works
        XCTAssert( exDB.exercise_names().count == 1)
        XCTAssert( exDB.exercise_names()[0] == name)
        
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
