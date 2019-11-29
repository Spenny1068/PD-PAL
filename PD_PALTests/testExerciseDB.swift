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
        let name = "Bicep Curls"
        let link = "bicep_curl.mp4"
        let duration = 20
        let equip = "Dumbell"
        let intensity = "high"
        let sets = 5
        exDB.insert_exercise(Name: name , Desc: desc, Category: cat, Equipment: equip , Link: link, Intensity: intensity, Duration: duration, Sets: sets)
        
        let readResult = exDB.read_exercise(NameOfExercise: name)
        
        //making sure we read what we written
        XCTAssert( readResult.Description == desc ) ;
        XCTAssert( readResult.Equipment == equip ) ;
        XCTAssert( readResult.Intensity == intensity ) ;
        XCTAssert( readResult.Sets == sets ) ;
        XCTAssert( readResult.Category == cat ) ;
        XCTAssert( readResult.Link == link) ;
        XCTAssert( readResult.Duration == duration);
        
        //check that the return all names function works
        print(exDB.exercise_names().count)
        //XCTAssert( exDB.exercise_names().count == 16)
        XCTAssert( exDB.exercise_names()[0] == "WALL PUSH-UP")
        
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
