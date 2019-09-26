//
//  WeatherViewCell.swift
//  BlueLagoonMobile
//
//  Created by Azoulay ben on 25/09/2019.
//  Copyright © 2019 Benazoulaydev. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewCell: UITableViewCell {
    
    @IBOutlet weak var lbRestaurantName: UILabel!
    
    @IBOutlet weak var imgRestaurantLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(item:WeatherItem) {
        lbRestaurantName.text = item.text
        imgRestaurantLogo.image = item.image
    }

}
