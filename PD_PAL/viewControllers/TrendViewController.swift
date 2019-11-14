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
// <November 2, 2019, William Xue , Added table displaying exercise history and step count

import UIKit

class TrendViewController: UIViewController, UITableViewDataSource {

    // IBOutlet labels
    @IBOutlet weak var Title_label: UILabel!
    @IBOutlet weak var trendTableView: UITableView!
    @IBOutlet weak var UpdateButton: UIButton!

    var exerciseData = global_UserData.Get_Exercises_all()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        trendTableView.dataSource = self
        
        let userData = global_UserData.Get_User_Data()
        let username = userData.UserName
                
        // message
        self.show_page_message(s1: username + " Trends!", s2: "Trends")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
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
    }
}
