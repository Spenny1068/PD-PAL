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

    
    init() {
        
        let fileName = "exercises"
        let fileExtension = "sqlite3"
        let fullFileName = fileName + "." + fileExtension
        var database_already_exists = false
        var fileURL : URL
        
        
        /*Will X: copied from Stackoverflow: https://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder*/
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print (documentsURL.path)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            for file in fileURLs {
                if file.lastPathComponent == fullFileName {
                    //in this control loop, file already exists and has proper name
                    
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
                    
                    //create connection to DB
                     do{
                         let database = try Connection(fileURL.path) //anything written to the DB will be saved to the file
                         self.database = database //set it to the global DB
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
        
        if database_already_exists == false
        {
            //creting the file it it doesn't exist
            fileURL = documentsURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension) //create a file named users using sqlite3 extension
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
            
    }

    //Assuming the database is empty, create the table and insert all exercises.
    func fill_database() {
        let createTable = exerciseList.create{ (table) in
            table.column(name, primaryKey: true)
            table.column(descriptions)
            table.column(category)
            table.column(body)
        }
        do{
            try self.database.run(createTable)
            print("created table")
        }catch{
            print("Failed to create table")
        }
        
        //Insert all exercises here.
    }
    
    
    //Insert an individual exercise.
    func insert_exercise(Name: String , Desc: String, Category: String, Body: String) {
        let insert = exerciseList.insert(name <- Name, descriptions <- Desc, category <- Category, body <- Body)
        do {
        let rowid = try database.run(insert)
        }
        catch {
            print("Failed to insert \(Name) into database: \(error.localizedDescription)")
        }
    }
}
