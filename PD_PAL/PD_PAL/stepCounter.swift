//
//  stepCounter.swift
//  PD_PAL
//
// This file implements step counter using the CMPedometer
//
//  Created by Julia Kim on 2019-10-28.
//  Copyright © 2019 WareOne. All rights reserved.
//

/*Revision History
 
 -28/10/2019: Julia Kim
    Created file, implemented CMPedometer, added "Privacy - Motion Usage Description" to Info.plist
 -29/10/2019: Julia Kim
    Implemented user permission, separated live updates and querying data history
 
 still need to do for version 1:
 test with real device + test cases
*/

import CoreMotion
import Foundation

//create pedometer
class StepCount{
    
    var pedometer = CMPedometer() //instance of CMPedometer class
    var getHistory = false
    var startDate = Date() //initialized to current date
    var endDate = Date() //initialize to current date
    
    //see if specific date was selected
    @IBAction func dateBtnSelected() -> Void{
        getHistory = true
        //need to finish this function for version 2
    }
    
    func user_permission() -> Bool{
        //wrapper func for CMAUthorizationStatus
        //need to check for user permission using CMAuthorizationStatus
        var authStat = false
        switch CMPedometer.authorizationStatus()
        {
        case .denied: pedometer.stopUpdates()
        case .authorized: authStat = true
        default: break
        }
        
        return authStat
    }
    
    func track_steps(){
        //check if user authorized collecting data
        if user_permission(){
            //and check if step counting data is available
            if CMPedometer.isStepCountingAvailable() {
            
                if getHistory //to be triggered by trends page later when viewing history
                {
                    //version 2
                    //query step counter data
                    query_steps()
                }
                else
                {
                    //get live updates
                    live_updates() //only get live updates for version 1
                }
            }
        }
        else
        {
            print("No permission to track steps")
        }
    }
    
    func live_updates(){
        //Date() gets the current date
        pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedData = pedometerData, error == nil else {return}
            DispatchQueue.main.async{
                print("\(pedData.numberOfSteps)")
                //insert to user data DB instead of printing once DB is ready
            }
            }
    }
    
    
    func query_steps() {
        //to used for version2
       //query step data for specified dates
        pedometer.queryPedometerData(from: startDate, to: endDate) { pedometerData, error in guard let pedData = pedometerData, error == nil else {print("Error getting the history")
            return}
            print("\(pedData)")
        }
        
    }
    
    
  
}


