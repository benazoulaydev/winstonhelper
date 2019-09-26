//
//  DataPresentingViewController.swift
//  BlueLagoonMobile
//
//  Created by Azoulay ben on 25/09/2019.
//  Copyright © 2019 Benazoulaydev. All rights reserved.
//
import Foundation
import UIKit
class DataPresentingViewController: UIViewController {
    @IBAction func dismissPressed(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var dataDescriptionLabel:UILabel!
    @IBOutlet weak var dataViewLabel:UITextView!
    @IBOutlet weak var dataViewLabel1:UITextView!
    @IBOutlet weak var dataViewLabel2:UITextView!
    @IBOutlet weak var dataViewLabel3:UITextView!
    @IBOutlet weak var dataViewLabel4:UITextView!
    @IBOutlet weak var dataViewLabel5:UITextView!

    @IBOutlet weak var dataLabel:UILabel!
    @IBOutlet weak var dataImageView:UIImageView!
    @IBOutlet weak var buttonEmergency: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            // Do any additional setup after loading the view.
            
            
        }
        
    }
    
  
    
}
