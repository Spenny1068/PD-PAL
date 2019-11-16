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
 - 15/11/2019 : William Huong
    Implement UserInfo update function
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
        - Collection : ExercisesData
            - Value : Year - Number
            - Value : Month - Number
            - Value : Day - Number
            - Value : Hour - Number
            - Value : ExercisesDone - [String]
        :
    - Document : User2
        :
    - Document : User3
        :
 
*/
class UserDataFirestore {
    
    //Instance of Firestore we will use
    private let FirestoreDB = Firestore.firestore()
    
    //To make the rest of the code easier
    private let dateFormatter = DateFormatter()
    private let dateFormat = "MMM d, yyyy, hh:mm:ss a"
    
    //Constructor
    init() {
        
        //Set up the date formatter
        self.dateFormatter.calendar = Calendar.current
        self.dateFormatter.dateFormat = self.dateFormat
        
    }
    
    //This function will update the data in Firebase. It will check both if the user has allowed us to store data in Firebase, as well as if it is time for another update.
    //This should be the only function called. All other functions are either internal functions or only for the sake of testing.
    func Update_Firebase(DayFrequency: Int?, HourFrequency: Int?, MinuteFrequency: Int?, SecondFrequency: Int?) -> String {
        
        print(" --- Beginning Firestore update process --- ")
        
        
        /*
        Check for permission to upload to Firestore
        */
        
        if( !global_UserData.Get_User_Data().FirestoreOK ) {
            print("User has not permitted storing data in Firestore")
            print(" --- Firestore was not updated --- ")
            return "NO_AUTH"
        }
        print("User has permitted storing data in Firestore")
        
        
        /*
        Check if we need to update
        */
        
        
        //Create a Date object representing what time we need to update Firestore
        var dateComponents = DateComponents()
        dateComponents.day = DayFrequency
        dateComponents.hour = HourFrequency
        dateComponents.minute = MinuteFrequency
        dateComponents.second = SecondFrequency

        let nextUpdateTime = Calendar.current.date(byAdding: dateComponents, to: global_UserData.Get_LastBackup())
        
        print("The time is currently \(self.dateFormatter.string(from: Date()))")
        print("The next update is scheduled to be done at \(self.dateFormatter.string(from: nextUpdateTime!))")
        
        if( Date() <= nextUpdateTime! )
        {
            //Not time to update yet
            print("Current time has not passed the next scheduled update time")
            print(" --- Firestore was not updated --- ")
            return "NO_SCHEDULE"
        }
        print("Current time has passed the next scheduled update time")
        
        
        /*
        Begin the update process
        */
        
        
        //Update the UserInfo
        
        return "SUCCESS"

    }
    
    //Updates the user info on Firebase.
    //This function will be called as a part of Update_Firebase() and should not be called on its own.
    func Update_UserInfo(completion: @escaping (Int) -> ()) {
        
        print("Beginning update of UserInfo")
        
        //Grab the UserInfo we are going to write to Firestore
        let currentUserInfo = global_UserData.Get_User_Data()
        
        let docData: [String: Any] = [
            "UserName" : currentUserInfo.UserName,
            "QuestionsAnswered" : currentUserInfo.QuestionsAnswered,
            "WalkingDuration" : currentUserInfo.WalkingDuration,
            "ChairAccessible" : currentUserInfo.ChairAccessible,
            "WeightsAccessible" : currentUserInfo.WeightsAccessible,
            "ResistBandAccessible" : currentUserInfo.ResistBandAccessible,
            "PoolAccessible" : currentUserInfo.PoolAccessible,
            "Intensity" : currentUserInfo.Intensity,
            "PushNotifications" : currentUserInfo.PushNotifications
        ]
        
        //Create the document reference
        let userDocRef = self.FirestoreDB.collection("Users").document(currentUserInfo.UserUUID)
        
        userDocRef.getDocument { (document, error) in
            print("Beginning document read")
            guard let document = document, document.exists else {
                print("The user does not current have any data in Firestore. Creating the user document")
                
                //Add a document for the user
                userDocRef.setData(docData) { err in
                    if let err = err {
                        print("Failed to add user document : \(err)")
                        completion(1)
                    } else {
                        print("Successfully added user document")
                        completion(0)
                    }
                }
                
                return
            }
            
            //The user document does exist. Update instead of overwriting
            userDocRef.updateData(docData) { err in
                if let err = err {
                    print("Failed to update user document : \(err)")
                    completion(1)
                } else {
                    print("Successfully updated user document")
                    completion(0)
                }
            }
            
        }
        
    }
    
    //Updates the routines on Firebase.
    //This function will be called as a part of Update_Firebase() and should not be called on its own.
    func Update_Routines() {
        
    }
    
    //Updates the exercise data on Firebase.
    //This function will be called as a part of Update_Firebase() and should not be called on its own.
    func Update_ExerciseData() {
        
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
            let returnedUserName = dataReturned?["UserName"] as? String ?? "USERNAME_NIL"
            let returnedQuestionsAnswered = dataReturned?["QuestionsAnswered"] as? Bool ?? false
            let returnedWalkingDuration = dataReturned?["WalkingDuration"] as? Int ?? -1
            let returnedChairAccessible = dataReturned?["ChairAccessible"] as? Bool ?? false
            let returnedWeightsAccessible = dataReturned?["WeightsAccessible"] as? Bool ?? false
            let returnedResistBandAccessible = dataReturned?["ResistBandAccessible"] as? Bool ?? false
            let returnedPoolAccessible = dataReturned?["PoolAccessible"] as? Bool ?? false
            let returnedIntensity = dataReturned?["Intensity"] as? String ?? "INTENSITY_NIL"
            let returnedPushNotifications = dataReturned?["PushNotifications"] as? Bool ?? false
            
            print("Finished parsing, assigning returnVal")
            
            returnVal = (UserUUID: returnedUUID, UserName: returnedUserName, QuestionsAnswered: returnedQuestionsAnswered, WalkingDuration: returnedWalkingDuration, ChairAccessible: returnedChairAccessible, WeightsAccessible: returnedWeightsAccessible, ResistBandAccessible: returnedResistBandAccessible, PoolAccessible: returnedPoolAccessible, Intensity: returnedIntensity, PushNotifications: returnedPushNotifications)
            
            completion(returnVal)
            
        }
    }
    
    /*
     This function gets the routines located in Firebase.
     Because of the asynchronous nature of Firebase, call using:
     
     global_UserDataFirestore.Get_Routines(targetUser: <User>) { ReturnedData in
     //Execute any code dependent on the return value of the function here, or assign it to a global variable.
     }
     
     Call without passing a UUID to get the current user, pass a UUID for a specific user other than current user.
     */
    func Get_Routines(targetUser: String?, completion: @escaping ([(RoutineName: String, Exercises: [String])])->()) {
        
        //If the user does not provide a UUID to use, get the current user's UUID
        let targetUUID = targetUser ?? global_UserData.Get_User_Data().UserUUID
        
    }
    
    /*
     This function gets the routines located in Firebase.
     Because of the asynchronous nature of Firebase, call using:
     
     global_UserDataFirestore.Get_ExerciseData(targetUser: <User>) { ReturnedData in
     //Execute any code dependent on the return value of the function here, or assign it to a global variable.
     }
     
     Call without passing a UUID to get the current user, pass a UUID for a specific user other than current user.
     */
    func Get_ExerciseData(targetUser: String?, completion: @escaping ()->()) {
        
        //If the user does not provide a UUID to use, get the current user's UUID
        let targetUUID = targetUser ?? global_UserData.Get_User_Data().UserUUID
        
    }
    
}

/*
 let dateFormatter = DateFormatter()
 
 dateFormatter.calendar = Calendar.current
 dateFormatter.dateFormat = "MMM d, yyyy, hh:mm a"
 let generatedDate = dateFormatter.date(from: "Nov 13, 2019, 11:00 AM")!
 
 let currentDate = Date()
 let dayAdded = Calendar.current.date(byAdding: .day, value: 1, to: generatedDate)
 
 print("\(generatedDate)")
 print("\(currentDate)")
 print("\(String(describing: dayAdded))")
 
 let dayHasPassed = currentDate >= dayAdded!
 
 print("\(dayHasPassed)")
 
 let generatedString = dateFormatter.string(from: generatedDate)
 
 print("\(generatedString)")
 
 let regeneratedDate = dateFormatter.date(from: generatedString)
 
 print("\(regeneratedDate)")
 
 let regeneratedDayAdded = Calendar.current.date(byAdding: .day, value: 1, to: regeneratedDate!)
 
 let regeneratedDayHasPassed = currentDate >= regeneratedDayAdded!
 
 print("\(regeneratedDayHasPassed)")
 */
