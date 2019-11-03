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

import UIKit

class TrendViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var Title_label: UILabel!
    @IBOutlet weak var trendTableView: UITableView!
    @IBOutlet weak var UpdateButton: UIButton!

    let exerciseData = global_UserData.Get_Exercises_all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Setup.m_bgColor
        
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
    
    //Table View Material From https://www.youtube.com/watch?v=kCIQM7L-w4Y
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
        
        if(row == -1)
        {
            let text =  "Step Count This Hour: " + global_StepTracker.steps.description
            cell.textLabel?.text = text
        }
        else{
            let text = "\(exerciseData[row].Year)/\(exerciseData[row].Month)/" +
            "\(exerciseData[row].Day) Hour: \(exerciseData[row].Hour)       \(exerciseData[row].nameOfExercise)"
            cell.textLabel?.text = text
        }
    
        
        return cell
    }

    @IBAction func Update(_ sender: UIButton) {
        self.trendTableView.reloadData()
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
