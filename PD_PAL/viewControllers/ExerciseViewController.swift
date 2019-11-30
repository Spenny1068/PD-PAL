//
//  WallPushUpViewController.swift
//  PD_PAL
//
//  Created by avafadar on 2019-10-31.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    /* IBOutlet Labels */
    @IBOutlet weak var LoadingLabel: UILabel!
    @IBOutlet weak var DescriptionText: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var SetsLabel: UILabel!
    
    /* IBOutlet buttons */
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var exitRoutineButton: UIButton!
    @IBOutlet weak var NextSetButton: UIButton!
    
    /* global variables */
    var exercise_name: String!
    var imageView = UIImageView()
    var seconds: Int = 0
    var timer = Timer()
    var isTimerRunning = false
    var setNumber: Int = 1
    var restInterval = 0
    
    // Animation stuff
    let shapelayer = CAShapeLayer()
    var progress: Float = 0


    /* forward pass data between view controllers */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /* skip segue updates global variables to reload page with next excercise */
        if segue.identifier == "SkipSegue" {
            if Global.routine_index < 0 { Global.routine_index = 0 }
            let vc = segue.destination as! tempViewController
            Global.next_routine_exercise = Global.routine_data[Global.routine_index + 1]
            Global.routine_index += 1
        }
    }
    
    /* put code that depends on IsRoutineExercise flag in here */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print ("log: exerciseViewController")

        if Global.next_routine_exercise != "" { self.exercise_name = Global.next_routine_exercise }
        Global.next_routine_exercise = ""
        
        /* navigation bar stuff */
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = nil
        let homeButton = UIButton(type: .custom)
        homeButton.applyHomeButton()
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: homeButton)
        self.navigationItem.rightBarButtonItem  = barButton
        
        /* populate exercise description */
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name ?? "nil")
        self.show_exercise_description(string: readResult.Description, DLabel: DescriptionLabel, DText: DescriptionText)
        
        /* page message */
        self.show_page_message(s1: exercise_name ?? "Unable to retrieve exercise name", s2: exercise_name ?? "nil")
        
        /* Dynamic elements */
        //-> stop button
        stopButton.applyDefaultTimerButtonFrame()
        stopButton.timerButtonDesign()
        stopButton.setTitle("STOP", for: .normal)
        stopButton.backgroundColor = Global.color_schemes.m_lightRed
        self.view.addSubview(stopButton)
        
        //-> completed Button
        completedButton.applyRightTimerButtonFrame()
        completedButton.timerButtonDesign()
        completedButton.setTitle("NEXT EXERCISE", for: .normal)
        completedButton.backgroundColor = Global.color_schemes.m_blue2
        self.view.addSubview(completedButton)
        
        //-> next set button
        NextSetButton.applyLeftTimerButtonFrame()
        NextSetButton.timerButtonDesign()
        NextSetButton.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
        NextSetButton.setTitle("NEXT SET", for: .normal)
        NextSetButton.backgroundColor = Global.color_schemes.m_lightGreen
        
        //-> timer label
        timerLabel.timerAndSetsDesign()
        timerLabel.applyTimerLabelFrame()
        self.view.addSubview(timerLabel)
        
        //-> sets label
        SetsLabel.timerAndSetsDesign()
        SetsLabel.applySetsLabelFrame()
        SetsLabel.text = "SET " + "\(self.setNumber)"
        
        //-> timer animation
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 285, y: 488), radius: 50, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = Global.color_schemes.m_blue1.cgColor
        shapelayer.lineWidth = 10
        shapelayer.lineCap = CAShapeLayerLineCap.round
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.strokeEnd = 0
        view.layer.addSublayer(shapelayer)
        
        /* when entering this page, hide these elements */
        shapelayer.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        SetsLabel.isHidden = true
        completedButton.isHidden = true
        exitRoutineButton.isHidden = true
        NextSetButton.isHidden = true
        
        /* show these elements */
        DescriptionText.isHidden = false
        DescriptionLabel.isHidden = false
        LoadingLabel.isHidden = false
        
        /* we came from routines page */
        if Global.IsRoutineExercise == 1 {
            
            /* Skip button */
            skipButton.applyLeftTimerButtonFrame()
            skipButton.timerButtonDesign()
            skipButton.setTitle("SKIP",for: .normal)
            skipButton.backgroundColor = Global.color_schemes.m_lightGreen
            skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
            self.view.addSubview(skipButton)
            
            /* start button */
            startButton.applyRightTimerButtonFrame()
            startButton.timerButtonDesign()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            self.view.addSubview(startButton)
            
            completedButton.setTitle("NEXT EXERCISE", for: .normal)
        }
            
        /* we came from categories page */
        else if Global.IsRoutineExercise == 0 {
            
            exitRoutineButton.isHidden = true
            
            /* start button */
            startButton.applyDefaultTimerButtonFrame()
            startButton.timerButtonDesign()
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = Global.color_schemes.m_lightGreen
            self.view.addSubview(startButton)
            
            completedButton.setTitle("COMPLETED", for: .normal)
        }
        
        /* last exercise */
        if Global.routine_index == 2 {
            exitRoutineButton.isHidden = false
            skipButton.isHidden = true
            
            exitRoutineButton.applyLeftTimerButtonFrame()
            exitRoutineButton.setTitle("EXIT ROUTINE", for: .normal)
            exitRoutineButton.backgroundColor = Global.color_schemes.m_lightRed
            exitRoutineButton.timerButtonDesign()
            
            completedButton.setTitle("EXIT", for: .normal)
        }
    }
    
    /* put code that does not depends on IsRoutineExercise flag in here */
    override func viewDidLoad() {
        logNavigationStack()
        
        super.viewDidLoad()
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        
        /* when entering this page, hide these elements */
        shapelayer.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        SetsLabel.isHidden = true
        completedButton.isHidden = true
        exitRoutineButton.isHidden = true
        NextSetButton.isHidden = true
        
        /* when entering this page, show these elements */
        startButton.isHidden = false
        skipButton.isHidden = false
    }
    
    /* put slow code in here to run on a different thread */
    override func viewDidAppear(_ animated: Bool) {
        
        /* gif */
        let temp = global_ExerciseData.read_exercise(NameOfExercise: exercise_name ?? "nil")
        let gif = UIImage.gifImageWithName(temp.Link)
        imageView = UIImageView(image: gif)
        imageView.frame = CGRect(x: 0, y: 112, width: 375, height: 300)
        view.addSubview(imageView)
        
        /* hide loading label when gif has loaded */
        LoadingLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /* if back button is pressed */
        if self.isMovingFromParent {
            if Global.routine_index > 0 { Global.routine_index = Global.routine_index - 1 }
        }
    }
    
    /* when start button is tapped */
    @IBAction func startButton(_ sender: Any) {
        
        /* hide these elements */
        DescriptionLabel.isHidden = true
        DescriptionText.isHidden = true
        startButton.isHidden = true
        skipButton.isHidden = true
        exitRoutineButton.isHidden = true
        
        /* show these elements */
        shapelayer.isHidden = false
        stopButton.isHidden = false
        timerLabel.isHidden = false
        SetsLabel.isHidden = false
        
        /* start timer */
        runTimer()
    }
    
    /* when the exit routine button is tapped */
    @IBAction func exitRoutine(_ sender: Any) {
        
        killGif() /* kill running gif */
        
        /* navigate to main page */
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
        
        exitRoutineButton.isHidden = true
    }
    
    /* when stop button is tapped */
    @IBAction func stopButton(_ sender: Any) {
        
        /* reset timer value */
        timer.invalidate()
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name ?? "nil")
        seconds = data.Duration
        timerLabel.text = "\(seconds)"
        
        /* show these elements */
        DescriptionLabel.isHidden = false
        DescriptionText.isHidden = false
        startButton.isHidden = false
        skipButton.isHidden = false
        
        /* hide these elements */
        shapelayer.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        SetsLabel.isHidden = true
    }
    
    /* when completed button is tapped */
    @IBAction func completedButton(_ sender: Any) {
       
        if self.setNumber == 1 {
            /* parse Date() function into year, month, day, and hour */
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            let hour = Calendar.current.component(.hour, from: Date())
            
            /* insert excercise as done */
            global_UserData.Add_Exercise_Done(ExerciseName: exercise_name ?? "nil", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
        }
        
        killGif() /* kill running gif */
        
        /* if we came from categories */
        if Global.IsRoutineExercise == 0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
            self.present(newViewController, animated: true, completion: nil)
        }
        
        /* if we came from routines */
        else if Global.IsRoutineExercise == 1 {
            startButton.isHidden = false
            skipButton.isHidden = false
            
            /* last excercise */
            if Global.routine_index == 2 {
                            
                /* navigate to home page */
                print ("log: completed button tapped on last excercise")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
                self.present(newViewController, animated: true, completion: nil)
                
                /* reset routine index */
                Global.routine_index = 0
            }
        }
    }
    
    /* when home button on navigation bar is tapped */
    @objc func homeButtonTapped(sender: UIButton!) {
        
        killGif() /* kill running gif */
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainNavVC")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    /* next set button is tapped  */
    @objc func nextSetButtonTapped(sender: UIButton!) {

        if self.setNumber == 1 {
            /* parse Date() function into year, month, day, and hour */
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            let day = Calendar.current.component(.day, from: Date())
            let hour = Calendar.current.component(.hour, from: Date())
            
            /* insert excercise as done */
            global_UserData.Add_Exercise_Done(ExerciseName: exercise_name ?? "nil", YearDone: year, MonthDone: month, DayDone: day, HourDone: hour)
        }
        
        /* update set number variable */
        self.setNumber = self.setNumber + 1
        SetsLabel.text = "SET " + "\(self.setNumber)"
        self.progress = 0
        
        /* last set */
        let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name ?? "nil")
        if self.setNumber == readResult.Sets {
            completedButton.applyDefaultTimerButtonFrame()
        }
        
        /* hide these elements */
        completedButton.isHidden = true
        NextSetButton.isHidden = true
        
        /* show these elements */
        shapelayer.isHidden = false
        timerLabel.isHidden = false
        SetsLabel.isHidden = false
        stopButton.isHidden = false
        
        /* reset timer */
        timer.invalidate()
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name ?? "nil")
        seconds = data.Duration
        self.restInterval = 0
        runTimer()
    }
    
    /* skip button is tapped */
    @objc func skipButtonTapped() {
        killGif() /* kill running gif */
    }
    
    /* starts timer */
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name ?? "nil")
        seconds = data.Duration
    }
    
    /* decrements timer */
    @objc func updateTimer() {
        if restInterval == 0 {
            seconds -= 1
            timerLabel.text = "\(seconds)" + "s"
        } else {
            seconds += 1
            timerLabel.text = "REST: " + "\(seconds)" + "s"
        }
        
        /* Animate circular progress */
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = progress
        let data = global_ExerciseData.read_exercise(NameOfExercise: self.exercise_name ?? "nil")
        let maxTime = data.Duration
        progress += 1/Float(maxTime)
        basicAnimation.toValue = progress
        shapelayer.strokeEnd = CGFloat(progress)
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shapelayer.add(basicAnimation, forKey: "Update")

        /* when countdown is done */
        if seconds <= 0 {
            stopButton.isHidden = true
            completedButton.isHidden = false
            NextSetButton.isHidden = false
            shapelayer.isHidden = true
            
            SetsLabel.text = "SET " + "\(self.setNumber)" + " FINISHED!"
            self.restInterval = 1
            
            /* last set */
            let readResult = global_ExerciseData.read_exercise(NameOfExercise: exercise_name ?? "nil")
            if self.setNumber == readResult.Sets { NextSetButton.isHidden = true }
        }
    }
    
    func killGif() {
        self.imageView.removeFromSuperview()
        self.imageView = UIImageView()
    }

}
