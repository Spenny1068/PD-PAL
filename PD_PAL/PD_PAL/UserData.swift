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
 */

/*
 Known Bugs
 
 - 27/10/2019 : William Xue
    Copied over from ExerciseDatabase.swift because I use the same implementation of an SQLite database.
 
    File persistance of iOS simulator behviour is unknown, it is possible that the file name persists but the file is empty
    thus when we try to insert, the system crashes
 - 31/10/2019 : William Huong
    User name and questionnaire info does not persist through app reboots.
 */

import Foundation
import SQLite

class UserData {
    
    //Non-database user data.
    var UserName: String
    var QuestionsAnswered: Bool
    var WalkingOK: Bool
    var ChairAccess: Bool
    var WeightsAccess: Bool
    var	ResistBandAccess: Bool
    var Intensity: Int64
    var PushNotifications: Bool
    
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
    let TrendYear = Expression<Int64>("Year")
    let TrendMonth = Expression<Int64>("Month")
    let TrendDay = Expression<Int64>("Day")
    let TrendHour = Expression<Int64>("Hour")
    let TrendExercise = Expression<String>("ExerciseName")
    
    //Step count database
    let StepCountDatabaseName = "StepCount"
    var StepCount: Connection!
    let StepCountTable = Table("StepCount")
    let StepYear = Expression<Int64>("Year")
    let StepMonth = Expression<Int64>("Month")
    let StepDay = Expression<Int64>("Day")
    let StepHour = Expression<Int64>("Hour")
    let StepsTaken = Expression<Int64>("StepsTaken")
    
    //Misc
    let fileExtension = "sqlite3"
    
    init(
        nameGiven: String,
        questionsAnswered: Bool?,
        walkingDesired: Bool?,
        chairAvailable: Bool?,
        weightsAvailable: Bool?,
        resistBandAvailable: Bool?,
        intensityDesired: Int64?,
        pushNotificationsDesired: Bool?)
    {
        
        UserName = nameGiven
        QuestionsAnswered = questionsAnswered ?? false
        WalkingOK = walkingDesired ?? false
        ChairAccess = chairAvailable ?? false
        WeightsAccess = weightsAvailable ?? false
        ResistBandAccess = resistBandAvailable ?? false
        Intensity = intensityDesired ?? 0
        PushNotifications = pushNotificationsDesired ?? false
        
        //Declare some variables we will use to search for our databases.
        var routinesDatabaseExists = false
        var routinesDatabaseReady = false
        var exerciseDatabaseExists = false
        var exerciseDatabaseReady = false
        var stepCountDatabaseExists = false
        var stepCountDatabaseReady = false
        
        let routinesFileName = RoutinesDatabaseName + "." + fileExtension
        let exerciseFileName = UserExerciseDataDatabaseName + "." + fileExtension
        let stepFileName = StepCountDatabaseName + "." + fileExtension
        
        var routinesURL: URL?
        var exerciseURL: URL?
        var stepURL: URL?
        
        //Start a FileManager object.
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            
            //Get all the files in the Documents directory.
            let documentFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            //Look at each file to see if it is a file we want.
            for file in documentFiles {
                var fileName = file.lastPathComponent
                
                //We need to look for the existance of the file, along with having contents.
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
*/
    
    //Gets all the non-database user data.
    //Returns the tuple (UserName, WalkingOK, ChairAccess, WeightsAccess, ResistBandAccess, Intensity, PushNotifications)
    func Get_User_Data() -> (UserName: String, QuestionsAnswered: Bool, WalkingOK: Bool, ChairAccess: Bool, WeightsAccess: Bool, ResistBandAccess: Bool, Intensity: Int64, PushNotifications: Bool){
        return (UserName, QuestionsAnswered, WalkingOK, ChairAccess, WeightsAccess, ResistBandAccess, Intensity, PushNotifications)
    }
    
    //Gets all the routines available.
    //Returns all routines in an array of Tuples of the form (RoutineName: String, ExercisesString: String).
    func Get_Routines() {
        
    }
    
    //Gets a specific routine.
    //Returns an array of exercise names.
    func Get_Routine(RoutineName: String) {
        
    }
    
    //Gets all exercises done in a specific hour.
    //Returns an array of Strings.
    func Get_Exercises(TargetYear: Int64, TargetMonth: Int64, TargetDay: Int64, TargetHour: Int64) {
        
    }
    
    //Gets the steps taken in a specific hour.
    //Returns an Int64.
    func Get_Steps(TargetYear: Int64, TargetMonth: Int64, TargetDay: Int64, TargetHour: Int64) {
        
    }
    
/*
Methods that insert or update data.
*/
    
    //Updates the non-database user data.
    //Any parameters that are left as nil will not be updated.
    func Update_User_Data(
        nameGiven: String?,
        questionsAnswered: Bool?,
        walkingDesired: Bool?,
        chairAvailable: Bool?,
        weightsAvailable: Bool?,
        resistBandAvailable: Bool?,
        intensityDesired: Int64?,
        pushNotificationsDesired: Bool?)
    {
        //Makes use of the nil-coalescing operator. Equivalent to: if b != nil { a = b } else { a = c }
        UserName = nameGiven ?? UserName
        QuestionsAnswered = questionsAnswered ?? QuestionsAnswered
        WalkingOK = walkingDesired ?? WalkingOK
        ChairAccess = chairAvailable ?? ChairAccess
        WeightsAccess = weightsAvailable ?? WeightsAccess
        ResistBandAccess = resistBandAvailable ?? ResistBandAccess
        Intensity = intensityDesired ?? Intensity
        PushNotifications = pushNotificationsDesired ?? PushNotifications
    }
    
    //Add a routine to the Routines database.
    //ExercisesIncluded should be a comma delimited string.
    func Add_Routine(Name: String, ExercisesIncluded: String) {
        
    }
    
    //Add an exercise to the UserExerciseData database.
    //Call this once each time the user completes an exercise.
    //If any one of YearDone, MonthDone, DayDone, HourDone are left as nil, assumes that the values should be set to the current time and date.
    func Add_Exercise_Done(exerciseName: String, YearDone: Int64?, MonthDone: Int64?, DayDone: Int64?, HourDone: Int64?) {
        
    }
    
    //Set the steps taken for that hour to the StepCount database.
    //Call this each time you wish to update the number of steps taken within an hour.
    //If any one of YearDone, MonthDone, DayDone, HourDone are left as nil, assumes that the values should be set to the current time and date.
    func Update_Steps_Taken(Steps: Int64, YearDone: Int64?, MonthDone: Int64?, DayDone: Int64?, HourDone: Int64?) {
        
    }
    
/*
Auxiliary Methods
*/

    //Searches for and then deletes the .sqlite3 file for the specified database.
    //Almost 1:1 copy of the version William Xue wrote for ExerciseDatabase.
    func Delete_Database(dbToDelete: String) {
        
        var dbName: String
        
        switch dbToDelete {
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
