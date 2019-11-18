//
//  PD_PALUITests.swift
//  PD_PALUITests
//
//  Created by SpenC on 2019-10-11.
//  Copyright © 2019 WareOne. All rights reserved.
// <November 16, 2019, Julia Kim, Added UI testing for switch to push to cloud and button to delete user data>

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
        
        /* UITests variables */
        let SETUP = 1   // make = 1 to run questionnaire setup

        let app = XCUIApplication()
        let app2 = app
        

        // Enter user name: SpenC
        app.textFields["Enter your name"].tap()
        app2.keys["S"].tap()
        app2.keys["p"].tap()
        app2.keys["e"].tap()
        app2.keys["n"].tap()
        app2/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app2.keys["C"].tap()
        
        app2/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Enter"].tap()
        
        // do setup page
        if SETUP == 0 {
            app.buttons["Set-up"].tap()
                
            app.buttons["Light"].tap()
            app.buttons["Moderate"].tap()
            app.buttons["Intense"].tap()
            app.buttons["Next"].tap()

            let window = app.children(matching: .window).element(boundBy: 0)
            let element = window.children(matching: .other).element(boundBy: 2).children(matching: .other).element
            element.children(matching: .other).element(boundBy: 1).buttons["Unchecked marks"].tap()
            element.children(matching: .other).element(boundBy: 2).buttons["Unchecked marks"].tap()
            
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
        
        // skip setup page
        else {
            app.buttons["Ask me later"].tap()
            
            // routine main apge
            app.buttons["Happy Day Workout"].tap()
            app.buttons["Exercise 1"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.buttons["Exercise 2"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.buttons["Exercise 3"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()

            app.swipeLeft()

            /* Categories main page */
            // -> Flexibility
            app.buttons["Flexibility"].tap()
            app.buttons["SINGLE LEG STANCE"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()

            // -> Cardio
            app.buttons["Cardio"].tap()
            app.buttons["WALKING"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()

            // -> Balance
            app.buttons["Balance"].tap()
            app.buttons["QUAD STRETCH"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()

            // -> Strength
            app.buttons["Strength"].tap()
            app.buttons["WALL PUSHUP"].tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.navigationBars.buttons.element(boundBy: 0).tap()

            app.swipeLeft()
            app.swipeLeft()

            /* Trends main page */
            //app.buttons["Balance"].tap()

}
        
    }
    
    func testDatePicker(){
        let app = XCUIApplication()
        //let app2 = app
        let datePickers = XCUIApplication().datePickers
        
        app.swipeLeft()
        app.swipeLeft()
        
        app.swipeUp() //test scrolling up the page
        app.swipeDown() //test scrolling down the page
        app.textFields["Pick a Start Date"].tap()
        
        app.datePickers.pickerWheels["Today"].swipeDown()
        
        app.textFields["Pick an End Date"].tap()
     
        app.datePickers.pickerWheels["Today"].swipeUp()
        app.buttons["Update All"].tap()
        
        app.swipeUp() //test scrolling up the page
        app.swipeDown() //test scrolling down the page
        
        app.buttons["Reset Dates"].tap()
        
        
    }
    
    func testCloudPermSW()
    {
        
        
        let app = XCUIApplication()
        let element = app.otherElements.containing(.navigationBar, identifier:"PD_PAL.mainPageView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.switches["CloudSW"].tap()
        element.switches["CloudSW"].tap()
        
    }
    
    
    func testDeleteUserDataButton(){
        
        let app = XCUIApplication()
        app.textFields["Enter your name"].tap()
        app.keys["s"].tap()
        app.buttons["Enter"].tap()
        app.buttons["Later"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        app.buttons["Happy Day Workout"].tap()
        app.buttons["WALL PUSH-UP"].tap()
        
        let completedButton = app.buttons["COMPLETED"]
        completedButton.tap()
        completedButton.tap()
        completedButton.tap()
        completedButton.tap()
        completedButton.tap()
        completedButton.tap()
        completedButton.tap()
        completedButton.tap()
        app.navigationBars["PD_PAL.ExerciseView"].buttons["Back"].tap()
        app.navigationBars["PD_PAL.RoutineGenericView"].buttons["Back"].tap()
        element.swipeLeft()
        element.swipeLeft()
        
        let updateAllButton = app/*@START_MENU_TOKEN@*/.buttons["Update All"]/*[[".scrollViews.buttons[\"Update All\"]",".buttons[\"Update All\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        updateAllButton.tap()
        
        let flexibilityElement = app.scrollViews.otherElements.containing(.staticText, identifier:"Flexibility").element
        flexibilityElement.swipeUp()
        flexibilityElement.swipeUp()
        flexibilityElement.swipeUp()
        app.staticTexts["W Trends!"].swipeDown()
        
        let updateAllScrollView = app/*@START_MENU_TOKEN@*/.scrollViews.containing(.button, identifier:"Update All").element/*[[".scrollViews.containing(.staticText, identifier:\"Please select the same day for hourly graph.\").element",".scrollViews.containing(.textField, identifier:\"Pick an End Date\").element",".scrollViews.containing(.textField, identifier:\"Pick a Start Date\").element",".scrollViews.containing(.button, identifier:\"Reset Dates\").element",".scrollViews.containing(.button, identifier:\"Update All\").element"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        updateAllScrollView.swipeLeft()
        app.staticTexts["Select A Routine To Try!"].swipeLeft()
        element.swipeLeft()
        updateAllScrollView.swipeLeft()
        app.buttons["Delete All My Data"].tap()
        app.alerts["Confirm Deletion"].buttons["Agree"].tap()
        element.swipeRight()
        element.swipeLeft()
        updateAllButton.tap()
        updateAllButton.tap()
        updateAllButton.tap()
        flexibilityElement.swipeUp()
    }
    
    //test to show to trends table in the trends pages 
    func testTrendsTable()
    {
        let app = XCUIApplication()
        let app2 = app
        
        app.textFields["Enter your name"].tap()
        
        let wKey = app2/*@START_MENU_TOKEN@*/.keys["W"]/*[[".keyboards.keys[\"W\"]",".keys[\"W\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()
        
       

        
        let aKey = app2/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()

        
        let rKey = app2/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()

        
        let eKey = app2/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
  
        app2/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let oKey = app2/*@START_MENU_TOKEN@*/.keys["O"]/*[[".keyboards.keys[\"O\"]",".keys[\"O\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
     
        
        let nKey = app2/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()

        eKey.tap()
   
        app2/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Enter"].tap()
        

        
        app.buttons["Set-up"].tap()
        
        let moderateButton = app.buttons["Moderate"]
        moderateButton.tap()
        
        let nextButton = app.buttons["Next"]
        
        nextButton.tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element(boundBy: 2).children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).buttons["Unchecked marks"].tap()
        element.children(matching: .other).element(boundBy: 1).buttons["Unchecked marks"].tap()
        nextButton.tap()
        
        let slider = app.sliders["0%"]
        slider.swipeRight()
        slider.adjust(toNormalizedSliderPosition: 0.65)
        
        let completeButton = app.buttons["Complete"]
        completeButton.tap()
        app.buttons["Happy Day Workout"].tap()
        app.buttons["Exercise 1"].tap()
        
        let selectButton = app.buttons["Select"]
        selectButton.tap()
        selectButton.tap()
        app.navigationBars["Walking"].buttons["Routine 1"].tap()
        app.navigationBars["Routine 1"].buttons["Home"].tap()
        
        
        
        app.otherElements.containing(.navigationBar, identifier:"Main").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).swipeLeft()
        app.buttons["Flexibility"].tap()
        app.buttons["Single Leg Stance"].tap()
        app.buttons["Select"].tap()
        app.navigationBars["ChairStretch"].buttons["Home"].tap()
        
        
        
        
        app.staticTexts["ROUTINES"].swipeLeft()
        app.buttons["Balance"].tap()
        app.buttons["Quad Stretch"].tap()
        app.buttons["Select"].tap()
        app.navigationBars["OneLegSquat"].buttons["Home"].tap()
        
   

        

        app.staticTexts["Choose a routine to try!"].swipeRight()
        app.staticTexts["Change your settings!"].swipeRight()
        app.buttons["Update"].tap()
        app.staticTexts["You're Doing Great!"].swipeLeft()
      
        
    
    }

}
