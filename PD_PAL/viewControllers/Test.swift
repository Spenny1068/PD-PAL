//
//  Test.swift
//  PD_PAL
//
//  Created by icanonic on 2019-11-23.
//  Copyright © 2019 WareOne. All rights reserved.
//

import Foundation
import UIKit

class TestVC: UIViewController{
    
    @IBOutlet weak var Start: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    // Timer stuff
    var seconds = 7
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time
//    var realtime: CFTimeInterval = 0.0
//    var maxTime: CFTimeInterval = 0.0
    //var realtime: Int = 5
    var maxTime: Int = 7
    
    // Animation stuff
    let shapelayer = CAShapeLayer()
    var progress: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Draw Shape
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.size.width/2, y: 475), radius: 50, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = Global.color_schemes.m_blue4.cgColor
        shapelayer.lineWidth = 10
        shapelayer.lineCap = CAShapeLayerLineCap.round
        shapelayer.fillColor = UIColor.lightGray.cgColor
        
        // Initial stroke
       shapelayer.strokeEnd = 0
    view.layer.addSublayer(shapelayer)
        
    }
    
    
    @IBAction func StartTapped(_ sender: UIButton) {
        runTimer()
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
//        maxTime = CFTimeInterval(seconds)
//        realtime = CFTimeInterval(seconds)
//        maxTime = Float(seconds)
        
    }
    
    @objc func updateTimer() {
        
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" + "s" //This will update the label
        
        // Animate circular progress
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = progress //start animation at this value
        //divide by the time set
        progress += 1/Float(maxTime)
        basicAnimation.toValue = progress //animate to finish value
        //to make sure that the circular progress bar doesn't snap back to zero, point to the end value
        shapelayer.strokeEnd = CGFloat(progress)
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shapelayer.add(basicAnimation, forKey: "Update")
        
        /* when countdown is done, hide and show these elements */
        if seconds <= 0 {
            timerLabel.text = "Complete!"
            timer.invalidate()
            isTimerRunning = false
            
            // Keeps animation after completion
            //            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            //            basicAnimation.isRemovedOnCompletion = false
        }
    }
}
