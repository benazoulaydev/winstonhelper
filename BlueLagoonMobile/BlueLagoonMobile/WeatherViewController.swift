//
//  WeatherViewController.swift
//  BlueLagoonMobile
//
//  Created by Azoulay ben on 25/09/2019.
//  Copyright © 2019 Benazoulaydev. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tbvWeather: UITableView!
    
    var arrayOfItems:[WeatherItem] = [WeatherItem]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvWeather.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

        arrayOfItems = APIClient().getData()
        tbvWeather.reloadData()
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector
                (SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            // Do any additional setup after loading the view.
            
            
        }
    }
    
    
   

    
    

    
}








extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tbvWeather.dequeueReusableCell(withIdentifier: "WeatherViewCellIdentifier") as? WeatherViewCell {
            cell.configureCell(item: arrayOfItems[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       
        
        
        

        
        
        tbvWeather.deselectRow(at: indexPath, animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      
        

        
        if let dataPresentingViewController = storyBoard.instantiateViewController(withIdentifier: "DataPresentingViewControllerIdentifier") as? DataPresentingViewController {
            self.present(dataPresentingViewController, animated: true, completion: nil)


            dataPresentingViewController.dataLabel.text = arrayOfItems[indexPath.row].text
            dataPresentingViewController.dataImageView.image = arrayOfItems[indexPath.row].image
            dataPresentingViewController.dataDescriptionLabel.text = arrayOfItems[indexPath.row].textDescription
            dataPresentingViewController.dataViewLabel.text = arrayOfItems[indexPath.row].textView
            dataPresentingViewController.dataViewLabel1.text = arrayOfItems[indexPath.row].textView1
            dataPresentingViewController.dataViewLabel2.text = arrayOfItems[indexPath.row].textView2
            dataPresentingViewController.dataViewLabel3.text = arrayOfItems[indexPath.row].textView3
            dataPresentingViewController.dataViewLabel4.text = arrayOfItems[indexPath.row].textView4
            dataPresentingViewController.dataViewLabel5.text = arrayOfItems[indexPath.row].textView5

        }
    }
    
    
    
    
}
