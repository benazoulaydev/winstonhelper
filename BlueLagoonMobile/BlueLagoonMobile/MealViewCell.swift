//
//  MealViewCell.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 29/03/2018.
//  Copyright © 2018 Benazoulaydev. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {

    @IBOutlet weak var lbMealName: UILabel!

    @IBOutlet weak var lbMealShortDescription: UILabel!

    @IBOutlet weak var lbMealPrice: UILabel!
    @IBOutlet weak var imgMealImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
}
