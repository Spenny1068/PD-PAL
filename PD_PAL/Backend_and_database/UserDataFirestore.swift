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
 - 16/11/2019 : William Huong
    Implemented Get_Routines() and Get_ExerciseData()
 - 17/11/2019 : William Huong
    Update_UserInfo() now works
*/

/*
Known Bugs
 
 - 17/11/2019 : William Huong
    Nothing works
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
    
    //Instance of the UserData class to use. This is really only needed for Unit Testing because all of the tests fire off at once, causing race condition issues.
    private let UserDataSource: UserData
    //Instance of Firestore we will use
    private let FirestoreDB = Firestore.firestore()
    
    //To make the rest of the code easier
    private let dateFormatter = DateFormatter()
    private let dateFormat = "MMM d, yyyy, hh:mm:ss a"
    
    //Constructor
    init(sourceGiven: UserData) {
        
        //Set up the date formatter
        self.dateFormatter.calendar = Calendar.current
        self.dateFormatter.dateFormat = self.dateFormat
        
        //Set the UserData to pull from
        self.UserDataSource = sourceGiven
        
    }
    
    //Updates the user info on Firebase.
    //This function will be called as a part of Update_Firebase() and should not be called on its own.
    func Update_UserInfo(completion: @escaping (Int) -> ()) {
        
        print(" --- Beginning update of UserInfo --- ")
        
        //Grab the UserInfo we are going to write to Firestore
        let currentUserInfo = self.UserDataSource.Get_User_Data()
        
        print("Formatting user info for Firestore")
        
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
        
        print("\(docData)")
        
        print("Creating user document reference")
        
        //Create the document reference
        let userDocRef = self.FirestoreDB.document("Users/\(currentUserInfo.UserUUID)")
        
        print("Setting user document data")
        
        userDocRef.getDocument() { (document, error) in
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

        print(" --- Finished updating UserInfo --- ")
 
    }
    
    //Updates the routines on Firebase.
    //This function will be called as a part of Update_Firebase() and should not be called on its own.
    func Update_Routines(completion: @escaping (Int) -> ()) {
        
        print(" --- Beginning updating of Routines --- ")
        
        print("Gathering data")
        
        //define some values we need
        let currentRoutines = self.UserDataSource.Get_Routines()
        let targetUUID = self.UserDataSource.Get_User_Data().UserUUID
        let routineColRef = self.FirestoreDB.collection("Users").document(targetUUID).collection("Routines")
        
        print("\(currentRoutines)")
        
        print("Iterating through each routine to push")
        
        //Iterate through each routine
        for routine in currentRoutines {
            
            print("Starting routine: \(routine.RoutineName)")
            
            let docRef = routineColRef.document(routine.RoutineName)
        
            //Check if the routine is already in Firestore
            docRef.getDocument() { (document ,error) in
                guard let document = document, document.exists else {
                    print("The document for \(routine.RoutineName) does not exist. Creating document")
                    
                    //Add a document for the routine
                    routineColRef.document(routine.RoutineName).setData(["RoutineName": routine.RoutineName, "RoutineContents": routine.Exercises]) { err in
                        if let err = err {
                            print("Failed to create routine document for \(routine.RoutineName) : \(err)")
                            completion(1)
                        } else {
                            print("Successfully created routine document fo \(routine.RoutineName)")
                            completion(0)
                        }
                    }
                    
                    return
                }
                
                //The routine already exists in Firestore. Update it
                docRef.updateData(["RoutineName": routine.RoutineName, "RoutineContents": routine.Exercises]) { err in
                    if let err = err {
                        print("Failed to update routine document for \(routine.RoutineName) : \(err)")
                        completion(1)
                    } else {
                        print("Successfully updated routine document fo \(routine.RoutineName)")
                        completion(0)
                    }
                }
            }
            
        }
        
    }
    
    //Updates the exercise data on Firebase.
    //This function will be called as a part of Update_Firebase() and should not be called on its own.
    func Update_ExerciseData() {
        
    }
    
    /*
    This function gets the UserInfo located in Firebase.
     Because of the asynchronous nature of Firebase, call using:
     
     self.UserDataSourceFirestore.Get_UserInfo(targetUser: <User>) { ReturnedData in
        //Execute any code dependent on the return value of the function here, or assign it to a global variable.
     }
     
    Call without passing a UUID to get the current user, pass a UUID for a specific user other than current user.
    */
    func Get_UserInfo(targetUser: String?, completion: @escaping ((Status: String, UserName: String, QuestionsAnswered: Bool, WalkingDuration: Int, ChairAccessible: Bool, WeightsAccessible: Bool, ResistBandAccessible: Bool, PoolAccessible: Bool, Intensity: String, PushNotifications: Bool))->()) {
        
        //If the user does not provide a UUID to use, get the current user's UUID
        let targetUUID = targetUser ?? self.UserDataSource.Get_User_Data().UserUUID
        
        var returnVal = (Status: "NO_OP", UserName: "DEFAULT_NAME", QuestionsAnswered: false, WalkingDuration: 0, ChairAccessible: false, WeightsAccessible: false, ResistBandAccessible: false, PoolAccessible: false, Intensity: "Light", PushNotifications: false)
        
        let userDocRef = self.FirestoreDB.document("Users/\(targetUUID)")
        
        //Get the document from Firebase
        userDocRef.getDocument { (document, error) in
            print("Beginning document read")
            //Check the document existed
            guard let document = document, document.exists else {
                returnVal.Status = "NO_DOCUMENT"
                print("Did not get a document snapshot: \(String(describing: error))")
                completion(returnVal)
                return
            }
            print("User exists, reading data")
            
            //Get the data in the document
            let dataReturned = document.data()
            
            //Check the data exists
            guard dataReturned != nil else {
                returnVal.Status = "NO_DATA"
                print("Error, document snapshot data was empty. Check Connection")
                completion(returnVal)
                return
            }
            print("Data is not nil, parsing")
            
            //Start parsing the data, since it is returned as type any optionals
            var returnedStatus = "NO_DATA"
            let returnedUserName = dataReturned?["UserName"] as? String ?? "USERNAME_NIL"
            let returnedQuestionsAnswered = dataReturned?["QuestionsAnswered"] as? Bool ?? false
            let returnedWalkingDuration = dataReturned?["WalkingDuration"] as? Int ?? -1
            let returnedChairAccessible = dataReturned?["ChairAccessible"] as? Bool ?? false
            let returnedWeightsAccessible = dataReturned?["WeightsAccessible"] as? Bool ?? false
            let returnedResistBandAccessible = dataReturned?["ResistBandAccessible"] as? Bool ?? false
            let returnedPoolAccessible = dataReturned?["PoolAccessible"] as? Bool ?? false
            let returnedIntensity = dataReturned?["Intensity"] as? String ?? "INTENSITY_NIL"
            let returnedPushNotifications = dataReturned?["PushNotifications"] as? Bool ?? false
            
            if( returnedUserName != "USERNAME_NIL" ) {
                returnedStatus = "SUCCESS"
            }
            
            print("Finished parsing, assigning returnVal")
            
            returnVal = (Status: returnedStatus, UserName: returnedUserName, QuestionsAnswered: returnedQuestionsAnswered, WalkingDuration: returnedWalkingDuration, ChairAccessible: returnedChairAccessible, WeightsAccessible: returnedWeightsAccessible, ResistBandAccessible: returnedResistBandAccessible, PoolAccessible: returnedPoolAccessible, Intensity: returnedIntensity, PushNotifications: returnedPushNotifications)
            
            completion(returnVal)
            
        }
    }
    
    /*
     This function gets the routines located in Firebase.
     Because of the asynchronous nature of Firebase, call using:
     
     self.UserDataSourceFirestore.Get_Routines(targetUser: <User>) { ReturnedData in
     //Execute any code dependent on the return value of the function here, or assign it to a global variable.
     }
     
     Call without passing a UUID to get the current user, pass a UUID for a specific user other than current user.
     */
    func Get_Routines(targetUser: String?, completion: @escaping ([(RoutineName: String, RoutineContents: [String])])->()) {
        
        //If the user does not provide a UUID to use, get the current user's UUID
        let targetUUID = targetUser ?? self.UserDataSource.Get_User_Data().UserUUID
        
        let userRoutinesRef = self.FirestoreDB.collection("Users").document(targetUUID).collection("Routines")
        
        var returnVal: [(RoutineName: String, RoutineContents: [String])] = []
        
        userRoutinesRef.getDocuments() { (snapshot, error) in
            if let error = error {
                print("An error occured while retrieving the Routines : \(error)")
                completion([(RoutineName: "NO_COLLECTION", RoutineContents: ["\(error)"])])
            }
            
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                print("The Routines subcollection was empty : \(String(describing: error))")
                completion([(RoutineName: "NO_DOCUMENTS", RoutineContents: ["\(String(describing: error))"])])
                return
            }
            
            for document in snapshot.documents {
                let documentData = document.data()
                returnVal.append((RoutineName: documentData["RoutineName"] as? String ?? "ERROR", RoutineContents: documentData["RoutineContents"] as? [String] ?? ["ERROR"]))
            }
            
            completion(returnVal)
        }
        
    }
    
    /*
     This function gets the routines located in Firebase.
     Because of the asynchronous nature of Firebase, call using:
     
     self.UserDataSourceFirestore.Get_ExerciseData(targetUser: <User>) { ReturnedData in
     //Execute any code dependent on the return value of the function here, or assign it to a global variable.
     }
     
     Call without passing a UUID to get the current user, pass a UUID for a specific user other than current user.
     */
    func Get_ExerciseData(targetUser: String?, completion: @escaping ([(Year: Int, Month: Int, Day: Int, Hour: Int, ExercisesDone: [String], StepsTaken: Int)]) -> ()) {
        
        //If the user does not provide a UUID to use, get the current user's UUID
        let targetUUID = targetUser ?? self.UserDataSource.Get_User_Data().UserUUID
        
        let userExerciseDataRef = self.FirestoreDB.collection("Users").document(targetUUID).collection("ExerciseData")
        
        var returnVal: [(Year: Int, Month: Int, Day: Int, Hour: Int, ExercisesDone: [String], StepsTaken: Int)] = []
        
        userExerciseDataRef.getDocuments() { (snapshot, error) in
            if let error = error {
                print("An error occured while retrieving the Exercises Done : \(error)")
                completion([(Year: 0, Month: 0, Day: 0, Hour: 0, ExercisesDone: ["NO_COLLECTION"], StepsTaken: 0)])
            }
            
            guard let snapshot = snapshot, snapshot.isEmpty else {
                print("The ExercisesDone subcollection was empty : \(String(describing: error))")
                completion([(Year: 0, Month: 0, Day: 0, Hour: 0, ExercisesDone: ["NO_DOCUMENTS"], StepsTaken: 0)])
                return
            }
            
            for document in snapshot.documents {
                let documentData = document.data()
                returnVal.append((Year: documentData["Year"] as? Int ?? 0, Month: documentData["Month"] as? Int ?? 0, Day: documentData["Day"] as? Int ?? 0, Hour: documentData["Hour"] as? Int ?? 0, ExercisesDone: documentData["ExercisesDone"] as? [String] ?? ["ERROR"], StepsTaken: documentData["StepsTaken"] as? Int ?? 0))
            }
            
            completion(returnVal)
        }
        
    }
    
}
