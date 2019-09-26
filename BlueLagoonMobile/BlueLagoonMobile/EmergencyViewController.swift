//
//  EmergencyViewController.swift
//  BlueLagoonMobile
//
//  Created by Azoulay ben on 26/09/2019.
//  Copyright © 2019 Benazoulaydev. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
