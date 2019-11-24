//
//  RecommendAlg.swift
//  PD_PAL
//
//  Created by Julia Kim on 2019-11-24.
//  Copyright © 2019 WareOne. All rights reserved.
//

import Foundation

class RecommendAlg{
    var flexCount: Int
    var cardioCount: Int
    var balanceCount: Int
    var strengthCount: Int
    var leastCat: String
    var leastEx: String
    var leastCombo: [String]
    
    let exerciseList = global_ExerciseData.exercise_names()
    var categoryMatch = (" ", " ", " ", " ", " ", 0)
    let userAns = global_UserData.Get_User_Data()
    
    init(){
        flexCount = 0
        cardioCount = 0
        balanceCount = 0
        strengthCount = 0
        leastCat = " "
        leastEx = " "
        leastCombo = [leastCat, leastEx]
    }
    
    func checkUserAns() -> [String]{
        leastCat = self.getLeastCat()
        
        //print("Questions answered: \(userAns.2)")
        if userAns.2 == true //QuestionsAnswered
        {
            return getRecommend()
        }
        else
        {
            //no answers to the questionnaire
            //to even out the star graph
            leastEx = getExInCat(LeastCategory: leastCat)
            leastCombo = [leastCat, leastEx]
            return leastCombo
        }
    }
    
    func getRecommend() -> [String]{
        var equipmentType: String = "None"
    
        equipmentType = convertEquipment()
        
        for entry in exerciseList{
            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry)
            
            //intensity, equipment match with what the user set and is one of the exercises in least frequently completed category
            if /*categoryMatch.4 == userAns.8&& */categoryMatch.3 as String == equipmentType && categoryMatch.1 as String == leastCat
            {
                leastCombo = [leastCat, entry]
                //return the first on the list of the least frequently completed category, exercise name
                print("Least Combo with Equipment: \(leastCombo)")
                return leastCombo
            }
                
        }
               
        return [" ", " "] //if no recommendation was found, but this will rarely happen
    }
    
    func convertEquipment() -> String{
        var equipType = " "
        if userAns.4
        {
            if userAns.6
            {
                equipType = "Chair, Resistive Band"
            }
            else if userAns.5
            {
                equipType = "Chair, Weights"
            }
            else
            {
                equipType = "Chair"
            }
        }
        else if userAns.5
        {
            equipType = "Weights"
        }
        else if userAns.6
        {
            equipType = "Resistive Band"
        }
        else
        {
            equipType = "None"
        }
    
        return equipType
      
    }

    func getExInCat(LeastCategory: String) -> String {
       
        print("Least Completed Category: \(LeastCategory)")
        for entry in exerciseList{
            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry)
            
            if categoryMatch.1 as String == LeastCategory
            {
                return entry as String //first exercise name that matched least completed category
            }
        }
         return "Walking" //default exercise
    }
    
    func getLeastCat() -> String{
        
        let exerciseData = global_UserData.Get_Exercises_all()
        var leastCompleted  = " "
        var categoryMatch = (" ", " ", " ", " ", " ", 0)
        var catCount = [0, 0, 0, 0]
                
                
        for entry in exerciseData{
                //get the category of the exercise done fetched from the DB for the selected date

            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry.nameOfExercise)
               
            if categoryMatch.1 as String == "Flexibility"
            {
                flexCount += 1
                //print(categoryMatch.1)
                //print(flexCount)
                catCount[0] = flexCount
            }
            else if categoryMatch.1 as String == "Cardio"
            {
                cardioCount += 1
                //print(categoryMatch.1)
                //print(cardioCounter)
                catCount[1] = cardioCount
            }
            else if categoryMatch.1 as String == "Balance"
            {
                balanceCount += 1
                catCount[2] = balanceCount
            }
            else if categoryMatch.1 as String == "Strength"
            {
                strengthCount += 1
                catCount[3] = strengthCount
            }
            else
            {
                print("Not a valid category")
            }
                  
        }
        
        //reset
        flexCount = 0
        cardioCount = 0
        balanceCount = 0
        strengthCount = 0
        
        //check least frequently completed category
        if catCount[0] == catCount.min()
        {
            leastCompleted = "Flexbility"
        }
        else if catCount[1] == catCount.min()
        {
            leastCompleted = "Cardio"
        }
        else if catCount[2] == catCount.min()
        {
            leastCompleted = "Balance"
        }
        else if catCount[3] == catCount.min()
        {
            leastCompleted = "Strength"
        
        }
        else
        {
            print("No min was found")
            //assign flexbility as default
            leastCompleted = "Flexbility"
        }
        
        
        return leastCompleted
    
    }
}

