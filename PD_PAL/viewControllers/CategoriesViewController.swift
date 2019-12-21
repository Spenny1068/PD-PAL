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
// <November 15, 2019, Izyl Canonicato,  Updated StoryBoard Layout for Categories>
// <November 27, 2019, Arian Vafadar, Highlighted the Categories>


import UIKit

/* nested stack view for grid of category buttons */
class GridStack: UIStackView {

    private var cells: [UIView] = []
    private var currentRow: UIStackView?
    let rowSize: Int
    let rowHeight: CGFloat
    
    // constructor
    init(rowSize: Int, rowHeight: CGFloat) {
        self.rowSize = rowSize
        self.rowHeight = rowHeight
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false   // turn constraints on
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 25                                        // vertical spacing between elements
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func prepareRow() -> UIStackView {
        let row = UIStackView(arrangedSubviews: [])
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 25    // horizontal spacing between elements
        return row
    }
    
    func addCell(view: UIButton) {
        let firstCellInRow = self.cells.count % self.rowSize == 0
        if self.currentRow == nil || firstCellInRow {
            self.currentRow = self.prepareRow()
            self.addArrangedSubview(self.currentRow!)
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: self.rowHeight).isActive = true
        self.cells.append(view)
        self.currentRow!.addArrangedSubview(view)
    }
}

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
        flexibilityButton.setTitle("Flexibility",for: .normal)                                  // button text
        flexibilityButton.categoryButtonDesign()                                                // button design
        flexibilityButton.backgroundColor = Global.color_schemes.m_flexButton                   // background color
        flexibilityButton.setBackgroundImage(UIImage(named: "FlexibilityIcon"), for: .normal)   // background image
        // category highlighting
        if (exerciseRecommend[0] == "Flexibility") {
            flexibilityButton.shadowCategoryButtonDesign()
        }
        
        //-> strength
        strengthButton.setTitle("Strength",for: .normal)
        strengthButton.categoryButtonDesign()
        strengthButton.backgroundColor = Global.color_schemes.m_blue2
        strengthButton.setBackgroundImage(UIImage(named: "StrengthIcon"), for: .normal)
        // category highlighting
        if (exerciseRecommend[0] == "Strength") {
            strengthButton.shadowCategoryButtonDesign()
        }
        
        //-> cardio
        cardioButton.setTitle("Cardio",for: .normal)
        cardioButton.categoryButtonDesign()
        cardioButton.backgroundColor = Global.color_schemes.m_blue4
        cardioButton.setBackgroundImage(UIImage(named: "CardioIcon"), for: .normal)
        // category highlighting
        if (exerciseRecommend[0] == "Cardio") {
            cardioButton.shadowCategoryButtonDesign()
        }
        
        //-> balance
        balanceButton.setTitle("Balance",for: .normal)
        balanceButton.categoryButtonDesign()
        balanceButton.backgroundColor = Global.color_schemes.m_blue1
        balanceButton.setBackgroundImage(UIImage(named: "BalanceIcon"), for: .normal)
        // category highlighting
        if (exerciseRecommend[0] == "Balance") {
            balanceButton.shadowCategoryButtonDesign()
        }
        
        /* create grid of category buttons */
        let categoryGrid = GridStack(rowSize: 2, rowHeight: 208)
        categoryGrid.addCell(view: strengthButton)
        categoryGrid.addCell(view: cardioButton)
        categoryGrid.addCell(view: flexibilityButton)
        categoryGrid.addCell(view: balanceButton)
        self.view.addSubview(categoryGrid)
        
        // category grid stackview constraints
        NSLayoutConstraint.activate([
            categoryGrid.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            categoryGrid.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            categoryGrid.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25),
            categoryGrid.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25),
            categoryGrid.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 130),
            categoryGrid.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75)
        ])
        
        /* page message */
        self.show_page_message(s1: "Select A Category To Work!", s2: "Category")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Global.color_schemes.m_blue3     // nav bar color
    }
    
    
}


