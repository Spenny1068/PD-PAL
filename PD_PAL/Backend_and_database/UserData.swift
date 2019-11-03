//
//  UserData.swift
//  PD_PAL
//
//  This file implements an object to store and manipulate data created by or related to the user.
//  The database implementation is copied from ExerciseDatabase.swift
//
//  Created by whuong on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
 Revision History
 
 - 31/10/2019 : William Huong
    Created file
 - 31/10/2019 : William Huong
    Added some method declarations
 - 31/10/2019 : William Huong
    Created and passed user info unit tests
 - 01/11/2019 : William Huong
    Finished implementing methods
 - 01/11/2019 : William Huong
    User Info now uses a database to store data between reboots
 - 01/11/2019 : William Huong
    Fixed Update_Step_Count(), Added Increment_Step_Count()
 - 01/11/2019 : William Huong
    Added UserInfo database to Delete_Database()
 - 01/11/2019 : William Huong
    Updated User Info columns to match questions asked
 - 02/11/2019 : William Huong
    Delete_userInfo() preserves user name
    Delete_userInfo() and Update_User_Info() no longer dependent on each other
 - 02/11/2019 : William Huong
    Fixed a bug where PoolAccessible is being set to resistBandAvailable in Update_User_Info()
 - 02/11/2019 : William Huong
    Implemented database clearing functions
    FIxed bug where Increment_Steps_Taken() sometimes just replaced the value instead of incrementing
 */

/*
 Known Bugs
 
 - 27/10/2019 : William Xue --- Fixed
    Copied over from ExerciseDatabase.swift because I use the same implementation of an SQLite database.
 
    File persistance of iOS simulator behviour is unknown, it is possible that the file name persists but the file is empty
    thus when we try to insert, the system crashes
 - 31/10/2019 : William Huong --- Fixed
    User name and questionnaire info does not persist through app reboots.
 - 01/11/2019 : William Huong --- Acceptable behaviour
    If there is an exercise is done more than once an hour, Delete_Exercise_Done() will remove all instances of it. This may or may not be an issue that needs to be fixed.
 - 01/11/2019 : William Huong --- Fixed
    Update_Steps_Taken() is not replacing already present values.
 - 02/11/2019 : William Huong --- Fixed
    Incrememt_Steps_Taken() inconsistently just replaces the values instead of incrementing.
 */

import Foundation
import SQLite

class UserData {
    
    //User Info
    let UserInfoDatabaseName = "UserInfo"
    var UserInfo: Connection!
    let UserInfoTable = Table("UserInfo")
    let UserName = Expression<String>("Name")
    let QuestionsAnswered = Expression<Bool>("QuestionsAnswered")
    let WalkingDuration = Expression<Int>("WalkingDuration")
    let ChairAccessible = Expression<Bool>("ChairAccessible")
    let WeightsAccessible = Expression<Bool>("WeightsAccessible")
    let ResistBandAccessible = Expression<Bool>("ResistBandAccessible")
    let PoolAccessible = Expression<Bool>("PoolAccessible")
    //Can take the values 'Light', 'Moderate', 'Intense'
    let Intensity = Expression<String>("Intensity")
    let PushNotifications = Expression<Bool>("PushNotifications")
    
    //Routines database
    let RoutinesDatabaseName = "Routines"
    var Routines: Connection!
    let RoutinesTable = Table("Routines")
    let RoutineName = Expression<String>("Name")
    //Will list the exercise names in the routine in a comma delimited string.
    //Ex: "ex1,ex2,ex3,ex4"
    let RoutineContent = Expression<String>("Content")
    
    //Exercise data database
    let UserExerciseDataDatabaseName = "UserExerciseData"
    var UserExerciseData: Connection!
    let UserExerciseDataTable = Table("ExerciseData")
    let TrendYear = Expression<Int>("Year")
    let TrendMonth = Expression<Int>("Month")
    let TrendDay = Expression<Int>("Day")
    let TrendHour = Expression<Int>("Hour")
    let TrendExercise = Expression<String>("ExerciseName")
    
    //Step count database
    let StepCountDatabaseName = "StepCount"
    var StepCount: Connection!
    let StepCountTable = Table("StepCount")
    let StepYear = Expression<Int>("Year")
    let StepMonth = Expression<Int>("Month")
    let StepDay = Expression<Int>("Day")
    let StepHour = Expression<Int>("Hour")
    let StepsTaken = Expression<Int64>("StepsTaken")
    
    //Misc
    let fileExtension = "sqlite3"
    
    init()
    {

        //Declare some variables we will use to search for our databases.
        var userInfoDatabaseExists = false
        var userInfoDatabaseReady = false
        var routinesDatabaseExists = false
        var routinesDatabaseReady = false
        var exerciseDatabaseExists = false
        var exerciseDatabaseReady = false
        var stepCountDatabaseExists = false
        var stepCountDatabaseReady = false
        
        let userInfoFileName = UserInfoDatabaseName + "." + fileExtension
        let routinesFileName = RoutinesDatabaseName + "." + fileExtension
        let exerciseFileName = UserExerciseDataDatabaseName + "." + fileExtension
        let stepFileName = StepCountDatabaseName + "." + fileExtension
        
        var userInfoURL: URL?
        var routinesURL: URL?
        var exerciseURL: URL?
        var stepURL: URL?
        
        //Start a FileManager object.
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            
            //Get all the files in the Documents directory.
            let documentFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            var fileName: String
            
            //Look at each file to see if it is a file we want.
            for file in documentFiles {
                fileName = file.lastPathComponent
                
                //We need to look for the existance of the file, along with having contents.
                if fileName == userInfoFileName {
                    userInfoDatabaseExists = true
                    userInfoURL = file.absoluteURL
                    
                    do {
                       let fileAttributes = try FileManager.default.attributesOfItem(atPath: file.path)
                        var fileSize = fileAttributes[FileAttributeKey.size] as! UInt64
                        let dict = fileAttributes as NSDictionary
                        fileSize = dict.fileSize()
                        
                        if fileSize != 0 {
                            userInfoDatabaseReady = true
                        }
                    } catch {
                        print("Error checking UserInfo.sqlite3")
                    }
                }
                
                if fileName == routinesFileName {
                    
                    routinesDatabaseExists = true
                    routinesURL = file.absoluteURL
                    
                    do {
                        let fileAttributes = try FileManager.default.attributesOfItem(atPath: file.path)
                        var fileSize = fileAttributes[FileAttributeKey.size] as! UInt64
                        let dict = fileAttributes as NSDictionary
                        fileSize = dict.fileSize()
                        
                        if fileSize != 0 {
                            routinesDatabaseReady = true
                        }
                    } catch {
                        print("Error checking Routines.sqlite3")
                    }
                    
                } else if fileName == exerciseFileName {
                    
                    exerciseDatabaseExists = true
                    exerciseURL = file.absoluteURL
                    
                    do {
                        let fileAttributes = try FileManager.default.attributesOfItem(atPath: file.path)
                        var fileSize = fileAttributes[FileAttributeKey.size] as! UInt64
                        let dict = fileAttributes as NSDictionary
                        fileSize = dict.fileSize()
                        
                        if fileSize != 0 {
                            exerciseDatabaseReady = true
                        }
                    } catch {
                        print("Error checking UserExerciseData.sqlite3")
                    }
                    
                } else if fileName == stepFileName {
                    
                    stepCountDatabaseExists = true
                    stepURL = file.absoluteURL
                    
                    do {
                        let fileAttributes = try FileManager.default.attributesOfItem(atPath: file.path)
                        var fileSize = fileAttributes[FileAttributeKey.size] as! UInt64
                        let dict = fileAttributes as NSDictionary
                        fileSize = dict.fileSize()
                        
                        if fileSize != 0 {
                            stepCountDatabaseReady = true
                        }
                    } catch {
                        print("Error checking StepCount.sqlite3")
                    }
                    
                }
                
            }
        } catch {
            print("Error searching Documents Directory")
        }
        
        if !userInfoDatabaseExists {
            userInfoURL = documentsURL.appendingPathComponent(UserInfoDatabaseName).appendingPathExtension(fileExtension)
        }
        
        if !routinesDatabaseExists {
            routinesURL = documentsURL.appendingPathComponent(RoutinesDatabaseName).appendingPathExtension(fileExtension)
        }
        
        if !exerciseDatabaseExists {
            exerciseURL = documentsURL.appendingPathComponent(UserExerciseDataDatabaseName).appendingPathExtension(fileExtension)
        }
        
        if !stepCountDatabaseExists {
            stepURL = documentsURL.appendingPathComponent(StepCountDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //Connect to each database.
        do {
            let database = try Connection((userInfoURL!).path)
            self.UserInfo = database
            
            //Create the table if the file did not exist or was empty.
            if !userInfoDatabaseReady {
                let createTable = UserInfoTable.create{ (table) in
                    table.column(UserName, primaryKey: true)
                    table.column(QuestionsAnswered)
                    table.column(WalkingDuration)
                    table.column(ChairAccessible)
                    table.column(WeightsAccessible)
                    table.column(ResistBandAccessible)
                    table.column(PoolAccessible)
                    table.column(Intensity)
                    table.column(PushNotifications)
                }
                
                do {
                    try self.UserInfo.run(createTable)
                } catch {
                    print("Error creating UserInfo table")
                }
                
                //User Info is special. We need it to always have a single row.
                self.Update_User_Data(nameGiven: "DEFAULT_NAME", questionsAnswered: false, walkingDuration: 0, chairAvailable: false, weightsAvailable: false, resistBandAvailable: false, poolAvailable: false, intensityDesired: "Light", pushNotificationsDesired: false)
            }
        } catch {
            print("Error connecting to the UserInfo database")
        }
        
        do {
            let database = try Connection((routinesURL!).path)
            self.Routines = database
            
            //Create the table if the file did not exist or was empty.
            if !routinesDatabaseReady {
                let createTable = RoutinesTable.create{ (table) in
                    table.column(RoutineName, primaryKey: true)
                    table.column(RoutineContent)
                }
                
                do {
                    try self.Routines.run(createTable)
                } catch {
                    print("Error creating Routines table")
                }
            }
        } catch {
            print("Error connecting to Routines database")
        }
        
        do {
            let database = try Connection((exerciseURL!).path)
            self.UserExerciseData = database
            
            //Create the table if the file did not exist or was empty.
            if !exerciseDatabaseReady {
                let createTable = UserExerciseDataTable.create{ (table) in
                    table.column(TrendYear)
                    table.column(TrendMonth)
                    table.column(TrendDay)
                    table.column(TrendHour)
                    table.column(TrendExercise)
                }
                
                do {
                    try self.UserExerciseData.run(createTable)
                } catch {
                    print("Error creating UserExerciseData table")
                }
            }
        } catch {
            print("Error connecting to UserExerciseData database")
        }
        
        do {
            let database = try Connection((stepURL!).path)
            self.StepCount = database
            
            //Create the table if the file did not exist or was empty.
            if !stepCountDatabaseReady {
                let createTable = StepCountTable.create{ (table) in
                    table.column(StepYear)
                    table.column(StepMonth)
                    table.column(StepDay)
                    table.column(StepHour)
                    table.column(StepsTaken)
                }
                
                do {
                    try self.StepCount.run(createTable)
                } catch {
                    print("Error creating StepCount table")
                }
                
            }
        } catch {
            print("Error connecting to StepCount database")
        }
        
    }
    
    
/*
Methods
*/
    
    
/*
Methods that get data from class
     These methods will retrieve data from within a database.
*/
    
    //Gets all the non-database user data.
    //Returns the tuple (UserName, WalkingOK, ChairAccess, WeightsAccess, ResistBandAccess, Intensity, PushNotifications)
    func Get_User_Data() -> (UserName: String, QuestionsAnswered: Bool, WalkingDuration: Int, ChairAccessible: Bool, WeightsAccessible: Bool, ResistBandAccessible: Bool, PoolAccessible: Bool, Intensity: String, PushNotifications: Bool) {
        do {
            let userInfo = try UserInfo.pluck(UserInfoTable)
            
            if userInfo == nil {
                return (UserName: "DEFAULT_NAME", QuestionsAnswered: false, WalkingDuration: 0, ChairAccessible: false, WeightsAccessible: false, ResistBandAccessible: false, PoolAccessible: false, Intensity: "Light", PushNotifications: false)
            }
            
            return (UserName: userInfo![UserName], QuestionsAnswered: userInfo![QuestionsAnswered], WalkingDuration: userInfo![WalkingDuration], ChairAccessible: userInfo![ChairAccessible], WeightsAccessible: userInfo![WeightsAccessible], ResistBandAccessible: userInfo![ResistBandAccessible], PoolAccessible: userInfo![PoolAccessible], Intensity: userInfo![Intensity], PushNotifications: userInfo![PushNotifications])
        } catch {
            print("Failed to get User Info")
        }
        
        return (UserName: "DEFAULT_NAME", QuestionsAnswered: false, WalkingDuration: 0, ChairAccessible: false, WeightsAccessible: false, ResistBandAccessible: false, PoolAccessible: false, Intensity: "Light", PushNotifications: false)
    }
    
    //Gets all the routines available.
    //Returns all routines in an array of Tuples of the form ([(RoutineName: String, Exercises: [String])]).
    func Get_Routines() ->([(RoutineName: String, Exercises: [String])]) {
        var returnArr = [(RoutineName: String, Exercises: [String])]()
        
        do {
            for row in try Routines.prepare(RoutinesTable) {
                let routineName = row[RoutineName]
                let routineContents = row[RoutineContent]
                let exerciseList = routineContents.components(separatedBy: ",")
                returnArr.append((RoutineName: routineName, Exercises: exerciseList))
            }
        } catch {
            print("Failed to collect routines")
        }
        
        return returnArr
    }
    
    //Gets a specific routine.
    //Returns an array of exercise names.
    func Get_Routine(NameOfRoutine: String) ->([String]) {
        do {
            for row in try Routines.prepare(RoutinesTable.filter(RoutineName == NameOfRoutine)) {
                let exercises = row[RoutineContent]
                return exercises.components(separatedBy: ",")
            }
        } catch {
            print("Failed to find a routine by the name of \(NameOfRoutine) in Routines database")
        }
        
        return [String]()
    }
    
    //Gets all exercises done in a specific hour.
    //Returns an array of Strings.
    func Get_Exercises(TargetYear: Int, TargetMonth: Int, TargetDay: Int, TargetHour: Int) ->([String]) {
        var returnArr = [String]()
        do {
            for row in try UserExerciseData.prepare(UserExerciseDataTable.filter(TrendYear == TargetYear && TrendMonth == TargetMonth && TrendDay == TargetDay && TrendHour == TargetHour)) {
                returnArr.append(row[TrendExercise])
            }
        } catch {
            print("No exercises found on \(TargetYear)-\(TargetMonth)-\(TargetDay) at \(TargetHour)")
        }
        
        return returnArr
    }
    
    
    
    //Gets all exercises done in all hours
    //Returns an array of Tuples
    func Get_Exercises_all() ->([(nameOfExercise: String, Year: Int, Month: Int, Day: Int, Hour: Int)]) {
        var returnArr = [(nameOfExercise: String, Year: Int,
                          Month: Int, Day: Int, Hour: Int)]()
        do {
            let query = UserExerciseDataTable
            for row in try UserExerciseData.prepare(query) {
                returnArr.append((row[TrendExercise], row[TrendYear],row[TrendMonth],
                                  row[TrendDay],row[TrendHour]))
            }
        } catch {
            print(error)
        }
        
        return returnArr
    }
    
    
    
    
    //Gets the steps taken in a specific hour.
    //Returns an Int64.
    func Get_Steps_Taken(TargetYear: Int, TargetMonth: Int, TargetDay: Int, TargetHour: Int) ->(Int64) {
        do {
            for row in try StepCount.prepare(StepCountTable.filter(TrendYear == TargetYear && TrendMonth == TargetMonth && TrendDay == TargetDay && TrendHour == TargetHour)) {
                return row[StepsTaken]
            }
        } catch {
            print("No step count value was found on \(TargetYear)-\(TargetMonth)-\(TargetDay) at \(TargetHour)")
            print("Returning 0")
        }
        
        return 0
    }
    
/*
Methods that insert or update data.
     These methods will insert new data into a database, and may update as well UserInfo and StepCount.
*/
    
    //Updates the non-database user data.
    //Any parameters that are left as nil will not be updated.
    func Update_User_Data(
        nameGiven: String?,
        questionsAnswered: Bool?,
        walkingDuration: Int?,
        chairAvailable: Bool?,
        weightsAvailable: Bool?,
        resistBandAvailable: Bool?,
        poolAvailable: Bool?,
        intensityDesired: String?,
        pushNotificationsDesired: Bool?)
    {

        //Store the old values
        let currentUserInfo = self.Get_User_Data()
        
        do {
            //Delete what is currently there, since we only have a single user locally
            try UserInfo.run(UserInfoTable.delete())
            
            //Re-insert user
            try UserInfo.run(UserInfoTable.insert(UserName <- (nameGiven ?? currentUserInfo.UserName),
                                                  QuestionsAnswered <- (questionsAnswered ?? currentUserInfo.QuestionsAnswered),
                                                  WalkingDuration <- (walkingDuration ?? currentUserInfo.WalkingDuration),
                                                  ChairAccessible <- (chairAvailable ?? currentUserInfo.ChairAccessible),
                                                  WeightsAccessible <- (weightsAvailable ?? currentUserInfo.WeightsAccessible),
                                                  ResistBandAccessible <- (resistBandAvailable ?? currentUserInfo.ResistBandAccessible),
                                                  PoolAccessible <- (poolAvailable ?? currentUserInfo.PoolAccessible),
                                                  Intensity <- (intensityDesired ?? currentUserInfo.Intensity),
                                                  PushNotifications <- (pushNotificationsDesired ?? currentUserInfo.PushNotifications)
                                                  ))
        } catch {
            print("Failed to update user info")
        }
        
    }
    
    //Add a routine to the Routines database.
    //ExercisesIncluded should be a comma delimited string.
    func Add_Routine(NameOfRoutine: String, ExercisesIncluded: [String]) {
        
        var exerciseString = ""
        
        for exercise in ExercisesIncluded {
            if exerciseString != "" {
                exerciseString = exerciseString + ","
            }
            exerciseString = exerciseString + exercise
        }
        
        do {
            try Routines.run(RoutinesTable.insert( or: .replace, RoutineName <- NameOfRoutine, RoutineContent <- exerciseString))
        } catch {
            print("Failed to insert \(NameOfRoutine) routine into Routines database")
        }
    }
    
    //Add an exercise to the UserExerciseData database.
    //Call this once each time the user completes an exercise.
    func Add_Exercise_Done(ExerciseName: String, YearDone: Int, MonthDone: Int, DayDone: Int, HourDone: Int) {
        do {
            try UserExerciseData.run(UserExerciseDataTable.insert(or: .replace, TrendExercise <- ExerciseName, TrendYear <- YearDone, TrendMonth <- MonthDone, TrendDay <- DayDone, TrendHour <- HourDone))
        } catch {
            print("Failed to to exercise \(ExerciseName) completed on \(DayDone)-\(MonthDone)-\(YearDone) at \(HourDone) into UserExerciseData database")
        }
    }
    
    //Set the steps taken for that hour in the StepCount database.
    //Call this each time you wish to update the number of steps taken within an hour, ignoring what was previously there.
    func Update_Steps_Taken(Steps: Int64, YearDone: Int, MonthDone: Int, DayDone: Int, HourDone: Int) {
        //Theres is an odd behaviour with or: .replace, so it will be easier to just delete the row and re-insert.
        self.Delete_Steps_Taken(YearDone: YearDone, MonthDone: MonthDone, DayDone: DayDone, HourDone: HourDone)
        do {
            try StepCount.run(StepCountTable.insert(or: .replace, StepsTaken <- Steps, StepYear <- YearDone, StepMonth <- MonthDone, StepDay <- DayDone, StepHour <- HourDone))
        } catch {
            print("Failed to insert \(Steps) taken on \(DayDone)-\(MonthDone)-\(YearDone) at \(HourDone) into StepCount database")
        }
    }
    
    //Increments the number of steps taken for a specific hour.
    //Call this function when you want to add extra steps onto what is currently there.
    func Increment_Steps_Taken(Steps: Int64, YearDone: Int, MonthDone: Int, DayDone: Int, HourDone: Int) {
        //Get the current value, then call Update_Step_Count().
        let currentStepCount = self.Get_Steps_Taken(TargetYear: YearDone, TargetMonth: MonthDone, TargetDay: DayDone, TargetHour: HourDone)
        self.Update_Steps_Taken(Steps: (currentStepCount + Steps), YearDone: YearDone, MonthDone: MonthDone, DayDone: DayDone, HourDone: HourDone)
    }
    
/*
Deletion Methods
     These methods will delete data from a database. The exact action is deleting rows, so Delete_Exercise_Done() works slightly differently.
*/
    
    //Delete the user info. Preserves user name.
    func Delete_userInfo() {
        //Grab the current user name.
        let currentUserName = self.Get_User_Data().UserName
        
        //Kill the data in the database.
        do {
            try UserInfo.run(UserInfoTable.delete())
            
            //Re-insert user name plus default values for everything else.
            try UserInfo.run(UserInfoTable.insert(UserName <- currentUserName, QuestionsAnswered <- false, WalkingDuration <- 0, ChairAccessible <- false, WeightsAccessible <- false, ResistBandAccessible <- false, PoolAccessible <- false, Intensity <- "Light", PushNotifications <- false))
        } catch {
            print("Failed to delete user info")
        }
    }
    
    //Deletes the specified routine from the database.
    func Delete_Routine(NameOfRoutine: String) {
        let deletion = RoutinesTable.filter(RoutineName == NameOfRoutine)
        do {
            try Routines.run(deletion.delete())
        } catch {
            print("Failed to delete routine \(NameOfRoutine)")
        }
    }
    
    //Deletes the specified instance of an exercise.
    func Delete_Exercise_Done(ExerciseName: String, YearDone: Int, MonthDone: Int, DayDone: Int, HourDone: Int) {
        let deletion = UserExerciseDataTable.filter(TrendExercise == ExerciseName && TrendYear == YearDone && TrendMonth == MonthDone && TrendDay == DayDone && TrendHour == HourDone)
        do {
            try UserExerciseData.run(deletion.delete())
        } catch {
            print("Failed to delete exercise \(ExerciseName) from \(DayDone)-\(MonthDone)-\(YearDone) at \(HourDone)")
        }
    }
    
    //Deletes the step count from a specific hour.
    //Due to the assumption made in Get_Steps_Taken(), this is equivalent to updating with a value of 0.
    func Delete_Steps_Taken(YearDone: Int, MonthDone: Int, DayDone: Int, HourDone: Int) {
        let deletion = StepCountTable.filter( StepYear == YearDone && StepMonth == MonthDone && StepDay == DayDone && StepHour == HourDone)
        do {
            try StepCount.run(deletion.delete())
        } catch {
            print("Failed to delete step count from \(DayDone)-\(MonthDone)-\(YearDone) at \(HourDone)")
        }
    }
    
/*
Database clear methods
     These methods will clear out the entirety of the data in a database, without deleting the file or breaking the connection to said file.
*/
    
    //This function will completely clear out the data in the UserInfo database without destroying the file or breaking the connection.
    func Clear_UserInfo_Database() {
        do {
            try UserInfo.run(UserInfoTable.delete())
        } catch {
            print("Error clearing the UserInfo database")
        }
    }
    
    //This function will completely clear out the data in the Routines database without destroying the file or breaking the connection.
    func Clear_Routines_Database() {
        do {
            try Routines.run(RoutinesTable.delete())
        } catch {
            print("Error clearing the Routines database")
        }
    }
    
    //This function will completely clear out the data in the UserExerciseData database without destroying the file or breaking the connection.
    func Clear_UserExerciseData_Database() {
        do {
            try UserExerciseData.run(UserExerciseDataTable.delete())
        } catch {
            print("Error clearing the UserExerciseData database")
        }
    }
    
    //This function will completely clear out the data in the StepCount database without destroying the file or breaking the connection.
    func Clear_StepCount_Database() {
        do {
            try StepCount.run(StepCountTable.delete())
        } catch {
            print("Error clearing the StepCount database")
        }
    }
    
/*
Testing Methods
     These methods are methods that are either unlikely to be used or should not be used in normal operation. Some methods 'break' the object, and are useful purely for testing.
*/

    //Searches for and then deletes the .sqlite3 file for the specified database.
    //Almost 1:1 copy of the version William Xue wrote for ExerciseDatabase.
    //Only use this for temporary testing. Since you need to instantiate the class to call this method, you will get errors about breaking the connections to the database.
    //Ideally you instantiate a temp instance of this class to use this function, since there is currently no functionality to recreate and reconnect if the file is deleted after the constructor finishes.
    func Delete_Database_File(dbToDelete: String) {
        
        var dbName: String
        
        switch dbToDelete {
        case UserInfoDatabaseName:
            print("Deleting the UserInfo database")
            dbName = UserInfoDatabaseName
        case RoutinesDatabaseName:
            print("Deleting the Routines database")
            dbName = RoutinesDatabaseName
        case UserExerciseDataDatabaseName:
            print("Deleting the UserExerciseData database")
            dbName = UserExerciseDataDatabaseName
        case StepCountDatabaseName:
            print("Deleting the StepCount database")
            dbName = StepCountDatabaseName
        default:
            print("Error: Invalid database")
            return
        }
        
        let fileName = dbName + "." + fileExtension
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for file in files {
                if file.lastPathComponent == fileName {
                    do {
                        try FileManager.default.removeItem(at: file.absoluteURL)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        } catch {
            print("\(error)")
        }
        
    }
    
}
