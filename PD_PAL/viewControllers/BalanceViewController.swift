//
//  BalanceViewController.swift
//  PD_PAL
//
//  Created by SpenC on 2019-10-27.
//  Copyright © 2019 WareOne. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Setup.m_bgColor

        let pageName = UILabel()
        pageName.text = "BALANCE"
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
