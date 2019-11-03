//
//  PD_PALUITests.swift
//  PD_PALUITests
//
//  Created by SpenC on 2019-10-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

import XCTest


class PD_PALUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let app2 = app
        
        app.textFields["Enter your name"].tap()

        // SpenC
        app2.keys["S"].tap()
        app2.keys["p"].tap()
        app2.keys["e"].tap()
        app2.keys["n"].tap()
        app2/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app2.keys["C"].tap()
        
        app2/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Enter"].tap()
        app.buttons["Set-up"].tap()
        
        let nextButton = app.buttons["Next"]
        nextButton.tap()
        app.buttons["Light"].tap()
        app.buttons["Intense"].tap()
        app.buttons["Moderate"].tap()
        nextButton.tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element(boundBy: 2).children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).buttons["Unchecked marks"].tap()
        element.children(matching: .other).element(boundBy: 2).buttons["Unchecked marks"].tap()
        nextButton.tap()
        app.sliders["0%"].swipeRight()
        app.buttons["Complete"].tap()
        app.buttons["Routine 1"].tap()
        app.buttons["Exercise 1"].tap()
        app.buttons["Exercise 2"].tap()
        app.buttons["Exercise 3"].tap()
        app.staticTexts["ROUTINE 1"].tap()
        
        let element2 = window.children(matching: .other).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element2.tap()
        element2.tap()
        app.navigationBars["Routine 1"].buttons["Main"].tap()
        
        let element3 = element2.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element3.children(matching: .other).element.children(matching: .other).element(boundBy: 0).swipeLeft()
        element3.children(matching: .button).matching(identifier: "Button").element(boundBy: 2).tap()
        app.buttons["ARMS"].tap()
        app.buttons["CHEST"].tap()
        
    }
    
    func stepCounter(){
        
    }
    
    //test to show to trends table in the trends pages 
    func testTrendsTable()
    {

            
       
        
        let app = XCUIApplication()
        app.textFields["Enter your name"].tap()
        
        let wKey = app/*@START_MENU_TOKEN@*/.keys["W"]/*[[".keyboards.keys[\"W\"]",".keys[\"W\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()

        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Enter"].tap()
        app.buttons["Ask me later"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).swipeLeft()
        element.swipeLeft()
  
        

        
        
    }

}
