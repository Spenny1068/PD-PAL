//
//  SettingsViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit
import SQLite

class SettingsViewController: UIViewController {
    var database: Connection!
    let exerciseList = Table("exercises")
    let name = Expression<String>("exerciseName") //column of sql table
    let description = Expression<String>("descriptions")
    let strength = Expression<Bool> ("strength")
    let balance = Expression<Bool> ("balance")
    let flexMob = Expression<Bool> ("flexMob")
    let cardio = Expression<Bool> ("cardio")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        do{
            //to get the location of the file
            let documentDirectory = try FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) //don't create a file if file doesn't exist
            let fileUrl = documentDirectory.appendingPathComponent("exercises").appendingPathExtension("sqlite3") //create a file named users using sqlite3 extension
            
            //create connection to DB
            let database = try Connection(fileUrl.path) //anything written to the DB will be saved to the file
            self.database = database //set it to the global DB
            
        }
        catch{
            print(error)
        }
        
        
    }
    
    @IBAction func createTable() {
        let createTable = self.exerciseList.create { (table) in
            table.column(self.name, primaryKey: true)
            table.column(self.description)
            table.column(self.strength)
            table.column(self.balance)
            table.column(self.flexMob)
            table.column(self.cardio)
        }
        
        do{
            try self.database.run(createTable)
            print("created table")
        }catch{
            print(error)
        }
    }
    
    @IBAction func insertUser() {
        /*
        let alert = UIAlertController(title: "Put your name", message: nil, preferredStyle: .alert)
        alert.addTextField {(tf) in tf.placeholder = "name"}
        alert.addTextField {(tf) in tf.placeholder = "questions"}
        let action = UIAlertAction(title: "submit", style: .default){
            (_) in
            guard let name = alert.textFields?.first?.text,
            let questions = alert.textFields?.last?.text
            else {return}
            print(name)
            print(questions)
        }
        let insertUser = self.usersTable.insert(self.name <- name, self.questions <- questions)
        
        do
        {
            try self.database.run(insertUser)
            print("inserted user")
        }catch{
            print(error)
        }*/
    }

    @IBAction func listUsers(){
        do{
            let exercises = try self.database.prepare(self.exerciseList)
            for ex in exercises {
                print("exercise: \(ex[self.name]), description: \(ex[self.description])")
            }
        }catch{
            print(error)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
