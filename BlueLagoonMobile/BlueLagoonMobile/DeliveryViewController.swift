//
//  DeliveryViewController.swift
//  BlueLagoonMobile
//
//  Created by Ben Azoulay on 09/05/2018.
//  Copyright © 2018 Benazoulaydev. All rights reserved.
//

import UIKit
import MapKit

class DeliveryViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var lbCustomerName: UILabel!
    @IBOutlet weak var lbCustomerAddress: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var bComplete: UIButton!
    
    var orderId: Int?
    
    var destination: MKPlacemark?
    var source: MKPlacemark?
    
    var locationManager: CLLocationManager!
    var driverPin: MKPointAnnotation!
    var lastLocation: CLLocationCoordinate2D!
    let activityIndicator = UIActivityIndicatorView()

    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbCustomerName.text = ""
        lbCustomerAddress.text = ""
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Show current Driver's location
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.map.showsUserLocation = false
        }
        
        // Running the updating location process
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateLocation(_:)),
            userInfo: nil, repeats: true)
    }
    
    @objc func updateLocation(_ sender: AnyObject) {
        APIManager.shared.updateLocation(location: self.lastLocation) { (json) in
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.map.isHidden = true
        self.viewInfo.isHidden = true
        self.bComplete.isHidden = true
        loadData()
    }
    
    func loadData() {
         Helpers.showActivityIndicator(activityIndicator, view)
        APIManager.shared.getCurrentDriverOrder { (json) in
            
            print(json)
            
            self.map.isHidden = false
            self.viewInfo.isHidden = false
            self.bComplete.isHidden = false
            
            let order = json["order"]
            
            if let id = order["id"].int, order["status"] == "On the way" {
                
                self.orderId = id
                
                let from = order["address"].string!
                let to = order["restaurant"]["address"].string!
                
                let customerName = order["customer"]["name"].string!
                let customerAvatar = order["customer"]["avatar"].string!
                
                self.lbCustomerName.text = customerName
                self.lbCustomerAddress.text = from
                
                self.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: customerAvatar)!))
                self.imgCustomerAvatar.layer.cornerRadius = 50/2
                self.imgCustomerAvatar.clipsToBounds = true
                
                self.getLocation(from, "Customer", { (sou) in
                    self.source = sou
                    
                    self.getLocation(to, "Restaurant", { (des) in
                        self.destination = des
                    })
                  

                })
                
            } else {
                
                self.map.isHidden = true
                self.viewInfo.isHidden = true
                self.bComplete.isHidden = true
                
                // Showing a message here
                
                let lbMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
                lbMessage.center = self.view.center
                lbMessage.textAlignment = NSTextAlignment.center
                lbMessage.text = "You don't have any orders for delivery."
                
                self.view.addSubview(lbMessage)
            }
            Helpers.hideActivityIndicator(self.activityIndicator)
        }
    }
    

    @IBAction func completeOrder(_ sender: Any) {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            APIManager.shared.compeleteOrder(orderId: self.orderId!, completionHandler: { (json) in
                
                if json != nil {
                    // Stop updating driver location
                    self.timer.invalidate()
                    self.locationManager.stopUpdatingLocation()
                    
                    // Redirect driver to the Ready Orders View
                    self.performSegue(withIdentifier: "ViewOrders", sender: self)
                }
            })
        }
        
        let alertView = UIAlertController(title: "Complete Order", message: "Are you sure?", preferredStyle: .alert)
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
}

extension DeliveryViewController: MKMapViewDelegate {
    
    // #1 - Delegate method of MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    // #2 - Convert an address string to a location on the map
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (MKPlacemark) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            if (error != nil) {
                print("Error: ", error)
            }
            
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                
                self.map.addAnnotation(dropPin)
                completionHandler(MKPlacemark.init(placemark: placemark))
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "MyPin"
        
        var annotationView: MKAnnotationView?
        if let dequeueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            
            annotationView = dequeueAnnotationView
            annotationView?.annotation = annotation
        } else {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
       self.driverPin.title = "Driver"
        
        if let annotationView = annotationView, let name = annotation.title! {
            switch name {
            case "Driver":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            case "Restaurant":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_restaurant")
            case "Customer":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_customer")
            default:
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            }
        }
        
        return annotationView
    }
}

extension DeliveryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
      
        let location = locations.last! as CLLocation
        self.lastLocation = location.coordinate
        
        // Create pin annotation for Driver
        if driverPin != nil {
            driverPin.coordinate = self.lastLocation
        } else {
            driverPin = MKPointAnnotation()
            driverPin.coordinate = self.lastLocation
            
            self.map.addAnnotation(driverPin)
        }
        
        // Reset zoom rect to cover 3 locations
        var zoomRect = MKMapRect.null
        for annotation in self.map.annotations {
            let annotationPoint = MKMapPoint.init(annotation.coordinate)
            let pointRect = MKMapRect.init(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = zoomRect.insetBy(dx: insetWidth, dy: insetHeight)
        
        self.map.setVisibleMapRect(insetRect, animated: true)
    }
}

