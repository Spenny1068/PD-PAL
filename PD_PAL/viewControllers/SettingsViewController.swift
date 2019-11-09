//
//  SettingsViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>

import UIKit

class SettingsViewController: UIViewController {
    
    let QuestionStoryboard = UIStoryboard(name: "Questionnare", bundle: Bundle.main)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = Global.color_schemes.m_bgColor  // background color
        
        // message
        self.present_message(s1: "Change Your Settings!", s2: "Settings")
    }
}
