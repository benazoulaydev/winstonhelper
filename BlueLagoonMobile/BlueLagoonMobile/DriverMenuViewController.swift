//
//  DriverMenuViewController.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 06/05/2018.
//  Copyright © 2018 Benazoulaydev. All rights reserved.
//

import UIKit

class DriverMenuViewController: UITableViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbName.text = User.currentUser.name
        
        imgAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        imgAvatar.layer.cornerRadius = 70 / 2
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.clipsToBounds = true
        
        
        view.backgroundColor = UIColor(red:0.11, green:0.71, blue:0.57, alpha:1.0)

    
    }

   




}
