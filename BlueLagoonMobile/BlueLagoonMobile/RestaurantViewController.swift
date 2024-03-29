//
//  RestaurantViewController.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 26/09/2017.
//  Copyright © 2017 Benazoulaydev. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var searchRestaurant: UISearchBar!
    @IBOutlet weak var tbvRestaurant: UITableView!
    
    var restaurants = [Restaurant]()
    var filteredRestaurants = [Restaurant]()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if self.revealViewController() != nil {
                menuBarButton.target = self.revealViewController()
                menuBarButton.action = #selector
                        (SWRevealViewController.revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
            
  
    }
        
        loadRestaurants()
    }
    

    
    func loadRestaurants() {
        
       Helpers.showActivityIndicator(activityIndicator, view)
        
        APIManager.shared.getRestaurants { (json) in
            
            if json != nil {
                
                self.restaurants = []
                
                if let listRes = json["restaurants"].array {
                    for item in listRes {
                        let restaurant = Restaurant(json: item)
                        self.restaurants.append(restaurant)
                    }
                    
                    self.tbvRestaurant.reloadData()
                    Helpers.hideActivityIndicator(self.activityIndicator)
        
                }
            }
        }
        
    }

  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MealList" {
            
            let controller = segue.destination as! MealListTableViewController
            controller.restaurant = restaurants[(tbvRestaurant.indexPathForSelectedRow?.row)!]
            searchRestaurant.endEditing(true)
        }
    }
    
    // Hide keyboard when user scroll outside keyboard
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchRestaurant.endEditing(true)
    }
    // Hide keyboard when user press done key
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchRestaurant.endEditing(true)
    }
    
}

extension RestaurantViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRestaurants = self.restaurants.filter({ (res: Restaurant) -> Bool in
            return res.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        self.tbvRestaurant.reloadData()
    }
}
extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchRestaurant.text != "" {
            return self.filteredRestaurants.count
        }
        return self.restaurants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantViewCell
        let restaurant: Restaurant
        if searchRestaurant.text != "" {
            restaurant = filteredRestaurants[indexPath.row]
            } else {
                 restaurant = restaurants[indexPath.row]
            }
      
        
        cell.lbRestaurantName.text = restaurant.name!
        cell.lbRestaurantAddress.text = restaurant.address!
        
        if let logoName = restaurant.logo {
           Helpers.loadImage( cell.imgRestaurantLogo,  "\(logoName)")
        }
        
        return cell
    }
}

