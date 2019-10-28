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
    Created file, implemented CMPedometer
*/

import CoreMotion

//create pedometer
class StepCount{
    
    let pedometer = CMPedometer() //instance of CMPedometer class
    
    func track_steps(){
        //check if step counting data is available
        if CMPedometer.isStepCountingAvailable() {
            //accumulate steps since the beginning date
            //dates can be up to 7 days old
            pedometer.startUpdates(from: Date()){ (data, error) in
                //insert to DB to retain data older than 7 days
                
            }
            //pedometer.stopUpdates() //still need to figure this out
        }
    }
    
    /*
    func user_permission(){
        //wrapper func for CMAUthorizationStatus
        //need to check for user permission using CMAuthorizationStatus
        enum CMAuthorizationStatus: Int {
            case notDetermined
            case restricted
            case denied
            case authorized
        }
        
        let authStat = CMPedometer.authorizationStatus()
        
    }*/
}


