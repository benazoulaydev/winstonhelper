//
//  MealDetailsViewController.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 03/10/2017.
//  Copyright © 2017 Benazoulaydev. All rights reserved.
//

import UIKit

class MealDetailsViewController: UIViewController {

    
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var lbMealName: UILabel!
    @IBOutlet weak var lbMealShortDescription: UILabel!
    
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var lbQty: UILabel!
    var meal: Meal?
    var restaurant: Restaurant?
    var qty = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeal()
    }
    func loadMeal() {
        if let price = meal?.price {
            lbTotal.text = "$\(price)"
        }
        
        
        lbMealName.text = meal?.name
        lbMealShortDescription.text = meal?.short_description
        
        if let imageUrl = meal?.image {
            Helpers.loadImage(imgMeal, "\(imageUrl)")
        }
    }
    @IBAction func addToTray(_ sender: Any) {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        image.image = UIImage(named: "medical-kit-1")
        image.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-100)
        self.view.addSubview(image)
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { image.center = CGPoint (x: self.view.frame.width - 40, y: self.view.frame.height - 24 )},
                       completion: {  _ in
                
                image.removeFromSuperview()
                        
                        let trayItem = TrayItem(meal: self.meal!, qty: self.qty)
                        
                        guard let trayRestaurant = Tray.currentTray.restaurant, let currentRestaurant = self.restaurant else {
                            // If those requirements are not met
                            
                            Tray.currentTray.restaurant = self.restaurant
                            Tray.currentTray.items.append(trayItem)
                            return
                        }
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        
                        // If ordering meal from the same restaurant
                        if trayRestaurant.id == currentRestaurant.id {
                            
                            let inTray = Tray.currentTray.items.index(where: { (item) -> Bool in
                                
                                return item.meal.id! == trayItem.meal.id!
                            })
                            
                            if let index = inTray {
                                
                                let alertView = UIAlertController(
                                    title: "Add more?",
                                    message: "Your tray already has this meal. Do you want to add more?",
                                    preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "Add more", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    Tray.currentTray.items[index].qty += self.qty
                                })
                                
                                alertView.addAction(okAction)
                                alertView.addAction(cancelAction)
                                
                                self.present(alertView, animated: true, completion: nil)
                            } else {
                                Tray.currentTray.items.append(trayItem)
                            }
                            
                        }
                        else {// If ordering meal from the another restaurant
                            
                            let alertView = UIAlertController(
                                title: "Start new tray?",
                                message: "You're ordering meal from another restaurant. Would you like to clear the current tray?",
                                preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "New Tray", style: .default, handler: { (action: UIAlertAction!) in
                                
                                Tray.currentTray.items = []
                                Tray.currentTray.items.append(trayItem)
                                Tray.currentTray.restaurant = self.restaurant
                            })
                            
                            alertView.addAction(okAction)
                            alertView.addAction(cancelAction)
                            
                            self.present(alertView, animated: true, completion: nil)
                        }
        })
    }
    @IBAction func removeQty(_ sender: Any) {
        if qty >= 2 {
            qty -= 1
            lbQty.text = String(qty)
            
            if let price = meal?.price {
                lbTotal.text = "$\(price * Float(qty))"
            }
        }
    }
    @IBAction func addQty(_ sender: Any) {
        if qty < 99 {
            qty += 1
            lbQty.text = String(qty)
            
            if let price = meal?.price {
                lbTotal.text = "$\(price * Float(qty))"
            }
        }
    }
}
