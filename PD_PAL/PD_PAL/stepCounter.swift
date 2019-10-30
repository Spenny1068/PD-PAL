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
    Created file, implemented CMPedometer, added "Privacy - Motion Usage Description" to Info.plist to ask for user permission
 -29/10/2019: Julia Kim
    Separated live updates and querying data history
 -30/10/2019: Julia Kim
    Tested with a real device to ensure that user permission is asked upon the first time launch of th app and that steps are counted.
 
 still need to do for version 1:
 assertion test cases
*/

import CoreMotion
import Foundation
import Dispatch //only if we want to execute code concurrently on multicore hardware by submitting work to dispatch queues managed by the system.


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
    
    func track_steps(){
        //check if step counting data is available
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
    
    
    func live_updates(){
        /* This function was written using the following source with minor changes.
         Source: wysockikamil.com/coremotion-pedometer-swift */
        
        //Date() gets the current date
        pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let pedData = pedometerData, error == nil else {return}
            DispatchQueue.main.async{
                print("Steps: \(pedData.numberOfSteps)")
                //insert to user data DB instead of printing once DB is ready
                }
            }
    }
    
    
    func query_steps() {
        //to used for version2
        /* This function was written using the following source with minor changes.
         Source: wysockikamil.com/coremotion-pedometer-swift */
       //query step data for specified dates
        pedometer.queryPedometerData(from: startDate, to: endDate) { pedometerData, error in guard let pedData = pedometerData, error == nil else {print("Error getting the history")
            return}
            DispatchQueue.main.async{
                print("Queried Steps: \(pedData.numberOfSteps)")
            }
        }
        
    }
    
    /* Not needed for first time launch permissin pop-up
     func user_permission() -> Bool{
     /*Source: medium.com/simform-engineering/count-steps-with-cmpedometer-on-iwatch-94b61bc3b87e*/
     //wrapper func for CMAUthorizationStatus
     //need to check for user permission using CMAuthorizationStatus
     
     //var authStat = false
     switch CMPedometer.authorizationStatus()
     {
     case .denied: pedometer.stopUpdates()
     case .authorized: authStat = true
     default: break
     }
     
     return authStat
     }
     */
  
}


