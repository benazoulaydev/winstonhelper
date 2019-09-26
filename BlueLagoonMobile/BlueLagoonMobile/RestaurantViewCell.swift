//
//  RestaurantViewCell.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 14/02/2018.
//  Copyright © 2018 Benazoulaydev. All rights reserved.
//

import UIKit

class RestaurantViewCell: UITableViewCell {
    
    @IBOutlet weak var lbRestaurantName: UILabel!
    @IBOutlet weak var lbRestaurantAddress: UILabel!
    
    @IBOutlet weak var imgRestaurantLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
