//
//  ExerciseDatabase.swift
//  PD_PAL
//
//  This file implements a database to store our exercises and their properties.
//
//  Created by whuong on 2019-10-26.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
Revision History
 
 - 26/10/2019 : William Huong, Julia Kim, William Xue
     Created file, implemented constructor, insert function.
 - 27/10/2019 : William Huong
     Commented out broken code related to getting contents of documents directory.
 - 27/10/2019 : William Xue
     Fixed File Initialization sequence, added read_exercise func and remove_database func
 - 01/11/2019 : William Xue
     Added function to return all of the exercise names
 */

/*
Known Bugs
 
- 26/10/2019 : William Xue
     Call to get contents of documents directory in constructor throws an error.
- 27/10/2019 : William Xue
    File persistance of iOS simulator behviour is unknown, it is possible that the file name persists but the file is empty
    thus when we try to insert, the system crashes
*/

import Foundation
import SQLite

/*
 Class wrapper for our SQLite databse for exercises.
 Each exercise must have:
 - Name: String
 - Desc: String
 - Category: String
 - Equipment: String
 */
class ExerciseDatabase {
    
    var database: Connection!
    let exerciseList = Table("exercises")
    let name = Expression<String>("Name") //column of sql table
    let descriptions = Expression<String>("Desc")
    let category = Expression<String>("Category")
    let equipment = Expression<String>("Equipment")
    //create link "Identifier to actual media"
    let intensity = Expression<String>("Intensity")
    let link = Expression<String>("Link")
    let duration = Expression<Int>("Duration")
    let num_sets = Expression<Int>("Sets")
    
    
    let fileName = "exercises"
    let fileExtension = "sqlite3"

    

    //Will X Function Tested Manually and in UI Test, testDatabase_insertion
    //if the File exercises.sqlite3 exists, will read and check that it's not empty, then open with SQLite Library
    //if the file does not exist, will open and create the SQLite Database and insert Table
    init() {
        remove_database();
        var database_already_exists = false
        var fileURL : URL
        
        let fullFileName = fileName + "." + fileExtension
        /*Will X: referenced Stackoverflow: https://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder*/
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //print (documentsURL.path)
        do {
            //finding the document folder which we can operate with
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // iterate through all the files in the document folder
            for file in fileURLs {
                //if one of the files has the right name, continue processing
                if file.lastPathComponent == fullFileName {
                    
                    //check if the file is empty, due to bug found on 27/10/2019, desc above
                    var isFileEmpty:Bool = false
                    do {
                        let attr = try FileManager.default.attributesOfItem(atPath: file.path)
                        var fileSize = attr[FileAttributeKey.size] as! UInt64
                        let dict = attr as NSDictionary
                        fileSize = dict.fileSize()
                        if(fileSize == 0)
                        {
                            print("Found empty file with name: \(fullFileName) at : \(file.path)")
                            isFileEmpty = true
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                    //end of checking if found file is empty
                    
                    database_already_exists = true
                    fileURL = file.absoluteURL
                    print(file.absoluteURL.path)
                    
                    //create connection to DB with the pre-existing file
                     do{
                        let database = try Connection(fileURL.path) //anything written to the DB will be saved to the file
                        self.database = database //set it to the global DB
                        //if the pre-existing file has not contents, fill it with contents
                        if isFileEmpty{self.fill_database() }
                     }
                     catch
                     {
                         print("Error while creating connection from URL to Database")
                         print("fileURL: \(fileURL.path)")
                         print(error.localizedDescription)
                     }
                }
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        //if there is no pre-existing file in the documents folder
        if database_already_exists == false
        {
            //creting the file when it doesn't exist
            fileURL = documentsURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
            print(fileURL.path)
            
            //create connection to DB
             do{
                let database = try Connection(fileURL.path) //anything written to the DB will be saved to the file
                self.database = database //set it to the global DB
                //fill the database since it did not already exist
                self.fill_database()
             }
             catch
             {
                 print("Error while creating connection from URL to Database")
                 print("fileURL: \(fileURL.path)")
                 print(error.localizedDescription)
             }
               
        }
        
        // hardcoding all default exercises for version 1
        insert_exercise(Name: "WALL PUSH-UP",
                        Desc: "Face the wall and extend your hands towards the wall. Now bend your elbows and lean towards the wall" ,
                        Category: "Strength",
                        Equipment: "None",
                        Link: "WALL_PUSH-UP",
                        Intensity: "Intense",
                        Duration: 3,
                        Sets: 3 )
        
        insert_exercise(Name: "WALKING",
                        Desc: "For optimal results perform this exercise on a track.",
                        Category: "Cardio",
                        Equipment: "None",
                        Link: "WALKING",
                        Intensity: "Light",
                        Duration: 3,
                        Sets: 1)
        
        insert_exercise(Name: "SINGLE LEG STANCE",
                        Desc: "Bend your knee and raise your leg beside a chair. Hold the chair with your hand that opposite to the side of your raised leg for support.",
                        Category: "Flexibility",
                        Equipment: "Chair",
                        Link: "SINGLE_LEG_STANCE",
                        Intensity: "Light",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "QUAD STRETCH",
                        Desc: "To perform a Quad stretch, stand on one leg and and hold you your leg with your hand. ",
                        Category: "Flexibility",
                        Equipment: "Chair",
                        Link: "QUAD_STRETCH",
                        Intensity: "Moderate",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "TRICEP KICKBACKS",
                        Desc: "Hold the weight, and lean over a chair. Straighten your elbow behind you as far as comfortable and slowly return to the starting position. ",
                        Category: "Strength",
                        Equipment: "Weights",
                        Link: "TRICEP_KICKBACKS",
                        Intensity: "Light",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "SIDE LEG LIFT",
                        Desc: "Stand behind a chair with feet slightly apart. Slowly lift one leg out to one side. Slightly bend the leg you are standing on.",
                        Category: "Balance",
                        Equipment: "Chair, Resistive Band",
                        Link: "SIDE_LEG_LIFT",
                        Intensity: "Light",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "SHOULDER RAISES",
                        Desc: "Begin by sitting in a chair. Slowly raise your shoulders up to your ears and then relax. ",
                        Category: "Flexibility",
                        Equipment: "Weights",
                        Link: "SHOULDER_RAISES",
                        Intensity: "Light",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "NECK SIDE STRETCH",
                        Desc: "Begin by sitting in a chair. Look to the right as far as comfortable and hold. Then look to the left as far as comfortable and hold.",
                        Category: "Flexibility",
                        Equipment: "None",
                        Link: "NECK_SIDE_STRETCH",
                        Intensity: "Light",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "LATERAL RAISES",
                        Desc: "Begin with arms at your side and your palms facing inwards. Slowly raise your arms to a comfortable level. ",
                        Category: "Strength",
                        Equipment: "Weights",
                        Link: "LATERAL_RAISES",
                        Intensity: "Moderate",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "KNEE MARCHING",
                        Desc: "Begin with arms at your side and feet shoulder width apart. Raise one knee up as high as comfortable. Lower that knee and raise the other.",
                        Category: "Balance",
                        Equipment: "None",
                        Link: "KNEE_MARCHING",
                        Intensity: "Intense",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "KNEE EXTENSION",
                        Desc: "Sit with your feet flat against the floor. Slowly straighten your knee out, hold and slowly bend your knee back into the starting position.",
                        Category: "Strength",
                        Equipment: "Chair",
                        Link: "KNEE_EXTENSION",
                        Intensity: "Moderate",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "HEEL TO TOE",
                        Desc: "To perform a heal to toe, look forward, relax your shoulders and begin walking forward by pacing one foot in front of the other.",
                        Category: "Balance",
                        Equipment: "None",
                        Link: "HEEL_TO_TOE",
                        Intensity: "Moderate",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "HEEL STAND",
                        Desc: "Keep your knees shoulder-width apart. Raise up on your heels as high as possible. Slowly return to the starting position.",
                        Category: "Strength",
                        Equipment: "Chair",
                        Link: "HEEL_STAND",
                        Intensity: "Light",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "CHEST STRETCH",
                        Desc: "Raise your arms and place hands behind your head. Breathe in while bringing your neck and shoulder back. Hold and release.",
                        Category: "Flexibility",
                        Equipment: "Weights",
                        Link: "CHEST_STRETCH",
                        Intensity: "Moderate",
                        Duration: 3,
                        Sets: 3)
        
        insert_exercise(Name: "ARM RAISES",
                        Desc: "Begin with your arms at your sides. Inhale and slowly you lift both arms over your head. Slowly bring your arms back to your sides.",
                        Category: "Flexibility",
                        Equipment: "None",
                        Link: "ARM_RAISES",
                        Intensity: "Moderate",
                        Duration: 3,
                        Sets: 3)
    }

    //Assuming the database is empty,
    //function to initialize the database
    //create the table and insert all exercises.
    func fill_database() {
        let createTable = exerciseList.create{ (table) in
            table.column(name, primaryKey: true)    /* name of exercise */
            table.column(descriptions)              /* exercise description */
            table.column(category)                  /* exercise category */
            table.column(equipment)                 /* exercise equipment */
            table.column(link)                      /* name of gif file */
            table.column(intensity)                 /* level of intensity */
            table.column(duration)                  /* duration in seconds for one set */
            table.column(num_sets)                  /* number of sets */
        }
        do {
            try self.database.run(createTable)
            print("created table")
        } catch {
            print("Failed to create table: \(error)")
        }
        
        //Insert all exercises here.
    }
    
    
    //Insert an individual exercise.
    func insert_exercise(Name: String , Desc: String, Category: String, Equipment: String, Link: String, Intensity: String, Duration: Int, Sets: Int) {
        let insert = exerciseList.insert(name <- Name, descriptions <- Desc, category <- Category, equipment <- Equipment, link <- Link, intensity <- Intensity, duration <- Duration, num_sets <- Sets)
        do {
            try database.run(insert)
        }
        catch {
            print("Failed to insert \(Name) into database: \(error)")
        }
    }
    
    
    // returns all exercise names in an array
    func exercise_names() -> ([String])
    {
        var returnVal = [String]()
        do{
            let query = exerciseList
            for exercise in try database.prepare(query)
            {
                //add all the names to the end
                returnVal.append(exercise[name])
            }
            return returnVal
        }
        catch
        {
            print("\(error.localizedDescription)")
        }
        
        //could not find so return empty
        return returnVal
    }
    
    
    
    //Read an individual exercise
    //Will X, func tested in Unit Test testDatabase_insertion
    //Make sure to give it a NameOfExercise that exists in the database, otherwise will return empty string
    func read_exercise(NameOfExercise: String) ->(Description: String, Category: String, Equipment: String, Link: String, Intensity: String, Duration: Int, Sets: Int)
    {
        do {
            let query = exerciseList.filter(name == NameOfExercise)
            for exercise in try database.prepare(query)
            {
                let returnVal = (exercise[descriptions],exercise[category],exercise[equipment], exercise[link], exercise[intensity], exercise[duration], exercise[num_sets])
                return returnVal
            }
        }
        catch
        {
            print("Failed to find \(NameOfExercise) in database: \(error.localizedDescription)")
        }
        
        //could not find so return empty
        return ("","","","","",0, 0)
    }
    
    
    
    //function will delete the file that contains the database
    //Will X, func tested manually and works (i.e. without UI Tests) Oct 27, 2019
    func remove_database()
    {
        let fullFileName = fileName + "." + fileExtension
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            //finding the document folder which we can operate with
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // iterate through all the files in the document folder
            for file in fileURLs {
                //if one of the files has the right name, continue processing
                if file.lastPathComponent == fullFileName {
                    do {
                        //remove the file
                        try FileManager.default.removeItem(at: file.absoluteURL)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        catch
        {
            print(error)
        }
    }
}
