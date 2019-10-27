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
    let usersTable = Table("users")
    let name = Expression<String>("name") //column of sql table
    let accessCode  = Expression<String>("accessCode")
    let questions = Expression<String?>("questions") //optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        do{
            //to get the location of the file
            let documentDirectory = try FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) //create true creates a file if file doesn't exist
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3") //create a file named users using sqlite3 extension
            
            //create connection to DB
            let database = try Connection(fileUrl.path) //anything written to the DB will be saved to the file
            self.database = database //set it to the global DB
            
        }
        catch{
            print(error)
        }
        
        
    }
    
    @IBAction func createTable() {
        let createTable = self.usersTable.create { (table) in
            table.column(self.name)
            table.column(self.accessCode, primaryKey: true)
            table.column(self.questions)
        }
        
        do{
            try self.database.run(createTable)
            print("created table")
        }catch{
            print(error)
        }
    }
    
    @IBAction func insertUser() {
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
        }
    }

    @IBAction func listUsers(){
        do{
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userCode: \(user[self.accessCode]), name: \(user[self.name]), questions: \(user[self.questions])")
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
