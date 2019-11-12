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
 - 12/11/2019 : William Huong
    Implemented read function for UserInfo
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
        - Value : UUID - String
        - Value : Username - String
        - Value : QuestionsAnswered - Boolean
        - Value : WalkingDuration - Number
        - Value : ChairAccessible - Boolean
        - Value : WeightsAccessible - Boolean
        - Value : ResistBandAccessible - Boolean
        - Value : PoolAccessible - Boolean
        - Value : Intensity - String
        - Value : PushNotifications - Boolean
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
                    - Document : 11
                        - Collection : Day
                            - Document : 12
                                - Collection : Hour
                                    - Document : 13
                                        - Value : ExercisesDone - [String]
                                        - Value : StepsTaken - Number
                                        :
                            :
                    :
            :
    - Document : User2
        :
    - Document : User3
        :
 
*/
class UserDataFirestore {
    
    //Instance of Firestore we will use
    private let FirestoreDB = Firestore.firestore()
    
    //Constructor
    init() {
    }
    
    /*
    This function gets the UserInfo located in Firebase.
     Because of the asynchronous nature of Firebase, call using:
     
     global_UserDataFirestore.Get_UserInfo(targetUser: <User>) { ReturnedData in
        //Execute any code dependent on the return value of the function here, or assign it to a global variable.
     }
     
    Call without passing a UUID to get the current user, pass a UUID for a specific user other than current user.
    */
    func Get_UserInfo(targetUser: String?, completion: @escaping ((UserUUID: String, UserName: String, QuestionsAnswered: Bool, WalkingDuration: Int, ChairAccessible: Bool, WeightsAccessible: Bool, ResistBandAccessible: Bool, PoolAccessible: Bool, Intensity: String, PushNotifications: Bool))->()) {
        
        //If the user does not provide a UUID to use, get the current user's UUID
        let targetUUID = targetUser ?? global_UserData.Get_User_Data().UserUUID
        
        var returnVal = (UserUUID: "DEFAULT_UUID", UserName: "DEFAULT_NAME", QuestionsAnswered: false, WalkingDuration: 0, ChairAccessible: false, WeightsAccessible: false, ResistBandAccessible: false, PoolAccessible: false, Intensity: "Light", PushNotifications: false)
        
        let userDocRef = self.FirestoreDB.document("Users/\(targetUUID)")
        
        //Get the document from Firebase
        userDocRef.getDocument { (document, error) in
            print("Beginning document read")
            //Check the document existed
            guard let document = document, document.exists else {
                returnVal.UserUUID = "NO_DOCUMENT"
                print("Did not get a document snapshot: \(String(describing: error))")
                return
            }
            print("User exists, reading data")
            
            //Get the data in the document
            let dataReturned = document.data()
            
            //Check the data exists
            guard dataReturned != nil else {
                returnVal.UserUUID = "NO_DATA"
                print("Error, document snapshot data was empty. Check Connection")
                return
            }
            print("Data is not nil, parsing")
            
            //Start parsing the data, since it is returned as type any optionals
            let returnedUUID = dataReturned?["UUID"] as? String ?? "USER_NIL"
            print("\(returnedUUID)")
            let returnedUserName = dataReturned?["UserName"] as? String ?? "USERNAME_NIL"
            print("\(returnedUserName)")
            let returnedQuestionsAnswered = dataReturned?["QuestionsAnswered"] as? Bool ?? false
            print("\(returnedQuestionsAnswered)")
            let returnedWalkingDuration = dataReturned?["WalkingDuration"] as? Int ?? -1
            print("\(returnedWalkingDuration)")
            let returnedChairAccessible = dataReturned?["ChairAccessible"] as? Bool ?? false
            print("\(returnedChairAccessible)")
            let returnedWeightsAccessible = dataReturned?["WeightsAccessible"] as? Bool ?? false
            print("\(returnedWeightsAccessible)")
            let returnedResistBandAccessible = dataReturned?["ResistBandAccessible"] as? Bool ?? false
            print("\(returnedResistBandAccessible)")
            let returnedPoolAccessible = dataReturned?["PoolAccessible"] as? Bool ?? false
            print("\(returnedPoolAccessible)")
            let returnedIntensity = dataReturned?["Intensity"] as? String ?? "INTENSITY_NIL"
            print("\(returnedIntensity)")
            let returnedPushNotifications = dataReturned?["PushNotifications"] as? Bool ?? false
            print("\(returnedPushNotifications)")
            
            print("Finished parsing, assigning returnVal")
            
            returnVal = (UserUUID: returnedUUID, UserName: returnedUserName, QuestionsAnswered: returnedQuestionsAnswered, WalkingDuration: returnedWalkingDuration, ChairAccessible: returnedChairAccessible, WeightsAccessible: returnedWeightsAccessible, ResistBandAccessible: returnedResistBandAccessible, PoolAccessible: returnedPoolAccessible, Intensity: returnedIntensity, PushNotifications: returnedPushNotifications)
            
            completion(returnVal)
            
        }
    }
    
}
