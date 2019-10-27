//
//  StrengthViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class StrengthViewController: UIViewController {

    @IBOutlet weak var ArmsButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var CoreButton: UIButton!
    @IBOutlet weak var LegsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Setup.m_bgColor

        // page name
        let pageName = UILabel()
        pageName.text = "STRENGTH"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)
        
        // message
        let msg = UILabel()
        msg.text = "Choose a body part!"
        msg.applyPageMsgDesign()
        self.view.addSubview(msg)
        
        ArmsButton.applyDesign()
        BackButton.applyDesign()
        CoreButton.applyDesign()
        LegsButton.applyDesign()
        
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
