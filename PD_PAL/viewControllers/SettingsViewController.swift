//
//  SettingsViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = Setup.m_bgColor

        // page name
        let pageName = UILabel()
        pageName.text = "SETTINGS"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        
        // message
        let msg = UILabel()
        msg.text = "Change your settings!"
        msg.applyPageMsgDesign()
        self.view.addSubview(msg)
        // Do any additional setup after loading the view.
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
