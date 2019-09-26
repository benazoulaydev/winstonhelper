//
//  TrayViewController.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 03/10/2017.
//  Copyright © 2017 Benazoulaydev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TrayViewController: UIViewController {


    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tbvMeals: UITableView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var tbAddress: UITextField!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var bAddPayment: UIButton!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.tbAddress.delegate = self
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if Tray.currentTray.items.count == 0 {
            // Showing a message here
            self.viewAddress.isHidden = true
            self.tbAddress.isHidden = true

            let lbEmptyTray = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            lbEmptyTray.center = self.view.center
            lbEmptyTray.textAlignment = NSTextAlignment.center
            lbEmptyTray.text = "Your tray is empty. Please select meal."
            
            self.view.addSubview(lbEmptyTray)
            
        } else {
            // Display all of the UI controllers
            self.tbvMeals.isHidden = false
            self.viewTotal.isHidden = false
            self.viewAddress.isHidden = false
            self.viewMap.isHidden = false
            self.bAddPayment.isHidden = false
            
            loadMeals()
        }
        // Show current user's location
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.map.showsUserLocation = true
        }
    }
    
    func buttonAction(_ sender:UIButton!)
    {
        print("Button tapped")
    }
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
  
 
    
    func loadMeals() {
        self.tbvMeals.reloadData()
        self.lbTotal.text = "$\(Tray.currentTray.getTotal())"
    }
    
    @IBAction func addPayment(_ sender: Any) {
        if tbAddress.text == "" {
            // Showing alert that this field is required.
            
            let alertController = UIAlertController(title: "No Address", message: "Address is required", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                self.tbAddress.becomeFirstResponder()
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Tray.currentTray.address = tbAddress.text
            //self.performSegue(withIdentifier: "AddPayment", sender: self)
        }
    }
    
}

extension TrayViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude:
            location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01,
            longitudeDelta: 0.01))
        getAddressFromLatLon(pdblLatitude: location.coordinate.latitude.description, withLongitude: location.coordinate.longitude.description)
        self.map.setRegion(region, animated: true)
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    self.tbAddress.text = addressString
                    print(addressString)
                }
        })
        
    }
}
extension TrayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tray.currentTray.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrayItemCell", for: indexPath) as!
            TrayViewCell
        
        let tray = Tray.currentTray.items[indexPath.row]
        cell.lbQty.text = "\(tray.qty)"
        cell.lbMealName.text = tray.meal.name
        cell.lbSubTotal.text = "$\(tray.meal.price! * Float(tray.qty))"
        
        
        return cell
    }
}

extension TrayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          // Hide keyboard when user press done key
        tbAddress.resignFirstResponder()

        
        let address = textField.text
        let geocoder = CLGeocoder()
        Tray.currentTray.address = address
        
        geocoder.geocodeAddressString(address!) { (placemarks, error) in
            
            if (error != nil) {
                print("Error: ", error)
            }
            
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                let region = MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                
                self.map.setRegion(region, animated: true)
                self.locationManager.stopUpdatingLocation()
                
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                
                self.map.addAnnotation(dropPin)
            }
        }
        
        return true
    }
}

