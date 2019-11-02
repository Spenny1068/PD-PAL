//
//  UserDataTests.swift
//  UserDataTests
//
//  Created by SpenC on 2019-10-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
Revision History
 
 - 26/10/2019 : William Xue
     Added simple database test, "testDatabase_insertion"
 - 01/11/2019 : William Huong
     Added Tests for UserData class.
 - 01/11/2019 : William Xue
     Moved testDatabase_insertion to it's own file
 - 01/11/2019 : William Huong
    Updated test for greater coverage
 - 01/11/2019 : William Huong
    Updated test_UserData_UserInfo()
 */


import XCTest
@testable import PD_PAL

class UserDataTests: XCTestCase {


    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //Kill the files before the testing so that we are starting from a known state.
        let userData = UserData()
        userData.Delete_Database(dbToDelete: "UserInfo")
        userData.Delete_Database(dbToDelete: "Routines")
        userData.Delete_Database(dbToDelete: "UserExerciseData")
        userData.Delete_Database(dbToDelete: "StepCount")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //

    
/*
UserData Class Tests
*/
    
    func test_userData_UserInfo() {
        
        //Create the object.
        let userDB = UserData()
        
        //Check that the default values before inserting.
        var userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserName == "DEFAULT_NAME" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        
        //Provide just the user name.
        userDB.Update_User_Data(nameGiven: "Margaret", questionsAnswered: nil, walkingDuration: nil, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
        
        //Get the user info
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserName == "Margaret" )
        XCTAssert( userData.QuestionsAnswered == false )
        XCTAssert( userData.WalkingDuration == 0 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        
        //Change some of the values to check we only update the values given.
        userDB.Update_User_Data(nameGiven: nil, questionsAnswered: true, walkingDuration: 30, chairAvailable: nil, weightsAvailable: nil, resistBandAvailable: nil, poolAvailable: nil, intensityDesired: nil, pushNotificationsDesired: nil)
        
        userData = userDB.Get_User_Data()
        
        //Check values.
        XCTAssert( userData.UserName == "Margaret" )
        XCTAssert( userData.QuestionsAnswered == true )
        XCTAssert( userData.WalkingDuration == 30 )
        XCTAssert( userData.ChairAccessible == false )
        XCTAssert( userData.WeightsAccessible == false )
        XCTAssert( userData.ResistBandAccessible == false )
        XCTAssert( userData.PoolAccessible == false )
        XCTAssert( userData.Intensity == "Light" )
        XCTAssert( userData.PushNotifications == false )
        
        //Change the rest of the values.
        userDB.Update_User_Data(nameGiven: "Ebenezer Scrooge", questionsAnswered: nil, walkingDuration: nil, chairAvailable: true, weightsAvailable: true, resistBandAvailable: true, poolAvailable: true, intensityDesired: "Intense", pushNotificationsDesired: true)
        
        userData = userDB.Get_User_Data()
        
        XCTAssert( userData.UserName == "Ebenezer Scrooge" )
        XCTAssert( userData.QuestionsAnswered == true )
        XCTAssert( userData.WalkingDuration == 30 )
        XCTAssert( userData.ChairAccessible == true )
        XCTAssert( userData.WeightsAccessible == true )
        XCTAssert( userData.ResistBandAccessible == true )
        XCTAssert( userData.PoolAccessible == true )
        XCTAssert( userData.Intensity == "Intense" )
        XCTAssert( userData.PushNotifications == true )
        
    }
    
    func test_UserData_Routines() {
        
        //Define some variables to test with
        let routine1name = "Happy Days Workout"
        let routine2name = "Happier Days Workout"
        let nullRoutine = "Immaginary Workout"
        
        let routine1exercises = ["Bicep Curls", "5 minute walk", "one legged stand"]
        let routine2exercises = ["squats", "sit ups", "bulgarian hamstring stretch", "whatever involved the chair"]
        
        let userData = UserData()
        
        //Confirm the database is empty and Get_Routines() and Get_Routine() behave properly.
        let initialRoutines = userData.Get_Routines()
        let initialRoutine = userData.Get_Routine(NameOfRoutine: nullRoutine)
        XCTAssert( initialRoutines.isEmpty == true )
        XCTAssert( initialRoutine.isEmpty == true )
        
        //Insert our 2 routines
        userData.Add_Routine(NameOfRoutine: routine1name, ExercisesIncluded: routine1exercises)
        userData.Add_Routine(NameOfRoutine: routine2name, ExercisesIncluded: routine2exercises)
        
        //Confirm they were successfully added.
        let filledRoutines = userData.Get_Routines()
        let filledRoutine1 = userData.Get_Routine(NameOfRoutine: routine1name)
        let filledRoutine2 = userData.Get_Routine(NameOfRoutine: routine2name)
        
        XCTAssert( filledRoutines.count == 2 )
        XCTAssert( filledRoutines[0].RoutineName == routine1name )
        XCTAssert( filledRoutines[0].Exercises == routine1exercises )
        XCTAssert( filledRoutines[1].RoutineName == routine2name )
        XCTAssert( filledRoutines[1].Exercises == routine2exercises )
        
        XCTAssert( filledRoutine1 == routine1exercises )
        XCTAssert( filledRoutine2 == routine2exercises )
        
        //Confirm we still can't access our nullRoutine.
        let filledNull = userData.Get_Routine(NameOfRoutine: nullRoutine)
        XCTAssert( filledNull.isEmpty == true )
        
        //Confirm deletion works.
        userData.Delete_Routine(NameOfRoutine: routine2name)
        
        //Confirm they were successfully added.
        let deletionRoutines = userData.Get_Routines()
        let deletionRoutine1 = userData.Get_Routine(NameOfRoutine: routine1name)
        let deletionRoutine2 = userData.Get_Routine(NameOfRoutine: routine2name)
        
        XCTAssert( deletionRoutines.count == 1 )
        XCTAssert( deletionRoutines[0].RoutineName == routine1name )
        XCTAssert( deletionRoutines[0].Exercises == routine1exercises )
        XCTAssert( filledRoutines[1].RoutineName == routine2name )
        
        XCTAssert( deletionRoutine1 == routine1exercises )
        XCTAssert( deletionRoutine2.isEmpty == true )
        
        //Confirm we still can't access our nullRoutine.
        let deletionNull = userData.Get_Routine(NameOfRoutine: nullRoutine)
        XCTAssert( deletionNull.isEmpty == true )
    }
    
    func test_UserData_UserExerciseData() {
        
        //Define some variables to test with. Defined so taht we can have an exercise done twice in the same hour, multiple difference exercise the same hour, same exercise on two different days
        let firstName = "Bicep Curls"
        let firstYear = 2019
        let firstMonth = 11
        let firstDay = 01
        let firstHour = 01
        
        let secondName = "Bicep Curls"
        let secondYear = 2019
        let secondMonth = 11
        let secondDay = 01
        let secondHour = 01
        
        let thirdName = "Squats"
        let thirdYear = 2019
        let thirdMonth = 11
        let thirdDay = 01
        let thirdHour = 01
        
        let fourthName = "Bicep Curls"
        let fourthYear = 2019
        let fourthMonth = 10
        let fourthDay = 30
        let fourthHour = 18
        
        let userData = UserData()
        
        //Make sure there aren't any exercies already in place, and that Get_Exercises() behaves as expected when nothing is found.
        let emptyDay1 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 30, TargetHour: 18)
        let emptyDay2 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 11, TargetDay: 01, TargetHour: 01)
        
        XCTAssert( emptyDay1.isEmpty == true )
        XCTAssert( emptyDay2.isEmpty == true )
        
        //Insert our exercises and confirm
        userData.Add_Exercise_Done(ExerciseName: firstName, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        
        let insert1Day1 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 30, TargetHour: 18)
        let insert1Day2 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 11, TargetDay: 01, TargetHour: 01)
        let insert1Null = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 31, TargetHour: 12)
        
        XCTAssert( insert1Day1.isEmpty == true )
        XCTAssert( insert1Day2 == ["Bicep Curls"] )
        XCTAssert( insert1Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: secondName, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let insert2Day1 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 30, TargetHour: 18)
        let insert2Day2 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 11, TargetDay: 01, TargetHour: 01)
        let insert2Null = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 31, TargetHour: 12)
        
        XCTAssert( insert2Day1.isEmpty == true )
        XCTAssert( insert2Day2 == ["Bicep Curls", "Bicep Curls"] )
        XCTAssert( insert2Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: thirdName, YearDone: thirdYear, MonthDone: thirdMonth, DayDone: thirdDay, HourDone: thirdHour)
        
        let insert3Day1 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 30, TargetHour: 18)
        let insert3Day2 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 11, TargetDay: 01, TargetHour: 01)
        let insert3Null = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 31, TargetHour: 12)
        
        XCTAssert( insert3Day1.isEmpty == true )
        XCTAssert( insert3Day2 == ["Bicep Curls", "Bicep Curls", "Squats"] )
        XCTAssert( insert3Null.isEmpty )
        
        userData.Add_Exercise_Done(ExerciseName: fourthName, YearDone: fourthYear, MonthDone: fourthMonth, DayDone: fourthDay, HourDone: fourthHour)
        
        let filledDay1 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 30, TargetHour: 18)
        let filledDay2 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 11, TargetDay: 01, TargetHour: 01)
        let filledNull = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 31, TargetHour: 12)
        
        XCTAssert( filledDay1 == ["Bicep Curls"] )
        XCTAssert( filledDay2 == ["Bicep Curls","Bicep Curls","Squats"] )
        XCTAssert( filledNull.isEmpty == true )
        
        //Delete an exercise and confirm
        userData.Delete_Exercise_Done(ExerciseName: "Squats", YearDone: 2019, MonthDone: 11, DayDone: 01, HourDone: 01)
        
        let deletedDay1 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 30, TargetHour: 18)
        let deletedDay2 = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 11, TargetDay: 01, TargetHour: 01)
        let deletedNull = userData.Get_Exercises(TargetYear: 2019, TargetMonth: 10, TargetDay: 31, TargetHour: 12)
        
        XCTAssert( deletedDay1 == ["Bicep Curls"] )
        XCTAssert( deletedDay2 == ["Bicep Curls","Bicep Curls"] )
        XCTAssert( deletedNull.isEmpty == true )
        
        print("Tests Complete")
    }
    
    func test_UserData_StepCount() {
        
        //Declare some vaiables to use
        let firstSteps1 = Int64(1337)
        let firstSteps2 = Int64(404)
        let firstYear = 2019
        let firstMonth = 10
        let firstDay = 31
        let firstHour = 12
        
        let secondSteps1 = Int64(7887)
        let secondSteps2 = Int64(818)
        let secondYear = 2019
        let secondMonth = 11
        let secondDay = 01
        let secondHour = 01
        
        let userData = UserData()
        
        //Confirm nothing is in the target rows currently
        let firstEmpty = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let secondEmpty = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        
        XCTAssert( firstEmpty == 0 )
        XCTAssert( secondEmpty == 0 )
        
        //Insert and confirm
        userData.Update_Steps_Taken(Steps: firstSteps1, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Update_Steps_Taken(Steps: secondSteps1, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let first1 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second1 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null1 = userData.Get_Steps_Taken(TargetYear: 2018, TargetMonth: 01, TargetDay: 01, TargetHour: 01)
        
        XCTAssert( first1 == firstSteps1 )
        XCTAssert( second1 == secondSteps1 )
        XCTAssert( null1 == 0 )
        
        //Modify the values and confirm again
        userData.Update_Steps_Taken(Steps: firstSteps2, YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        userData.Update_Steps_Taken(Steps: secondSteps2, YearDone: secondYear, MonthDone: secondMonth, DayDone: secondDay, HourDone: secondHour)
        
        let first2 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second2 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null2 = userData.Get_Steps_Taken(TargetYear: 2018, TargetMonth: 01, TargetDay: 01, TargetHour: 01)
        
        XCTAssert( first2 == firstSteps2 )
        XCTAssert( second2 == secondSteps2 )
        XCTAssert( null2 == 0 )
        
        //Confirm the deletion of an item
        userData.Delete_Steps_Taken(YearDone: firstYear, MonthDone: firstMonth, DayDone: firstDay, HourDone: firstHour)
        
        let first3 = userData.Get_Steps_Taken(TargetYear: firstYear, TargetMonth: firstMonth, TargetDay: firstDay, TargetHour: firstHour)
        let second3 = userData.Get_Steps_Taken(TargetYear: secondYear, TargetMonth: secondMonth, TargetDay: secondDay, TargetHour: secondHour)
        let null3 = userData.Get_Steps_Taken(TargetYear: 2018, TargetMonth: 01, TargetDay: 01, TargetHour: 01)
        
        XCTAssert( first3 == 0 )
        XCTAssert( second3 == secondSteps2 )
        XCTAssert( null3 == 0 )
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
