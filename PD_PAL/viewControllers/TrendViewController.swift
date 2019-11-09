//
//  TrendViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>
// <November 2, 2019, William Xue , Added table displaying exercise history and step count>
// <November 8, 2019, Julia Kim, Getting counts for each category>

import UIKit
import Charts //import to allow creating graphs

class TrendViewController: UIViewController, UITableViewDataSource {

    // IBOutlet labels
    @IBOutlet weak var Title_label: UILabel!
    @IBOutlet weak var trendTableView: UITableView!
    @IBOutlet weak var UpdateButton: UIButton!
    @IBOutlet weak var radarChartView: RadarChartView!
    
    var strengthCounter = 0
    var flexCounter = 0
    var cardioCounter = 0
    var balanceCounter = 0
    
    var exerciseData = global_UserData.Get_Exercises_all()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Setup.m_bgColor  // background color
        trendTableView.dataSource = self
        
        let userData = global_UserData.Get_User_Data()
        let username = userData.UserName.uppercased()
        
        // page name
        let pageName = UILabel(frame: CGRect.zero)
        pageName.text = username + "'S TRENDS"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        NSLayoutConstraint.activate([
            pageName.widthAnchor.constraint(equalToConstant: 350),
            pageName.heightAnchor.constraint(equalToConstant: 50),
            pageName.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            pageName.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75)
        ])
        
        // message
        let msg = UILabel()
        msg.text = "You're Doing Great!"
        msg.applyPageMsgDesign()
        self.view.addSubview(msg)
      
        
    }
    
    // table View Material From https://www.youtube.com/watch?v=kCIQM7L-w4Y
    func numberOfSections(in tableView: UITableView) -> Int {
        //one section for exercise history and one section for step count
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return exerciseData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!

        //so that the first row is step count and the other rows are from exerciseData
        let row = indexPath.row - 1
        
        if(row == -1) {
            let text =  "Step Count This Hour: " + global_StepTracker.steps.description
            cell.textLabel?.text = text
        }

        else {
            let text = "\(exerciseData[row].Year)/\(exerciseData[row].Month)/" +
            "\(exerciseData[row].Day) Hour: \(exerciseData[row].Hour)       \(exerciseData[row].nameOfExercise)"
            cell.textLabel?.text = text
        }
        return cell
    }

    @IBAction func Update(_ sender: UIButton) {
        exerciseData = global_UserData.Get_Exercises_all()
        self.trendTableView.reloadData()
        //generateRadarChart() //need its own button
    }

    func generateRadarChart(){
        //var dataEntries = exerciseCategoryCount()
        
    }
    
    //This function fetches exercises done by the user, identifies the category to count how many exercises are done in each category
    func exerciseCategoryCount() -> [Int]{
        let exerciseData = global_UserData.Get_Exercises_all()
        var categoryMatch = (" ", " ", " ", " ", " ")
        var catCount = [0, 1, 2, 3]
        for entry in exerciseData{
            //get the category of the exercise done fetched from the DB
            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry.nameOfExercise)
            
            //figure out which counter to increment
            if categoryMatch.1 as String == "Flexibility"
            {
                flexCounter += 1
                //print(categoryMatch.1)
                //print(flexCounter)
                catCount[0] = flexCounter
            }
            else if categoryMatch.1 as String == "Cardio"
            {
                cardioCounter += 1
                //print(categoryMatch.1)
                //print(cardioCounter)
                catCount[1] = cardioCounter
            }
            else if categoryMatch.1 as String == "Balance"
            {
                balanceCounter += 1
                catCount[2] = balanceCounter
            }
            else if categoryMatch.1 as String == "Strength"
            {
                strengthCounter += 1
                catCount[3] = strengthCounter
            }
            else
            {
                print("Not a valid category")
            }
            
            
            
        }
        
        return catCount
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
