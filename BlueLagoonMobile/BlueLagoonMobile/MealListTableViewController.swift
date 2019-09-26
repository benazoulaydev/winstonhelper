//
//  MealListTableViewController.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 27/09/2017.
//  Copyright © 2017 Benazoulaydev. All rights reserved.
//

import UIKit

class MealListTableViewController: UITableViewController {

         var restaurant: Restaurant?
         var meals = [Meal]()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurantName
        }
        
        loadMeals()
        
    }
    
    func loadMeals() {
        
   
        Helpers.showActivityIndicator(activityIndicator, view)
        
        if let restaurantId = restaurant?.id {
            
            APIManager.shared.getMeals(restaurantId: restaurantId, completionHandler: { (json) in
                if json != nil {
                    self.meals = []
                    
                    if let tempMeals = json["meals"].array {
                        
                        for item in tempMeals {
                            let meal = Meal(json: item)
                            self.meals.append(meal)
                        }
                        
                        self.tableView.reloadData()
                        Helpers.hideActivityIndicator(self.activityIndicator)
                    }
                }
     
            })
        }
    }
    func loadImage(imageView: UIImageView, urlString: String) {
        let imgURL: URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
            
            guard let data = data, error == nil else { return}
            
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
            }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MealDetails" {
            let controller = segue.destination as! MealDetailsViewController
            controller.meal = meals[(tableView.indexPathForSelectedRow?.row)!]
            controller.restaurant = restaurant
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealViewCell
        
        let meal = meals[indexPath.row]
        cell.lbMealName.text = meal.name
        cell.lbMealShortDescription.text = meal.short_description
        
        if let price = meal.price {
            if price == 0 {
                cell.lbMealPrice.text = "Need Help"
            } else {
                cell.lbMealPrice.text = "$\(price)"
            }
        }
        
        if let image = meal.image {
            Helpers.loadImage( cell.imgMealImage,  "\(image)")
        }
        return cell
    }

}
