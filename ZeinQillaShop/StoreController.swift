//
//  StoreController.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import CoreLocation
import FlowingMenu
import CoreData

class StoreController : UIViewController {
    //MARK:Properties
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    //Store
    let urlStore : String = "https://api.myjson.com/bins/129ipl"
    public var locator : [ListStore] = []
    public var store : [Store] = []
    
    //Dropdown filter properties
    var index_dropdown: Bool = false
    var dropDown = DropDown()
    
    //Location properties
    var locationManager:CLLocationManager!
    
    //Flowing menu
    let flowingMenuTransitionManager = FlowingMenuTransitionManager()
    var menu: UIViewController?
    let DismissSegueName = "DismissMenuSegue"
    let PresentSegueName = "PresentMenuSegue"
    
    //MARK:Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        requestStore(url: urlStore)
        determineMyCurrentLocation()
        
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        flowingMenuTransitionManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCartColour()
    }
    
    //MARK:Actions
    @IBAction func filterButtonClick(_ sender: Any) {
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.filterStore(index: index)
        }
        dropDown.show()
    }
    
    func requestStore(url: String) {
        Alamofire.request(url).responseJSON { response in
            guard let product = response.result.value as? [NSDictionary] else {
                print("didn't get todo object as JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            for i in 0..<product.count {
                self.locator.append(ListStore(dictionary: product[i])!)
                self.store.append(contentsOf: self.locator[i].store)
            }
            
            if self.index_dropdown == false {
                self.setupDropDown()
            }
            
            self.tableView.reloadData()
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    //Filter Store
    func filterStore(index: Int) {
        self.store.removeAll()
        if index == 0 {
            for i in 0..<self.locator.count{
                self.store.append(contentsOf: self.locator[i].store)
            }
        } else {
            self.store.append(contentsOf: self.locator[index-1].store)
        }
        self.tableView.reloadData()
    }
    
    func getDistance(loc1:CLLocation,loc2:CLLocation) -> String{
        let coordinate₀ = loc1
        let coordinate₁ = loc2
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        let distanceInInt:Int = Int(distanceInMeters/1000)
        return String("\(distanceInInt) KM from your location")
    }

    //Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowCart":
            guard let cartController = segue.destination as? CartController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            cartController.hidesBottomBarWhenPushed = true
            
        case PresentSegueName:
            if let vc = segue.destination as? CategoryController {
                vc.transitioningDelegate = flowingMenuTransitionManager
                flowingMenuTransitionManager.setInteractiveDismissView(vc.view)
                menu = vc
            }
            
        case "StoreDetailController":
            guard let storeDetailController = segue.destination as? StoreDetailController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            storeDetailController.hidesBottomBarWhenPushed = true
            
            guard let selectedStoreCell = sender as? StoreCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedStoreCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedStore = store[indexPath.row]
            storeDetailController.store = selectedStore
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    func setCartColour() {
        if !isProductEmpty() {
            cartButton.image = #imageLiteral(resourceName: "cart_filled")
        } else {
            cartButton.image = #imageLiteral(resourceName: "cart")
        }
    }
    
    func isProductEmpty() -> Bool {
        var status : Bool = true
        let product = fetchCoreData()
        if product.count > 0 {
            status = false
        }
        return status
    }
    
    func fetchCoreData() -> [NSManagedObject] {
        var productList: [NSManagedObject] = []
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return productList
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Cart")
        
        do {
            productList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return productList
    }
    
    //MARK:Utilities
    func setupLayout() {
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "FF2D55")
        self.tabBarController?.tabBar.tintColor = UIColor(hex: "FF2D55")
    }
    
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue) {
        
    }
    
    func setupDropDown() {
        dropDown.dataSource.append("All City")
        for i in 0..<locator.count {
            dropDown.dataSource.append(self.locator[i].city!)
        }
        //Custom dropdown
        dropDown.anchorView = filterButton
        dropDown.width = 200
        dropDown.shadowRadius = 4
        dropDown.shadowColor = UIColor.black
        dropDown.shadowOpacity = 0.2
        dropDown.shadowRadius = 4
        dropDown.shadowOffset = CGSize(width: 0.0, height: 8.0)
        self.index_dropdown = true
    }
}

extension StoreController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StoreCell = tableView.dequeueReusableCell(withIdentifier: "storeCell") as! StoreCell
        let item = store[indexPath.row]
        
        //display data
        cell.nameLabel.text = item.name
        cell.addressLabel.text = "Address: " + item.address!
        cell.cityLabel.text = "City: " + item.city!
        cell.emailLabel.text = "E-mail: " + item.email!
        cell.phoneLabel.text = "Phone: " + item.phone!
        cell.tradingHoursLabel.text = "Open: " + item.trading_hours!

        if CLLocationManager.locationServicesEnabled() {
            cell.distanceLabel.text = getDistance(loc1: CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.latitude)!), loc2: CLLocation(latitude: Double(item.latitude!)!, longitude: Double(item.longitude!)!) )
        }
        else {
            cell.distanceLabel.text = "~"
        }
    
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }
}

extension StoreController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        //print("user latitude = \(userLocation.coordinate.latitude)")
        //print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension StoreController : FlowingMenuDelegate {
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: PresentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegue(withIdentifier: DismissSegueName , sender: self)
    }
}
