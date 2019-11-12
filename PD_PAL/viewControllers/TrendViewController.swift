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
// <November 11, 2019, Julia Kim, Adding scrolling to the page, generate radar graph, implemented date pickers>

/*Known Bugs
 November 11, 2019: Julia Kim
 -The graph generated does not update after loading initially as that feature has not been fully implemented yet.
 -Date Picker not integrated yet.
 
 */

import UIKit
import RadarChart //import to allow creating radar graph


class TrendViewController: UIViewController, UITableViewDataSource {

    // IBOutlet labels
    @IBOutlet weak var Title_label: UILabel!
    @IBOutlet weak var trendTableView: UITableView!
    @IBOutlet weak var UpdateButton: UIButton!
    @IBOutlet weak var rChartView: RadarChartView!
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    private var sDatePicker: UIDatePicker?
    private var eDatePicker: UIDatePicker?
    
    //counter for radar graphs
    var strengthCounter = 0
    var flexCounter = 0
    var cardioCounter = 0
    var balanceCounter = 0
    
    var exerciseData = global_UserData.Get_Exercises_all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDatePicker()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TrendViewController.viewTapped(gestureRecognizer:)))
        
        self.view.addGestureRecognizer(tapGesture)
        
        //to get the scroll working
        //stackoverflow.com/questions/28144739/swift-uiscrollview-not-scrolling
        scroller?.isScrollEnabled = true
        scroller?.contentSize = CGSize(width: 375, height: 2500) //content size must be greater than scroll view constraint
        self.view.addSubview(scroller)
        
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
        
        generateRadarChart() //generate radar chart on load
    }
    
    override func viewDidLayoutSubviews() {
        //this is for graph subviews
        super.viewDidLayoutSubviews()
        rChartView?.prepareForDrawChart()
        rChartView?.setNeedsLayout()
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
        self.rChartView?.reloadInputViews()
    }
    
    func generateLineChart(){
        //this is for step counter data
      
    }
    
    func getDatePicker(){
        //let user select the date for step counter
        sDatePicker = UIDatePicker()
        eDatePicker = UIDatePicker()
        sDatePicker?.datePickerMode = .date
        sDatePicker?.addTarget(self, action: #selector(TrendViewController.sDateChanged(datePicker:)), for: .valueChanged)
        eDatePicker?.datePickerMode = .date
        eDatePicker?.addTarget(self, action: #selector(TrendViewController.eDateChanged(datePicker:)), for: .valueChanged)
        
        startDate.inputView = sDatePicker
        endDate.inputView = eDatePicker
        
    }
    
    @objc func sDateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        startDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    @objc func eDateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        endDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func generateRadarChart(){
        /*Using the library from github.com/nkmrh/RadarChart*/
        let color = UIColor(red:0.282, green:0.541, blue:0.867, alpha:0.50)
        let backgroundColor = UIColor(red:0.851, green:0.851, blue:0.941, alpha:1.00)
        let xAxisColor = UIColor(red:0.396, green:0.769, blue:0.914, alpha:1.00)
        let yAxisColor = UIColor(red:0.596, green:0.863, blue:0.945, alpha:1.50)
        let fontColor = UIColor(red:0.259, green:0.365, blue:0.565, alpha:1.00)
        
        rChartView?.data = self.exerciseCategoryCount() //get the user exercise data
        rChartView?.labelTexts = ["Flexibility", "Cardio", "Balance", "Strength"]
        rChartView?.numberOfVertexes = 4
        rChartView?.numberTicks = 30
        rChartView?.style = RadarChartStyle(color: color,backgroundColor: backgroundColor, xAxis: RadarChartStyle.Axis(colors: [xAxisColor], widths: [0.5, 0.5, 0.5, 0.5, 2.0]),yAxis: RadarChartStyle.Axis(colors: [yAxisColor], widths: [0.5]), label: RadarChartStyle.Label(fontName: "Helvetica", fontColor: fontColor, fontSize: 11, lineSpacing: 0, letterSpacing: 0, margin: 10))
        rChartView?.option = RadarChartOption()
    }
    
    //This function fetches exercises done by the user, identifies the category to count how many exercises are done in each category
    func exerciseCategoryCount() -> [Int]{
        let exerciseData = global_UserData.Get_Exercises_all()
        var categoryMatch = (" ", " ", " ", " ", " ")
        var catCount = [0, 0, 0, 0]
        for entry in exerciseData{
            //get the category of the exercise done fetched from the DB
            categoryMatch = global_ExerciseData.read_exercise(NameOfExercise: entry.nameOfExercise)
            
            //figure out which counter to increment
            if categoryMatch.1 as String == "Flexibility"
            {
                flexCounter += 1
                //print(categoryMatch.1)
                //sprint(flexCounter)
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
