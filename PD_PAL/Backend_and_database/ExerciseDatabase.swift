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
 - Body: String
 */
class ExerciseDatabase {
    
    var database: Connection!
    let exerciseList = Table("exercises")
    let name = Expression<String>("Name") //column of sql table
    let descriptions = Expression<String>("Desc")
    let category = Expression<String>("Category")
    let body = Expression<String>("Body")
    //create link "Identifier to actual media"
    let link = Expression<String>("Link")
    let duration = Expression<String>("Duration")
    
    
    let fileName = "exercises"
    let fileExtension = "sqlite3"

    

    //Will X Function Tested Manually and in UI Test, testDatabase_insertion
    //if the File exercises.sqlite3 exists, will read and check that it's not empty, then open with SQLite Library
    //if the file does not exist, will open and create the SQLite Database and insert Table
    init() {
    
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
        
        // hardcoding 4 default exercises for version 1
        insert_exercise(Name: "WALL PUSH-UP",
                        Desc: "A Wall Push-up is done to strengthen the upper body with a focus on the arms and chest. To perform a Wall Push-up, face the wall and extend your hands towards the wall. Now bend your elbows and lean towards the wall" ,
                        Category: "Strength",
                        Body: "None",
                        Link: "WALL_PUSH-UP",
                        Duration: "Complete 3 sets of 10 repetitions")
        
        insert_exercise(Name: "WALKING",
                        Desc: "For optimal results perform this exercise on a track.",
                        Category: "Cardio",
                        Body: "None",
                        Link: "WALKING",
                        Duration: "Walk for 15-30 minutes")
        
        insert_exercise(Name: "SINGLE LEG STANCE",
                        Desc: "The One Leg Stance is done to impove balance. To perform a One leg Stance, bend your knee and raise your leg. Hold the chair with the other hand for support.",
                        Category: "Flexibility",
                        Body: "None",
                        Link: "SINGLE_LEG_STANCE",
                        Duration: "Complete 3 sets of 10 repetitions")
        
        insert_exercise(Name: "QUAD STRETCH",
                        Desc: "A Quad Stretch is done to stretch the thigh and improve leg flexibility. To perform a Quad stretch, stand on one leg and and hold you your leg with your hand. ",
                        Category: "Balance",
                        Body: "None",
                        Link: "QUAD_STRETCH",
                        Duration: "Stand on each leg for one minute. Repeat 3 times")
        
        insert_exercise(Name: "TRICEP KICKBACKS",
                        Desc: "Lean over your knees if sitting or over a chair if standing. Hold the weight in your hand. Straighten your elbow behind you as far as comfortable and slowly return to the starting position. ",
                        Category: "Strength",
                        Body: "None",
                        Link: "TRICEP_KICKBACKS",
                        Duration: "")
        
        insert_exercise(Name: "SIDE LEG LIFT",
                        Desc: "The side leg lift will improve your balance as well as strengthening both legs by working your hips, glutes and other muscles to keep your body stable. To perform a side leg stance, stand behind a chair with feet slightly apart. Slowly lift one leg out to one side. Slightly bend the leg you are standing on. ",
                        Category: "Balance",
                        Body: "None",
                        Link: "SIDE_LEG_LIFT",
                        Duration: "")
        
        insert_exercise(Name: "SHOULDER RAISES",
                        Desc: "Shoulder rolls will improve the range of motion in your shoulder and upper back region. Begin by sitting in a chair. Slowly raise your shoulders up to your ears and then relax. ",
                        Category: "Flexibility",
                        Body: "None",
                        Link: "SHOULDER_RAISES",
                        Duration: "Repeat 10 times ")
        
        insert_exercise(Name: "QUAD STRETCH",
                        Desc: "The quad stretch will stretch your thighs and improve your flexibility. ",
                        Category: "Flexibility",
                        Body: "None",
                        Link: "QUAD_STRETCH",
                        Duration: "Stand on each leg for 30 seconds. Repeat twice. ")
        
        insert_exercise(Name: "NECK SIDE STRETCH",
                        Desc: "The neck side stretch will improve your range of motion in your neck. Begin by sitting in a chair. Look to the right as far as comfortable and hold. Then look to the left as far as comfortable and hold. ",
                        Category: "Flexibility",
                        Body: "None",
                        Link: "NECK_SIDE_STRETCH",
                        Duration: "Repeat 10 times")
        
        insert_exercise(Name: "LATERAL RAISES",
                        Desc: "Lateral arm raises will strengthen your shoulders and increase your shoulder mobility. Begin with arms at your side and your palms facing inwards. Hips, knees and toes should all be facing forward. Slowly raise your arms to a comfortable level. ",
                        Category: "Strength",
                        Body: "None",
                        Link: "LATERAL_RAISES",
                        Duration: "Repeat 10 times")
        
        insert_exercise(Name: "KNEE MARCHING",
                        Desc: "Knee marching will strengthen ankles and hips that will help overall balance. To knee march, begin with arms at your side and feet shoulder width apart. Raise one knee up as high as comfortable. Lower that knee and raise the other.  ",
                        Category: "Balance",
                        Body: "None",
                        Link: "KNEE_MARCHING",
                        Duration: "")
        
        insert_exercise(Name: "KNEE EXTENSION",
                        Desc: "The knee extension will strengthen your knees to better your balance and flexibility. Sit in a chair with your feet flat against the floor. Slowly straighten your knee out, hold and slowly bend your knee back into the starting position. ",
                        Category: "Strength",
                        Body: "None",
                        Link: "KNEE_EXTENSION",
                        Duration: "Repeat 10 times on each leg")
        
        insert_exercise(Name: "HEEL TO TOE",
                        Desc: "The heel to toe will improve your balance and coordination. To perform a heal to toe, look forward, relax your shoulders and begin walking forward by pacing one foot in front of the other. ",
                        Category: "Balance",
                        Body: "None",
                        Link: "HEEL_TO_TOE",
                        Duration: "")
        
        insert_exercise(Name: "HEEL STAND",
                        Desc: "Stand behind a chair with your knees shoulder-width apart. Using the chair as support, slowly raise up on your heels as high as comfortable. Slowly return to the starting position. ",
                        Category: "Strength",
                        Body: "None",
                        Link: "HEEL_STAND",
                        Duration: "")
        
        insert_exercise(Name: "CHEST STRETCH",
                        Desc: "The chest stretch will improve the mobility and flexibility in your upper chest and shoulders. Begin by sitting in a chair. Raise your arms and place hands behind your head. Breathe in while bringing your neck and shoulder back. Hold and release. ",
                        Category: "Flexibility",
                        Body: "None",
                        Link: "CHEST_STRETCH",
                        Duration: "Repeat 3 times")
        
        insert_exercise(Name: "ARM RAISES",
                        Desc: "Overhead arm raises will stretch your arms and upper back. Begin with your arms at your sides. Inhale and slowly you lift both arms over your head. Slowly bring your arms back to your sides. ",
                        Category: "Flexibility",
                        Body: "None",
                        Link: "ARM_RAISES",
                        Duration: "Repeat 10 times")
        
    }

    //Assuming the database is empty,
    //function to initialize the database
    //create the table and insert all exercises.
    func fill_database() {
        let createTable = exerciseList.create{ (table) in
            table.column(name, primaryKey: true)
            table.column(descriptions)
            table.column(category)
            table.column(body)
            table.column(link)
            table.column(duration)
        }
        do{
            try self.database.run(createTable)
            print("created table")
        }catch{
            print("Failed to create table: \(error)")
        }
        
        //Insert all exercises here.
    }
    
    
    //Insert an individual exercise.
    func insert_exercise(Name: String , Desc: String, Category: String, Body: String, Link: String, Duration: String) {
        let insert = exerciseList.insert(name <- Name, descriptions <- Desc, category <- Category,
                                         body <- Body, link <- Link, duration <- Duration)
        do {
            try database.run(insert)
        }
        catch {
            print("Failed to insert \(Name) into database: \(error)")
        }
    }
    
    
    //returns all exercise names in an array
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
    func read_exercise(NameOfExercise: String) ->(Description: String,Category: String, Body: String, Link: String, Duration: String)
    {
        do{
            let query = exerciseList.filter(name == NameOfExercise)
            for exercise in try database.prepare(query)
            {
                let returnVal = (exercise[descriptions],exercise[category],exercise[body], exercise[link], exercise[duration])
                return returnVal
            }
        }
        catch
        {
            print("Failed to find \(NameOfExercise) in database: \(error.localizedDescription)")
        }
        
        //could not find so return empty
        return ("","","","","")
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
