//
//  FlexibilityViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//
// Revision History:
// <Date, Name, Changes made>
// <October 27, 2019, Spencer Lall, applied default page design>

import UIKit

class FlexibilityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Setup.m_bgColor

        let pageName = UILabel()
        pageName.text = "FLEXIBILITY"
        pageName.applyPageNameDesign()
        self.view.addSubview(pageName)    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
