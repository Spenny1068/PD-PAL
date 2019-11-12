//
//  UserDataFirestore.swift
//  PD_PAL
//
//  This file implements a class to interface with the Firestore we have set up for our app
//
//  Created by William Huong on 2019-11-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*
Revision History
 
 - 11/11/2019 : William Huong
    Created file
*/

/*
Known Bugs
 
 -
*/

import Foundation
import Firebase

/*

 Instead of directly interfacing with the Cloud Firestore database, call the methods implemented in this class.
 Ideally, call this class once every 24H to sync the data stored on this device with the data stored on Cloud Firestore.
 
 Cloud Firestore sorts data into two different objects, collections and documents.
 
 Documents hold the actual data, in key pairs.
 Collections are logical groups of documents.
 Collections can be chained by having a document link to a collection.
 
 For our Firestore, we will have the following format, where:
 Collection : <name> indicates a collection with the name 'name'
 Document : <name> indicates a document with the name 'name'
 Value : <name-type> Indicates a piece of inserted data with the name 'name' and type 'type'
 
 - Collection: Users
    - Document: User1
        - Value : UUID-String
        - Value : Username-String
        - Value : QuestionsAnswered-Boolean
        - Value : WalkingDuration-Number
        - Value : ChairAccessible-Boolean
        - Value : WeightsAccessible-Boolean
        - Value : ResistBandAccessible-Boolean
        - Value : PoolAccessible-Boolean
        - Value : Intensity-String
        - Value : PushNotifications
        - Collection : Routines
            - Document : Routine1
                - Value : Exercise1
                - Value : Exercise2
                - Value : Exercise3
                :
            - Document : Routine2
                - Value : Exercise4
                :
            - Document : Routine3
                - Value : Exercise5
                :
            :
        - Collection : Year
            - Document : 2019
                - Collection : Month
                    - Document
    - Document : User2
    - Document : User3
 
*/
class UserDataFirestore {
    
    //Instance of Firestore we will use
    private let firestoreDB = Firestore.firestore()
    
    //Constructor
    init() {
    }
    
    //This function gets the UserInfo located in Firebase.
    //Call without passing a UUID to get the current user, pass a UUID for a specific user other than current user.
    func Get_UserInfo(targetUser: String?) -> (UserUUID: String, UserName: String, QuestionsAnswered: Bool, WalkingDuration: Int, ChairAccessible: Bool, WeightsAccessible: Bool, ResistBandAccessible: Bool, PoolAccessible: Bool, Intensity: String, PushNotifications: Bool) {
        
        let targetUUID = targetUser ?? global_UserData.Get_User_Data().UserUUID
        
        var returnVal = (UserUUID: targetUUID, UserName: "DEFAULT_NAME", QuestionsAnswered: false, WalkingDuration: 0, ChairAccessible: false, WeightsAccessible: false, ResistBandAccessible: false, PoolAccessible: false, Intensity: "Light", PushNotifications: false)
        
        let userDocRef = self.firestoreDB.document("Users/\(targetUUID)")
        
        userDocRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {
                returnVal.UserName = "NO_SNAPSHOT"
                print("Did not get a document snapshot: \(String(describing: error))")
                return
            }
            print("User exists, reading data")
            
            let dataReturned = docSnapshot.data()
            
            guard dataReturned != nil else {
                returnVal.UserName = "NO_DATA"
                print("Error, document snapshot data was empty. Check Connection")
                return
            }
            
            returnVal = (UserUUID: dataReturned!["UUID"] as! String, UserName: dataReturned!["UserName"] as! String, QuestionsAnswered: dataReturned!["QuestionsAnswered"] as! Bool, WalkingDuration: dataReturned!["WalkingDuration"] as! Int, ChairAccesible: dataReturned!["ChairAccessible"] as! Bool, WeightsAccessible: dataReturned!["WeightsAccessible"] as! Bool, ResistBandAccessible: dataReturned!["ResistBandAccessible"] as! Bool, PoolAccessible: dataReturned!["PoolAccessible"] as! Bool, Intensity: dataReturned!["Intensity"] as! String, PushNotifications: dataReturned!["PushNotifications"] as! Bool) as! (UserUUID: String, UserName: String, QuestionsAnswered: Bool, WalkingDuration: Int, ChairAccessible: Bool, WeightsAccessible: Bool, ResistBandAccessible: Bool, PoolAccessible: Bool, Intensity: String, PushNotifications: Bool)
        }
        
        return returnVal
        
    }
    
}
