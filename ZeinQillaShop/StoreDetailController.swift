//
//  StoreDetailController.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit
import MapKit

class StoreDetailController : UIViewController {
    //MARK:Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tradingHoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var store: Store?
    
    //Locator
    let annotation = MKPointAnnotation()
    let regionRadius: CLLocationDistance = 300
    
    //MARK:Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        if let store = store {
            nameLabel.text = store.name
            cityLabel.text = "City: " + store.city!
            addressLabel.text = "Address: " + store.address!
            phoneLabel.text = "Phone: " + store.phone!
            emailLabel.text = "E-mail: " + store.email!
            tradingHoursLabel.text = "Open: " + store.trading_hours!
        }
        let initialLocation = CLLocation(latitude: Double((store?.latitude)!)!, longitude: Double((store?.longitude)!)!)
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double((store?.latitude)!)!, longitude: Double((store?.longitude)!)!)
        mapView.addAnnotation(annotation)
        centerMapOnLocation(location: initialLocation)
    }
    
    //MARK:Actions
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /* Problem
     WARNING: Output of vertex shader 'v_gradient' not read by fragment shader
     https://stackoverflow.com/questions/39608231/warning-output-of-vertex-shader-v-gradient-not-read-by-fragment-shader
     */
}
