//
//  CategoriesViewController.swift
//  PD_PAL
//
//  Created by Zhong Jia Xue on 2019-10-18.
//  Copyright © 2019 WareOne. All rights reserved.
//

// REVISION HISTORY:
// <Date, Name, Changes made>
// <Oct. 26, 2019, Spencer Lall, added categories buttons>
// <October 27, 2019, Spencer Lall, applied default page design>
// <November 15, 2019, Izyl Canonicato, Category buttons >
// <November 27, 2019, Arian Vafadar, Highlighted the Categories>


import UIKit

class CategoriesViewController: UIViewController {

    /* IBOutlet Buttons */
    @IBOutlet weak var flexibilityButton: UIButton!
    @IBOutlet weak var strengthButton: UIButton!
    @IBOutlet weak var cardioButton: UIButton!
    @IBOutlet weak var balanceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.color_schemes.m_bgColor // background color
        
        //used to highlight a category
        let exerciseRecommend = global_UserRecommendation.checkUserAns()
        
        /* category buttons */
        
        //-> flexibility
        flexibilityButton.setTitle("Flexibility",for: .normal)                            // button text
        flexibilityButton.categoryButtonDesign()
        flexibilityButton.backgroundColor = Global.color_schemes.m_flexButton             // background color
        //flexibilityButton.setBackgroundImage(UIImage(named: "FlexibilityBtnImg"), for: .normal)
        flexibilityButton.setBackgroundImage(UIImage(named: "FlexibilityIcon"), for: .normal)
        //Highlights a category if needed
        if (exerciseRecommend[0] == "Flexibility")
        {
            flexibilityButton.shadowCategoryButtonDesign()
        }
        
        //-> strength
        strengthButton.setTitle("Strength",for: .normal)                            // button text
        strengthButton.categoryButtonDesign()
        strengthButton.backgroundColor = Global.color_schemes.m_blue2             // background color
        strengthButton.setBackgroundImage(UIImage(named: "StrengthIcon"), for: .normal)
        //Highlights a category if needed
        if (exerciseRecommend[0] == "Strength")
        {
            strengthButton.shadowCategoryButtonDesign()
        }
        
        //-> cardio
        cardioButton.setTitle("Cardio",for: .normal)                            // button text
        cardioButton.categoryButtonDesign()
        cardioButton.backgroundColor = Global.color_schemes.m_blue4             // background color
//        cardioButton.setBackgroundImage(UIImage(named: "CardioBtnImg"), for: .normal)
        cardioButton.setBackgroundImage(UIImage(named: "CardioIcon"), for: .normal)
        //Highlights a category if needed
        if (exerciseRecommend[0] == "Cardio")
        {
            cardioButton.shadowCategoryButtonDesign()
        }
        
        //-> balance
        balanceButton.setTitle("Balance",for: .normal)                            // button text
        balanceButton.categoryButtonDesign()
        balanceButton.backgroundColor = Global.color_schemes.m_blue1             // background color
        balanceButton.setBackgroundImage(UIImage(named: "BalanceIcon"), for: .normal)
        //Highlights a category if needed
        if (exerciseRecommend[0] == "Balance")
        {
            balanceButton.shadowCategoryButtonDesign()
        }
        
        /* show buttons */
        self.view.addSubview(flexibilityButton)
        self.view.addSubview(strengthButton)
        self.view.addSubview(cardioButton)
        self.view.addSubview(balanceButton)


        /* flexiblity button constraints */
        NSLayoutConstraint.activate([
            flexibilityButton.widthAnchor.constraint(equalToConstant: 152),
            flexibilityButton.heightAnchor.constraint(equalToConstant: 208),
            flexibilityButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 23),
            flexibilityButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -200),
            flexibilityButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 135)
        ])
        
        /* cardio button constraints */
        NSLayoutConstraint.activate([
            cardioButton.widthAnchor.constraint(equalToConstant: 152),
            cardioButton.heightAnchor.constraint(equalToConstant: 208),
            cardioButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 200),
            cardioButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -23),
            cardioButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 135)
        ])

        /* strength button constraints */
        NSLayoutConstraint.activate([
            strengthButton.widthAnchor.constraint(equalToConstant: 152),
            strengthButton.heightAnchor.constraint(equalToConstant: 208),
            strengthButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 23),
            strengthButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -200),
            strengthButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 391)
        ])
        
        
        /* balance button constraints */
        NSLayoutConstraint.activate([
            balanceButton.widthAnchor.constraint(equalToConstant: 152),
            balanceButton.heightAnchor.constraint(equalToConstant: 208),
            balanceButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 200),
            balanceButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -23),
            balanceButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 391)
        ])
        
        /* page message */
        self.show_page_message(s1: "Select A Category To Work!", s2: "Category")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
    }
}
