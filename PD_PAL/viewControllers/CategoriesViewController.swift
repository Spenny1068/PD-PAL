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


import UIKit

class CategoriesViewController: UIViewController {

    // category button
    @IBOutlet weak var flexibilityButton: UIButton!
    @IBOutlet weak var strengthButton: UIButton!
    @IBOutlet weak var cardioButton: UIButton!
    @IBOutlet weak var balanceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.color_schemes.m_bgColor // background color
        
        /* category buttons */
        
        // flexibility
        //let flexibilityButton = UIButton()
        flexibilityButton.setTitle("Flexibility",for: .normal)                            // button text
        flexibilityButton.categoryButtonDesign()
        flexibilityButton.backgroundColor = Global.color_schemes.m_flexButton             // background color
        //let flexibilityImage = UIImage(named: "flexibility.png")
        //flexibilityButton.setImage(flexibilityImage , for: UIControl.State.normal)
        
        // strength
        //let strengthButton = UIButton()
        strengthButton.setTitle("Strength",for: .normal)                            // button text
        strengthButton.categoryButtonDesign()
        strengthButton.backgroundColor = Global.color_schemes.m_blue2             // background color
        //let strengthImage = UIImage(named: "strength.png")
        //strengthButton.setImage(strengthImage , for: UIControl.State.normal)
        
        // cardio
        //let cardioButton = UIButton()
        cardioButton.setTitle("Cardio",for: .normal)                            // button text
        cardioButton.categoryButtonDesign()
        cardioButton.backgroundColor = Global.color_schemes.m_blue4             // background color
        //let cardioImage = UIImage(named: "cardio.png")
        //cardioButton.setImage(cardioImage , for: UIControl.State.normal)
        
        // balance
        //let balanceButton = UIButton()
        balanceButton.setTitle("Balance",for: .normal)                            // button text
        balanceButton.categoryButtonDesign()
        balanceButton.backgroundColor = Global.color_schemes.m_blue1             // background color
        //let balanceImage = UIImage(named: "balance.png")
        //balanceButton.setImage(balanceImage , for: UIControl.State.normal)
        
        // show buttons
        self.view.addSubview(flexibilityButton)
        self.view.addSubview(strengthButton)
        self.view.addSubview(cardioButton)
        self.view.addSubview(balanceButton)


        // flexiblity button constraints
        NSLayoutConstraint.activate([
            flexibilityButton.widthAnchor.constraint(equalToConstant: 152),
            flexibilityButton.heightAnchor.constraint(equalToConstant: 208),
            flexibilityButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 23),
            flexibilityButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -200),
            flexibilityButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 135)
        ])
        
        // cardio button constraints
        NSLayoutConstraint.activate([
            cardioButton.widthAnchor.constraint(equalToConstant: 152),
            cardioButton.heightAnchor.constraint(equalToConstant: 208),
            cardioButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 200),
            cardioButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -23),
            cardioButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 135)
        ])

        // strength button constraints
        NSLayoutConstraint.activate([
            strengthButton.widthAnchor.constraint(equalToConstant: 152),
            strengthButton.heightAnchor.constraint(equalToConstant: 208),
            strengthButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 23),
            strengthButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -200),
            strengthButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 391)
        ])
        
        
        // balance button constraints
        NSLayoutConstraint.activate([
            balanceButton.widthAnchor.constraint(equalToConstant: 152),
            balanceButton.heightAnchor.constraint(equalToConstant: 208),
            balanceButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 200),
            balanceButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -23),
            balanceButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 391)
        ])
        
        // message
        self.show_page_message(s1: "Select A Category To Work!", s2: "Category")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
    }
}
