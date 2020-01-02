//
//  RecommendAlg.swift
//  PD_PAL
//
//  Created by Julia Kim on 2019-11-24.
//  Copyright © 2019 WareOne. All rights reserved.
// <November 24th, 2019, Julia Kim: Started Recommendation Algorithm>
// <November 25th, 2019, Julia Kim: Added shuffling the list of exercises such that it's not always the same exercise from the category that is recommended; for redundancy, get two least completed categories in case there was no match with the least completed category with the user answers>
// <November 28th, 2019, Julia Kim: Made minor changes in convertEquipment, got rid of images folder as requested by Spencer>
// <November 30th, 2019, Julia Kim: Made minor logic changes in getExInCat>

/*
 Notes:
 -Need to be tested with the highlighting. -> works
 -When calling my func, Arian will have to check if there's at least one exercise completed since my funcs will provide recommendation for the least completed category with the default behaviour as flexibility if there's a 4-way tie i.e. no exercises were completed or all categories have the same numbers completed.
 -I will refactor, time permitting
 */


import Foundation

class RecommendAlg{
    var flexCount: Int
    var cardioCount: Int
    var balanceCount: Int
    var strengthCount: Int
    var leastCat: [String]
    var leastEx: String
    var leastCombo: [String]
    var secondLeastCombo: [String]
    let exerciseList = global_ExerciseData.exercise_names()
    var categoryMatch = (" ", " ", " ", " ", " ", 0, 0)
    let userAns = global_UserData.Get_User_Data()
    
    init(){
        flexCount = 0
        cardioCount = 0
        balanceCount = 0
        strengthCount = 0
        leastCat = [" ", " "]
        leastEx = " "
        leastCombo = [leastCat[0], leastEx]
        secondLeastCombo = [leastCat[1], leastEx] //if not able to match least completed with questions, try with the second least completed
    }
    
    func checkUserAns() -> [String]{
        leastCat = self.getLeastCat()
        
        //print("Questions answered: \(userAns.2)")
        if userAns.2  //QuestionsAnswered
        {
            return self.getRecommend()
        }
        else
        {
            //no answers to the questionnaire
            //to even out the star graph
            leastEx = getExInCat(LeastCategory: leastCat[0])
            leastCombo = [leastCat[0], leastEx]
            return leastCombo
        }
    }
    
    func getRecommend() -> [String]{
        var equipmentType: [String] = ["", "",""]
        var foundLeastCombo = false
        equipmentType = convertEquipment()
        
        /*print("LEAST CATEGORY: \(leastCat)")
        print("EQUIPMENT TYPE: \(equipmentType)")*/
        
        //mix up the order of exercise names
        //shuffled() is O(n)
        let shuffledExList = exerciseList.shuffled()
        
        //print("SHUFFLED LIST: \(shuffledExList)")
        
        for entry in shuffledExList{
            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry)
            
            //intensity, equipment match with what the user set and is one of the exercises in least frequently completed category
            /* test
            print("categoryMatch.4: \(categoryMatch.4)")
            print("userAns.8: \(userAns.8)")
            print("categoryMatch.2: \(categoryMatch.2)")
            print("categoryMatch.1: \(categoryMatch.1)")
            print("leastCat[0]:\(leastCat[0])")
            print("equipmentType[0] \(equipmentType[0])")*/
            
            if categoryMatch.4 == userAns.8 && (categoryMatch.2 == equipmentType[0] || categoryMatch.2  == equipmentType[1] || categoryMatch.2  == equipmentType[2]) && categoryMatch.1 == leastCat[0]
            {
                leastCombo = [leastCat[0], entry]
                //return the first on the list of the least frequently completed category, exercise name
                //print("Least Combo with Equipment: \(leastCombo)")
                foundLeastCombo = true
                return leastCombo
            }
            
                
        }
        
        
        //print("foundLeastCombo: \(foundLeastCombo)")
        if !foundLeastCombo //check for redundancy since if leastCombo was found, the function would have returned
        {
            for entry in shuffledExList{
                //print("leastCat[1]:\(leastCat[1])")
                categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry)
               
                //first least category didn't have any match
               if categoryMatch.4 == userAns.8 && (categoryMatch.2 == equipmentType[0] || categoryMatch.2 == equipmentType[1] || categoryMatch.2 == equipmentType[2]) && categoryMatch.1 == leastCat[1]
                {
                    secondLeastCombo = [leastCat[1], entry]
                    //return the first on the list of the least frequently completed category, exercise name
                    //print("Second Least Combo with Equipment: \(secondLeastCombo)")
                    foundLeastCombo = false //reset before
                    return secondLeastCombo
                }
           }
        }
       
        
        print("No recommendations made")
        return [" ", " "] //if no recommendation was found, but this will rarely happen
    }
    
    func convertEquipment() -> [String]{
        var equipType: [String] = [" ", " " , " "]
       
        //convert bool values to string to give the name of the equipment
        if userAns.4 && userAns.5 && userAns.6
        {
             equipType[0] = "Chair"
             equipType[1] = "Resistive Band"
             equipType[2] = "Weights"
        }
        else if userAns.4
        {
            if userAns.5
            {
                equipType[0] = "Chair"
                equipType[1] = "Weights"
                equipType[2] = "None"
            }
            else if userAns.6
            {
                equipType[0] = "Chair"
                equipType[1] = "Resistive Band"
                equipType[2] = "None"
            }
            else
            {
                equipType[0] = "Chair"
                equipType[1] = "None"
                equipType[2] = "None"
            }
        }
        else if userAns.5
        {
            if userAns.6
            {
                equipType[0] = "Weights"
                equipType[1] = "Resistive Band"
                equipType[2] = "None"
            }
            else
            {
                 equipType[0] = "Weights"
                 equipType[1] = "None"
                 equipType[2] = "None"
            }
        }
        else if userAns.6
        {
            equipType[0] = "Resistive Band"
            equipType[1] = "None"
            equipType[2] = "None"
            
        }
        else
        {
            equipType[0] = "None"
            equipType[1] = "None"
            equipType[2] = "None"
        }
    
        return equipType
      
    }

    func getExInCat(LeastCategory: String) -> String {
        //this function is only for the case where user didn't answer the questions
        //just find an exercise in the least completed category
        //print("Least Completed Category: \(LeastCategory)")
        let shuffledList = exerciseList.shuffled()
        
        for entry in shuffledList{
            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry)
            
            if categoryMatch.1 == LeastCategory
            {
                //print("getExInCat: \(entry)")
                return entry //first exercise name that matched least completed category
            }
        }
         return "None" //no exercise, should not happen
    }
    
    func getLeastCat() -> [String]{
        //figure out the least completed category and the second least completed category
        let exerciseData = global_UserData.Get_Exercises_all()
        var twoLeastCompleted: [String] = [" ", " "]
        var categoryMatch = (" ", " ", " ", " ", " ", 0, 0)
        var catCount = [0, 0, 0, 0]
                
                
        for entry in exerciseData{
                //get the category of the exercise done fetched from the DB for the selected date

            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry.nameOfExercise)
               
            if categoryMatch.1 == "Flexibility"
            {
                flexCount += 1
                //print(categoryMatch.1)
                //print(flexCount)
                catCount[0] = flexCount
                
                //print("catCount: \(catCount)")
            }
            else if categoryMatch.1  == "Cardio"
            {
                cardioCount += 1
                //print(categoryMatch.1)
                //print(cardioCount)
                catCount[1] = cardioCount
            }
            else if categoryMatch.1 == "Balance"
            {
                balanceCount += 1
                catCount[2] = balanceCount
            }
            else if categoryMatch.1 == "Strength"
            {
                strengthCount += 1
                catCount[3] = strengthCount
            }
            else
            {
                print("Not a valid category")
            }
                  
        }
        
        //reset counter
        flexCount = 0
        cardioCount = 0
        balanceCount = 0
        strengthCount = 0
        
        //print("Check catCount: \(catCount)")
       
        //check least frequently completed category
        if catCount[0] == catCount.min()
        {
            twoLeastCompleted[0] = "Flexibility"
            if catCount[1] <= catCount[2] && catCount[1] <= catCount[3]
            {
                twoLeastCompleted[1] = "Cardio"
            }
            else if catCount[2] <= catCount[1] && catCount[2] <= catCount[3]
            {
                twoLeastCompleted[1] = "Balance"
            }
            else if catCount[3] <= catCount[1] && catCount[3] <= catCount[2]
            {
                twoLeastCompleted[1] = "Strength"
            }
        }
        else if catCount[1] == catCount.min()
        {
             twoLeastCompleted[0] = "Cardio"
              if catCount[0] <= catCount[2] && catCount[0] <= catCount[3]
              {
                  twoLeastCompleted[1] = "Flexibility"
              }
              else if catCount[2] <= catCount[0] && catCount[2] <= catCount[3]
              {
                  twoLeastCompleted[1] = "Balance"
              }
              else if catCount[3] <= catCount[0] && catCount[3] <= catCount[2]
              {
                  twoLeastCompleted[1] = "Strength"
              }
        }
        else if catCount[2] == catCount.min()
        {
              twoLeastCompleted[0] = "Balance"
              if catCount[0] <= catCount[1] && catCount[0] <= catCount[3]
              {
                  twoLeastCompleted[1] = "Flexibility"
              }
              else if catCount[1] <= catCount[0] && catCount[1] <= catCount[3]
              {
                  twoLeastCompleted[1] = "Cardio"
              }
              else if catCount[3] <= catCount[0] && catCount[3] <= catCount[1]
              {
                  twoLeastCompleted[1] = "Strength"
              }
        }
        else if catCount[3] == catCount.min()
        {
            twoLeastCompleted[0] = "Strength"
            if catCount[0] <= catCount[1] && catCount[0] <= catCount[2]
            {
                twoLeastCompleted[1] = "Flexibility"
            }
            else if catCount[1] <= catCount[0] && catCount[1] <= catCount[2]
            {
                twoLeastCompleted[1] = "Cardio"
            }
            else if catCount[2] <= catCount[0] && catCount[2] <= catCount[1]
            {
                twoLeastCompleted[1] = "Balance"
            }
        }
        else
        {
            //no min, should not happen, but here for edge case check
            return ["None", "None"]
        }
        
        //print("twoLeastCompleted: \(twoLeastCompleted)")
        return twoLeastCompleted
    
    }
}


