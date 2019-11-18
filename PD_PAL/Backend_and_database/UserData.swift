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
    Fixed bug where Increment_Steps_Taken() sometimes just replaced the value instead of incrementing
 - 02/11/2019 : William Xue
    Added method to get all exercises in UserExerciseData database
 - 11/11/2019 : William Huong
    Added UUID column to UserInfo database
 - 14/11/2019 : William Huong
    init() now loads a routine when creating the table or file.
 - 14/11/2019 : William Huong
    Added FirestoreOK column to UserInfo database
 - 14/11/2019 : William Huong
    Added LastBackup column to UserInfo datebase
 - 16/11/2019 : William Huong
    Added Name_Available() function
 - 17/11/2019 : William huong
    Added init(DatabaseIdentifier: String) for Firestore testing
 - 17/11/2019 : William Huong
    Split LastBackup column into three separate ones
 - 17/11/2019 : William Huong
    UserUUID is now just UserName until user authentication is implemented.
 - 17/11/2019 : William Huong
    The insert methods now also call the relevant method from UserData_Firestore
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
import Firebase

/*
 
 This class will contain all of the data related to the user. It is a glorified wrapper for the 4 different databases we have chosen to implement persistent storage.
 
 The four databases are:
 - UserInfo: This database stores the name the user gives us, along with their answers to our questionnaire on first launch
    Columns:
        - UUID = <String> A unique identifier for Firebase
        - UserName = <String> The name the user provides
        - QuestionsAnswered = <Bool> Whether or not the user answered the questionnaire
        - WalkingDuration = <Int> The duration for a walking exercise provided by the user
        - ChairAccessible = <Bool> Whether or not the user has access to a chair
        - WeightsAccessible = <Boo> Whether or not the user has access to weights
        - ResistBandAccessible = <Bool> Whether or not the user has access to a resistance band
        - PoolAccessible = <Bool> Whether or not the user has access to a pool
        - Intensity = <String> The desired workout intensity. Can be "Light", "Moderate", "Intense"
        - PushNotifications = <Bool> Whether or not the user would like to receive push notifications
        - FirestoreOK = <Bool> Whether or not the user wants to have their data backed up to Firebase
        - LastBackup = <String> The last time the user data was successfully pushed to Firebase
 
 - Routines: This database stores the routines that are created.
    Columns:
        - RoutineName = <String> The name of the routine
        - RoutineContent = <String> The exercises in the routine. This should be a comma-delimited string.
 
 - UserExerciseData: This database stores each instance of an exercise the user does for every hour.
    Columns:
        - TrendYear = <Int> The year the exercise was done in
        - TrendMonth = <Int> The month the exercise was done in. Should be [1,12]
        - TrendDay = <Int> The day the exercise was done in. Should be [1,31]
        - TrendHour = <Int> The hour the exercise was done in. Should be [0,23]
        - TrendExercise = <Int> The name of the exercise done.
 
 - Step Count: This database stores the number of steps the user takes every hour.
    Columns:
        - StepYear = <Int> The year the steps were taken in
        - StepMonth = <Int> The month the steps were taken in. Should be [1,12]
        - StepDay = <Int> The day the steps were taken in. Should be [1,31]
        - StepHour = <Int> The hour the steps were taken in. Should be [0,23]
        - StepsTaken = <Int64> The number of steps taken
 
*/

class UserData {
    
    //User Info
    private var UserInfoDatabaseName = "UserInfo"
    private var UserInfo: Connection!
    private let UserInfoTable = Table("UserInfo")
    private let UserUUID = Expression<String>("UUID")
    private let UserName = Expression<String>("Name")
    private let QuestionsAnswered = Expression<Bool>("QuestionsAnswered")
    private let WalkingDuration = Expression<Int>("WalkingDuration")
    private let ChairAccessible = Expression<Bool>("ChairAccessible")
    private let WeightsAccessible = Expression<Bool>("WeightsAccessible")
    private let ResistBandAccessible = Expression<Bool>("ResistBandAccessible")
    private let PoolAccessible = Expression<Bool>("PoolAccessible")
    //Can take the values 'Light', 'Moderate', 'Intense'
    private let Intensity = Expression<String>("Intensity")
    private let PushNotifications = Expression<Bool>("PushNotifications")
    private let FirestoreOK = Expression<Bool>("FirestoreOK")
    private let LastUserInfoBackup = Expression<String>("LastUserInfoBackup")
    private let LastRoutinesBackup = Expression<String>("LastRoutinesBackup")
    private let LastExerciseBackup = Expression<String>("LastExerciseBackup")
    
    //Routines database
    private var RoutinesDatabaseName = "Routines"
    private var Routines: Connection!
    private let RoutinesTable = Table("Routines")
    private let RoutineName = Expression<String>("Name")
    //Will list the exercise names in the routine in a comma delimited string.
    //Ex: "ex1,ex2,ex3,ex4"
    private let RoutineContent = Expression<String>("Content")
    
    //Exercise data database
    private var UserExerciseDataDatabaseName = "UserExerciseData"
    private var UserExerciseData: Connection!
    private let UserExerciseDataTable = Table("ExerciseData")
    private let TrendYear = Expression<Int>("Year")
    private let TrendMonth = Expression<Int>("Month")
    private let TrendDay = Expression<Int>("Day")
    private let TrendHour = Expression<Int>("Hour")
    private let TrendExercise = Expression<String>("ExerciseName")
    
    //Step count database
    private var StepCountDatabaseName = "StepCount"
    private var StepCount: Connection!
    private let StepCountTable = Table("StepCount")
    private let StepYear = Expression<Int>("Year")
    private let StepMonth = Expression<Int>("Month")
    private let StepDay = Expression<Int>("Day")
    private let StepHour = Expression<Int>("Hour")
    private let StepsTaken = Expression<Int64>("StepsTaken")
    
    //Misc
    private let fileExtension = "sqlite3"
   
    //To make the rest of the code easier
    private let dateFormatter = DateFormatter()
    private let dateFormat = "MMM d, yyyy, hh:mm:ss a"
    private let yeOldDateString = "Jan 1, 1000, 12:00:00 AM"
    private let yeOldDate: Date
    
    /*
    Constructor. This constructor will look for the database files and connect to them.
    If the database is empty, it will write the table to the file.
    If the databse file does not exist, it will create the file, then write the table to the file.
     
     This should be the constructor used.
    */
    init()
    {
        //Set up the date formatter
        self.dateFormatter.calendar = Calendar.current
        self.dateFormatter.dateFormat = self.dateFormat
        self.yeOldDate = dateFormatter.date(from: self.yeOldDateString)!
        
        //Declare some variables we will use to keep track of the state of our databases on initialization
        var userInfoDatabaseExists = false
        var userInfoDatabaseReady = false
        var routinesDatabaseExists = false
        var routinesDatabaseReady = false
        var exerciseDatabaseExists = false
        var exerciseDatabaseReady = false
        var stepCountDatabaseExists = false
        var stepCountDatabaseReady = false
        
        //Define the filenames for the databases
        let userInfoFileName = UserInfoDatabaseName + "." + fileExtension
        let routinesFileName = RoutinesDatabaseName + "." + fileExtension
        let exerciseFileName = UserExerciseDataDatabaseName + "." + fileExtension
        let stepFileName = StepCountDatabaseName + "." + fileExtension
        
        //Define a variable to hold the location of each database file
        var userInfoURL: URL?
        var routinesURL: URL?
        var exerciseURL: URL?
        var stepURL: URL?
        
        //Start a FileManager object.
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        //Start searching for the database files
        do {
            
            //Get all the files in the Documents directory.
            let documentFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            //Temp variable to hold filenames of interest during search
            var fileName: String
            
            //Look at each file to see if it is a file we want.
            for file in documentFiles {
                fileName = file.lastPathComponent
                
                
                if fileName == userInfoFileName {
                    
                    //Found the UserInfo database file
                    userInfoDatabaseExists = true
                    userInfoURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
                    
                } else if fileName == routinesFileName {
                    
                    //Found the Routines database file
                    routinesDatabaseExists = true
                    routinesURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
                    
                    //Found the UserExerciseData database file
                    exerciseDatabaseExists = true
                    exerciseURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
                    
                    //Found the StepCount database file
                    stepCountDatabaseExists = true
                    stepURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
        
        //The UserInfo database file does not exist. Create it at the root of the documents directory
        if !userInfoDatabaseExists {
            userInfoURL = documentsURL.appendingPathComponent(UserInfoDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //The Routines database file does not exist. Create it at the root of the documents directory
        if !routinesDatabaseExists {
            routinesURL = documentsURL.appendingPathComponent(RoutinesDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //The UserExerciseData database file does not exist. Create it at the root of the documents directory
        if !exerciseDatabaseExists {
            exerciseURL = documentsURL.appendingPathComponent(UserExerciseDataDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //The StepCount database file does not exist. Create it at the root of the documents directory
        if !stepCountDatabaseExists {
            stepURL = documentsURL.appendingPathComponent(StepCountDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //Connect to each database.
        do {
            print("UserInfo database located at:")
            print("\(userInfoURL!)")
            
            let database = try Connection((userInfoURL!).path)
            self.UserInfo = database
            
            //Create the table if the file did not exist or was empty.
            if !userInfoDatabaseReady {
                //Create the table
                let createTable = UserInfoTable.create{ (table) in
                    table.column(UserUUID, primaryKey: true)
                    table.column(UserName)
                    table.column(QuestionsAnswered)
                    table.column(WalkingDuration)
                    table.column(ChairAccessible)
                    table.column(WeightsAccessible)
                    table.column(ResistBandAccessible)
                    table.column(PoolAccessible)
                    table.column(Intensity)
                    table.column(PushNotifications)
                    table.column(FirestoreOK)
                    table.column(LastUserInfoBackup)
                    table.column(LastRoutinesBackup)
                    table.column(LastExerciseBackup)
                }
                
                //Write the table to the database file
                do {
                    try self.UserInfo.run(createTable)
                } catch {
                    print("Error creating UserInfo table")
                }
                
                //User Info is special. We need it to always have a single row.
                
                //Generate a UUID.
                let uuid = NSUUID().uuidString
                
                print("Inserting new user into empty UserInfo database, UUID: \(uuid)")
                
                //Set the last backup value to a far enough date such that a backup will trigger as soon as possible.
                print("Setting last backup date to \(self.yeOldDateString)")
                
                do {
                    try self.UserInfo.run(UserInfoTable.insert(UserUUID <- uuid, UserName <- "DEFAULT_NAME", QuestionsAnswered <- false, WalkingDuration <- 0, ChairAccessible <- false, WeightsAccessible <- false, ResistBandAccessible <- false, PoolAccessible <- false, Intensity <- "Light", PushNotifications <- false, FirestoreOK <- false, LastUserInfoBackup <- self.yeOldDateString, LastRoutinesBackup <- self.yeOldDateString, LastExerciseBackup <- self.yeOldDateString))
                } catch {
                    print("Error inserting default user row into UserInfo database")
                }
            }
        } catch {
            print("Error connecting to the UserInfo database")
        }
        
        do {
            print("Routines database located at:")
            print("\(routinesURL!)")
            
            let database = try Connection((routinesURL!).path)
            self.Routines = database
            
            //Create the table if the file did not exist or was empty.
            if !routinesDatabaseReady {
                //Create the table
                let createTable = RoutinesTable.create{ (table) in
                    table.column(RoutineName, primaryKey: true)
                    table.column(RoutineContent)
                }
                
                //Write the table to the database file
                do {
                    try self.Routines.run(createTable)
                } catch {
                    print("Error creating Routines table")
                }
                
                // hardcode 3 default routines
                self.Add_Routine(NameOfRoutine: "Happy Day Workout", ExercisesIncluded: ["WALL PUSH-UP", "WALKING", "SINGLE LEG STANCE"])
                self.Add_Routine(NameOfRoutine: "Friday Night Chill", ExercisesIncluded: ["WALKING", "WALKING", "WALKING"])
                self.Add_Routine(NameOfRoutine: "Monday Morning Mood", ExercisesIncluded: ["WALL PUSH-UP", "WALL PUSH-UP", "WALL PUSH-UP"])
            }
        } catch {
            print("Error connecting to Routines database")
        }
        
        do {
            print("UserExerciseData database located at:")
            print("\(exerciseURL!)")
            
            let database = try Connection((exerciseURL!).path)
            self.UserExerciseData = database
            
            //Create the table if the file did not exist or was empty.
            if !exerciseDatabaseReady {
                //Create the table
                let createTable = UserExerciseDataTable.create{ (table) in
                    table.column(TrendYear)
                    table.column(TrendMonth)
                    table.column(TrendDay)
                    table.column(TrendHour)
                    table.column(TrendExercise)
                }
                
                //Write the table to the database file
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
            print("StepCount database located at:")
            print("\(stepURL!)")
            
            let database = try Connection((stepURL!).path)
            self.StepCount = database
            
            //Create the table if the file did not exist or was empty.
            if !stepCountDatabaseReady {
                //Create the table
                let createTable = StepCountTable.create{ (table) in
                    table.column(StepYear)
                    table.column(StepMonth)
                    table.column(StepDay)
                    table.column(StepHour)
                    table.column(StepsTaken)
                }
                
                //Write the table to the database file
                do {
                    try self.StepCount.run(createTable)
                } catch {
                    print("Error creating StepCount table")
                }
                
            }
        } catch {
            print("Error connecting to StepCount database")
        }
        
        self.Add_Routine(NameOfRoutine: "Happy Day Workout", ExercisesIncluded: ["SHOULDER RAISES", "HEEL TO TOE", "LATERAL RAISES"])

        //self.Add_Routine(NameOfRoutine: "Friday Night Chill", ExercisesIncluded: ["CHEST STRETCH", "SIDE LEG LIFT", "WALL PUSH-UP"])

        self.Add_Routine(NameOfRoutine: "Monday Morning Mood", ExercisesIncluded: ["ARM RAISES", "TRICEP KICKBACKS", "KNEE MARCHING"])

        self.Add_Routine(NameOfRoutine: "Friday Night Chill", ExercisesIncluded: ["CHEST STRETCH", "WALL PUSH-UP", "SIDE LEG LIFT"])

    }
    
    /*
    Constructor. This constructor will look for the database files and connect to them.
    If the database is empty, it will write the table to the file.
    If the databse file does not exist, it will create the file, then write the table to the file.
    
     This constructor should only be used when you need separate database files. Really only for the Firebase components, since they all run asynchronously and in parallel.
    */
    init(DatabaseIdentifier: String)
    {
        //Modify the database names
        self.UserInfoDatabaseName = self.UserInfoDatabaseName + "_" + DatabaseIdentifier
        self.RoutinesDatabaseName = self.RoutinesDatabaseName + "_" + DatabaseIdentifier
        self.UserExerciseDataDatabaseName = self.UserExerciseDataDatabaseName + "_" + DatabaseIdentifier
        self.StepCountDatabaseName = self.StepCountDatabaseName + "_" + DatabaseIdentifier
        
        //Set up the date formatter
        self.dateFormatter.calendar = Calendar.current
        self.dateFormatter.dateFormat = self.dateFormat
        self.yeOldDate = dateFormatter.date(from: self.yeOldDateString)!
        
        //Declare some variables we will use to keep track of the state of our databases on initialization
        var userInfoDatabaseExists = false
        var userInfoDatabaseReady = false
        var routinesDatabaseExists = false
        var routinesDatabaseReady = false
        var exerciseDatabaseExists = false
        var exerciseDatabaseReady = false
        var stepCountDatabaseExists = false
        var stepCountDatabaseReady = false
        
        //Define the filenames for the databases
        let userInfoFileName = UserInfoDatabaseName + "." + fileExtension
        let routinesFileName = RoutinesDatabaseName + "." + fileExtension
        let exerciseFileName = UserExerciseDataDatabaseName + "." + fileExtension
        let stepFileName = StepCountDatabaseName + "." + fileExtension
        
        //Define a variable to hold the location of each database file
        var userInfoURL: URL?
        var routinesURL: URL?
        var exerciseURL: URL?
        var stepURL: URL?
        
        //Start a FileManager object.
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        //Start searching for the database files
        do {
            
            //Get all the files in the Documents directory.
            let documentFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            //Temp variable to hold filenames of interest during search
            var fileName: String
            
            //Look at each file to see if it is a file we want.
            for file in documentFiles {
                fileName = file.lastPathComponent
                
                
                if fileName == userInfoFileName {
                    
                    //Found the UserInfo database file
                    userInfoDatabaseExists = true
                    userInfoURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
                    
                } else if fileName == routinesFileName {
                    
                    //Found the Routines database file
                    routinesDatabaseExists = true
                    routinesURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
                    
                    //Found the UserExerciseData database file
                    exerciseDatabaseExists = true
                    exerciseURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
                    
                    //Found the StepCount database file
                    stepCountDatabaseExists = true
                    stepURL = file.absoluteURL
                    
                    //Check if the file is empty. If it is, then the table has not been written to the database file
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
        
        //The UserInfo database file does not exist. Create it at the root of the documents directory
        if !userInfoDatabaseExists {
            userInfoURL = documentsURL.appendingPathComponent(UserInfoDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //The Routines database file does not exist. Create it at the root of the documents directory
        if !routinesDatabaseExists {
            routinesURL = documentsURL.appendingPathComponent(RoutinesDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //The UserExerciseData database file does not exist. Create it at the root of the documents directory
        if !exerciseDatabaseExists {
            exerciseURL = documentsURL.appendingPathComponent(UserExerciseDataDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //The StepCount database file does not exist. Create it at the root of the documents directory
        if !stepCountDatabaseExists {
            stepURL = documentsURL.appendingPathComponent(StepCountDatabaseName).appendingPathExtension(fileExtension)
        }
        
        //Connect to each database.
        do {
            print("UserInfo database located at:")
            print("\(userInfoURL!)")
            
            let database = try Connection((userInfoURL!).path)
            self.UserInfo = database
            
            //Create the table if the file did not exist or was empty.
            if !userInfoDatabaseReady {
                //Create the table
                let createTable = UserInfoTable.create{ (table) in
                    table.column(UserUUID, primaryKey: true)
                    table.column(UserName)
                    table.column(QuestionsAnswered)
                    table.column(WalkingDuration)
                    table.column(ChairAccessible)
                    table.column(WeightsAccessible)
                    table.column(ResistBandAccessible)
                    table.column(PoolAccessible)
                    table.column(Intensity)
                    table.column(PushNotifications)
                    table.column(FirestoreOK)
                    table.column(LastUserInfoBackup)
                    table.column(LastRoutinesBackup)
                    table.column(LastExerciseBackup)
                }
                
                //Write the table to the database file
                do {
                    try self.UserInfo.run(createTable)
                } catch {
                    print("Error creating UserInfo table")
                }
                
                //User Info is special. We need it to always have a single row.
                
                //Generate a UUID.
                let uuid = NSUUID().uuidString
                
                print("Inserting new user into empty UserInfo database, UUID: \(uuid)")
                
                //Set the last backup value to a far enough date such that a backup will trigger as soon as possible.
                print("Setting last backup date to \(self.yeOldDateString)")
                
                do {
                    try self.UserInfo.run(UserInfoTable.insert(UserUUID <- uuid, UserName <- "DEFAULT_NAME", QuestionsAnswered <- false, WalkingDuration <- 0, ChairAccessible <- false, WeightsAccessible <- false, ResistBandAccessible <- false, PoolAccessible <- false, Intensity <- "Light", PushNotifications <- false, FirestoreOK <- false, LastUserInfoBackup <- self.yeOldDateString, LastRoutinesBackup <- self.yeOldDateString, LastExerciseBackup <- self.yeOldDateString))
                } catch {
                    print("Error inserting default user row into UserInfo database")
                }
            }
        } catch {
            print("Error connecting to the UserInfo database")
        }
        
        do {
            print("Routines database located at:")
            print("\(routinesURL!)")
            
            let database = try Connection((routinesURL!).path)
            self.Routines = database
            
            //Create the table if the file did not exist or was empty.
            if !routinesDatabaseReady {
                //Create the table
                let createTable = RoutinesTable.create{ (table) in
                    table.column(RoutineName, primaryKey: true)
                    table.column(RoutineContent)
                }
                
                //Write the table to the database file
                do {
                    try self.Routines.run(createTable)
                } catch {
                    print("Error creating Routines table")
                }
                
                // hardcode 3 default routines
                self.Add_Routine(NameOfRoutine: "Happy Day Workout", ExercisesIncluded: ["WALL PUSH-UP", "WALKING", "SINGLE LEG STANCE"])
                self.Add_Routine(NameOfRoutine: "Friday Night Chill", ExercisesIncluded: ["WALKING", "WALKING", "WALKING"])
                self.Add_Routine(NameOfRoutine: "Monday Morning Mood", ExercisesIncluded: ["WALL PUSH-UP", "WALL PUSH-UP", "WALL PUSH-UP"])
            }
        } catch {
            print("Error connecting to Routines database")
        }
        
        do {
            print("UserExerciseData database located at:")
            print("\(exerciseURL!)")
            
            let database = try Connection((exerciseURL!).path)
            self.UserExerciseData = database
            
            //Create the table if the file did not exist or was empty.
            if !exerciseDatabaseReady {
                //Create the table
                let createTable = UserExerciseDataTable.create{ (table) in
                    table.column(TrendYear)
                    table.column(TrendMonth)
                    table.column(TrendDay)
                    table.column(TrendHour)
                    table.column(TrendExercise)
                }
                
                //Write the table to the database file
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
            print("StepCount database located at:")
            print("\(stepURL!)")
            
            let database = try Connection((stepURL!).path)
            self.StepCount = database
            
            //Create the table if the file did not exist or was empty.
            if !stepCountDatabaseReady {
                //Create the table
                let createTable = StepCountTable.create{ (table) in
                    table.column(StepYear)
                    table.column(StepMonth)
                    table.column(StepDay)
                    table.column(StepHour)
                    table.column(StepsTaken)
                }
                
                //Write the table to the database file
                do {
                    try self.StepCount.run(createTable)
                } catch {
                    print("Error creating StepCount table")
                }
                
            }
        } catch {
            print("Error connecting to StepCount database")
        }

         self.Add_Routine(NameOfRoutine: "Happy Day Workout", ExercisesIncluded: ["SHOULDER RAISES", "HEEL TO TOE", "LATERAL RAISES"])

        //self.Add_Routine(NameOfRoutine: "Friday Night Chill", ExercisesIncluded: ["CHEST STRETCH", "SIDE LEG LIFT", "WALL PUSH-UP"])

        self.Add_Routine(NameOfRoutine: "Monday Morning Mood", ExercisesIncluded: ["ARM RAISES", "TRICEP KICKBACKS", "KNEE MARCHING"])

        self.Add_Routine(NameOfRoutine: "Friday Night Chill", ExercisesIncluded: ["CHEST STRETCH", "WALL PUSH-UP", "SIDE LEG LIFT"])
        
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
    func Get_User_Data() -> (UserUUID: String, UserName: String, QuestionsAnswered: Bool, WalkingDuration: Int, ChairAccessible: Bool, WeightsAccessible: Bool, ResistBandAccessible: Bool, PoolAccessible: Bool, Intensity: String, PushNotifications: Bool, FirestoreOK: Bool) {
        do {
            let userInfo = try UserInfo.pluck(UserInfoTable)
            
            if userInfo == nil {
                let uuid = NSUUID().uuidString
                
                print("UserInfo database was empty. Inserting default values with randomly generated UUID: \(uuid)")
                
                do {
                    try UserInfo.run(UserInfoTable.insert(UserUUID <- uuid, UserName <- "DEFAULT_NAME", QuestionsAnswered <- false, WalkingDuration <- 0, ChairAccessible <- false, WeightsAccessible <- false, ResistBandAccessible <- false, PoolAccessible <- false, Intensity <- "Light", PushNotifications <- false, FirestoreOK <- false, LastUserInfoBackup <- self.yeOldDateString, LastRoutinesBackup <- self.yeOldDateString, LastExerciseBackup <- self.yeOldDateString))
                } catch {
                    print("Error inserting default user row during read")
                }
                
                return (UserUUID: uuid, UserName: "DEFAULT_NAME", QuestionsAnswered: false, WalkingDuration: 0, ChairAccessible: false, WeightsAccessible: false, ResistBandAccessible: false, PoolAccessible: false, Intensity: "Light", PushNotifications: false, FirestoreOK: false)
            }
            
            return (UserUUID: userInfo![UserUUID], UserName: userInfo![UserName], QuestionsAnswered: userInfo![QuestionsAnswered], WalkingDuration: userInfo![WalkingDuration], ChairAccessible: userInfo![ChairAccessible], WeightsAccessible: userInfo![WeightsAccessible], ResistBandAccessible: userInfo![ResistBandAccessible], PoolAccessible: userInfo![PoolAccessible], Intensity: userInfo![Intensity], PushNotifications: userInfo![PushNotifications], FirestoreOK: userInfo![FirestoreOK])
        } catch {
            print("Failed to get User Info")
        }
        //Should never come here.
        return (UserUUID: "NULL", UserName: "DEFAULT_NAME", QuestionsAnswered: false, WalkingDuration: 0, ChairAccessible: false, WeightsAccessible: false, ResistBandAccessible: false, PoolAccessible: false, Intensity: "Light", PushNotifications: false, FirestoreOK: false)
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
    
    //Get the last time the user data was backed up.
    func Get_LastBackup() -> (UserInfo: Date, Routines: Date, Exercise: Date) {
        var returnVal = (UserInfo: self.yeOldDate, Routines: self.yeOldDate, Exercise: self.yeOldDate)
        
        do {
            let userRow = try UserInfo.pluck(UserInfoTable)
            let userInfoDate = userRow![LastUserInfoBackup]
            let routinesDate = userRow![LastRoutinesBackup]
            let exerciseDate = userRow![LastExerciseBackup]
            
            returnVal = (UserInfo: dateFormatter.date(from: userInfoDate) ?? self.yeOldDate, Routines: dateFormatter.date(from: routinesDate) ?? self.yeOldDate, Exercise: dateFormatter.date(from: exerciseDate) ?? self.yeOldDate)
        } catch {
            print("Error retrieving last backup date")
        }
        
        return returnVal
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
        pushNotificationsDesired: Bool?,
        firestoreOK: Bool?
        )
    {

        //Store the old values
        let currentUserInfo = self.Get_User_Data()
        let lastBackups = self.Get_LastBackup()
        let userInfoDate = self.dateFormatter.string(from: lastBackups.UserInfo)
        let routinesDate = self.dateFormatter.string(from: lastBackups.Routines)
        let exerciseDate = self.dateFormatter.string(from: lastBackups.Exercise)
        
        do {
            //Delete what is currently there, since we only have a single user locally
            try UserInfo.run(UserInfoTable.delete())
            
            //Re-insert user
            try UserInfo.run(UserInfoTable.insert(UserUUID <- (nameGiven ?? currentUserInfo.UserName),
                                                  UserName <- (nameGiven ?? currentUserInfo.UserName),
                                                  QuestionsAnswered <- (questionsAnswered ?? currentUserInfo.QuestionsAnswered),
                                                  WalkingDuration <- (walkingDuration ?? currentUserInfo.WalkingDuration),
                                                  ChairAccessible <- (chairAvailable ?? currentUserInfo.ChairAccessible),
                                                  WeightsAccessible <- (weightsAvailable ?? currentUserInfo.WeightsAccessible),
                                                  ResistBandAccessible <- (resistBandAvailable ?? currentUserInfo.ResistBandAccessible),
                                                  PoolAccessible <- (poolAvailable ?? currentUserInfo.PoolAccessible),
                                                  Intensity <- (intensityDesired ?? currentUserInfo.Intensity),
                                                  PushNotifications <- (pushNotificationsDesired ?? currentUserInfo.PushNotifications),
                                                  FirestoreOK <- (firestoreOK ?? currentUserInfo.FirestoreOK),
                                                  LastUserInfoBackup <- userInfoDate,
                                                  LastRoutinesBackup <- routinesDate,
                                                  LastExerciseBackup     <- exerciseDate
                                                  ))
        } catch {
            print("Failed to update user info")
        }
        
        //Update Firestore
        let nextBackup = Calendar.current.date(byAdding: .second, value: 10, to: lastBackups.UserInfo)
        
        if( Date() >= nextBackup! ) {
            global_UserDataFirestore.Update_UserInfo() { returnedVal in
                if( returnedVal == 0 ) {
                    self.Update_LastBackup(UserInfo: Date(), Routines: nil, Exercise: nil)
                }
            }
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
        
        //Update Firestore
        let nextBackup = Calendar.current.date(byAdding: .second, value: 10, to: self.Get_LastBackup().Routines)
        
        if( Date() >= nextBackup! ) {
            global_UserDataFirestore.Update_UserInfo() { returnedVal in
                if( returnedVal == 0 ) {
                    self.Update_LastBackup(UserInfo: nil, Routines: Date(), Exercise: nil)
                }
            }
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
        
        //Update Firestore
        let nextBackup = Calendar.current.date(byAdding: .second, value: 10, to: self.Get_LastBackup().Exercise)
        
        if( Date() >= nextBackup! ) {
            global_UserDataFirestore.Update_ExerciseData() { returnedVal in
                if( returnedVal == 0 ) {
                    self.Update_LastBackup(UserInfo: nil, Routines: nil, Exercise: Date())
                }
            }
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
        
        //Update Firestore
        let nextBackup = Calendar.current.date(byAdding: .second, value: 10, to: self.Get_LastBackup().Exercise)
        
        if( Date() >= nextBackup! ) {
            global_UserDataFirestore.Update_ExerciseData() { returnedVal in
                if( returnedVal == 0 ) {
                    self.Update_LastBackup(UserInfo: nil, Routines: nil, Exercise: Date())
                }
            }
        }
        
    }
    
    //Increments the number of steps taken for a specific hour.
    //Call this function when you want to add extra steps onto what is currently there.
    func Increment_Steps_Taken(Steps: Int64, YearDone: Int, MonthDone: Int, DayDone: Int, HourDone: Int) {
        //Get the current value, then call Update_Step_Count().
        let currentStepCount = self.Get_Steps_Taken(TargetYear: YearDone, TargetMonth: MonthDone, TargetDay: DayDone, TargetHour: HourDone)
        self.Update_Steps_Taken(Steps: (currentStepCount + Steps), YearDone: YearDone, MonthDone: MonthDone, DayDone: DayDone, HourDone: HourDone)
    }
    
    //Sets LastBackup value.
    func Update_LastBackup(UserInfo: Date?, Routines: Date?, Exercise: Date?) {
        
        //Get the current dates in the database
        let currentDates = self.Get_LastBackup()
        
        //Set date objects to covnert to strings
        let userInfoDate = UserInfo ?? currentDates.UserInfo
        let routinesDate = Routines ?? currentDates.Routines
        let exerciseDate = Exercise ?? currentDates.Exercise
        
        //Convert the date to a string
        let userInfoString = self.dateFormatter.string(from: userInfoDate)
        let routinesString = self.dateFormatter.string(from: routinesDate)
        let exerciseString = self.dateFormatter.string(from: exerciseDate)
        //Get the current user info
        let currentUserInfo = self.Get_User_Data()
        
        do {
            //Delete what is currently there, since we only have a single user locally
            try self.UserInfo.run(UserInfoTable.delete())
            
            //Re-insert user
            try self.UserInfo.run(UserInfoTable.insert(UserUUID <- currentUserInfo.UserUUID,
                                                  UserName <- currentUserInfo.UserName,
                                                  QuestionsAnswered <- currentUserInfo.QuestionsAnswered,
                                                  WalkingDuration <- currentUserInfo.WalkingDuration,
                                                  ChairAccessible <- currentUserInfo.ChairAccessible,
                                                  WeightsAccessible <- currentUserInfo.WeightsAccessible,
                                                  ResistBandAccessible <- currentUserInfo.ResistBandAccessible,
                                                  PoolAccessible <- currentUserInfo.PoolAccessible,
                                                  Intensity <- currentUserInfo.Intensity,
                                                  PushNotifications <- currentUserInfo.PushNotifications,
                                                  FirestoreOK <- currentUserInfo.FirestoreOK,
                                                  LastUserInfoBackup <- userInfoString,
                                                  LastRoutinesBackup <- routinesString,
                                                  LastExerciseBackup <- exerciseString
                                                  ))
        } catch {
            print("Error updating last backup date")
        }
        
    }
/*
Deletion Methods
     These methods will delete data from a database. The exact action is deleting rows, so Delete_Exercise_Done() works slightly differently.
*/
    
    //Delete the user info. Preserves user name and UUID.
    func Delete_userInfo() {
        //Grab the current user name.
        let currentUserName = self.Get_User_Data().UserName
        let currentUUID = self.Get_User_Data().UserUUID
        
        //Kill the data in the database.
        do {
            try UserInfo.run(UserInfoTable.delete())
            
            //Re-insert user name plus default values for everything else.
            try UserInfo.run(UserInfoTable.insert(UserUUID <- currentUUID, UserName <- currentUserName, QuestionsAnswered <- false, WalkingDuration <- 0, ChairAccessible <- false, WeightsAccessible <- false, ResistBandAccessible <- false, PoolAccessible <- false, Intensity <- "Light", PushNotifications <- false, FirestoreOK <- false, LastUserInfoBackup <- self.yeOldDateString, LastRoutinesBackup <- self.yeOldDateString, LastExerciseBackup <- self.yeOldDateString))
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
Auxiliary Methods
    These methods do not fit into the above categories
*/
    
    //Returns whether or not the user exists. Condition for existance is whether or not we have a name from them.
    func User_Exists() ->(Bool){
        return !( (self.Get_User_Data()).UserName == "DEFAULT_NAME" )
    }
    
    //Checks if the name has already been taken. Returns true if the is available and false if the name has been taken
    func Name_Available(desiredName: String, completion: @escaping (Bool) -> ()) {
        
        let userRef = Firestore.firestore().collection("Users").document(desiredName)
        
        userRef.getDocument() { (document, error) in
            guard let document = document, document.exists else {
                //The name has been taken if the document exists
                completion(false)
                return
            }
            
            //If the document doesn't exist then the name is available
           completion(true)
        }
        
    }
    
/*
Testing Methods
     These methods are methods that are either unlikely to be used or should not be used in normal operation. Some methods 'break' the object, and are useful purely for testing.
*/

    //Searches for and then deletes the .sqlite3 file for the specified database.
    //Almost 1:1 copy of the version William Xue wrote for ExerciseDatabase.
    //Only use this for temporary testing. Since you need to instantiate the class to call this method, you will get errors about breaking the connections to the database.
    //Ideally you instantiate a temp instance of this class to use this function, since there is currently no functionality to recreate and reconnect to the database if the file is deleted after the constructor finishes.
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
