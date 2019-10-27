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
        do {
            //to get the location of the file
            let documentDirectory = try FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) //don't create a file if file doesn't exist
            
            //Look for the SQLite3 database file. Note whether or not it already exists.
            let files = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.absoluteString)
            
            var database_already_exists = false
            
            for file in files {
                if file == "exercises.sqlite3" {
                    database_already_exists = true
                }
            }
            
            let fileUrl = documentDirectory.appendingPathComponent("exercises").appendingPathExtension("sqlite3") //create a file named users using sqlite3 extension
            
            //create connection to DB
            let database = try Connection(fileUrl.path) //anything written to the DB will be saved to the file
            self.database = database //set it to the global DB
            
            //If the SQLite3 database does not already exist, is is empty, so we need to fill it.
            if( !database_already_exists ) {
                self.fill_database()
            }
        }
        catch {
            print("Failed to connect to database")
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
            print("Failed to insert \(Name) into database")
        }
    }
}
