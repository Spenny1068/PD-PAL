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
    var seconds = 5
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    // Animation stuff
    let shapelayer = CAShapeLayer()
    var progress: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //circularProgressBar()
    
        // Draw Shape
        let circularPath = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = Global.color_schemes.m_blue4.cgColor
        shapelayer.lineWidth = 10
        shapelayer.lineCap = CAShapeLayerLineCap.round
        
        // Initial stroke
        shapelayer.strokeEnd = 0
        
        view.layer.addSublayer(shapelayer)
    }
    
    
    @IBAction func StartTapped(_ sender: UIButton) {
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" + "s" //This will update the label
        
        // Animate circular progress
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        shapelayer.strokeEnd = 2
        progress += 1
        basicAnimation.toValue = progress
        basicAnimation.duration = 9
        
        shapelayer.add(basicAnimation, forKey: "Yikes")
        
        /* when countdown is done, hide and show these elements */
        if seconds <= 0 {
            //stopButton.isHidden = true
            //completedButton.isHidden = false
            timerLabel.text = "Complete!"
            timer.invalidate()
            
            // Keeps animation after completion
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
        }
    }
}
