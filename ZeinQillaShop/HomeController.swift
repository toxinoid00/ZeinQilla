//
//  HomeController.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import FlowingMenu
import CoreData

class HomeController : UIViewController {
    //MARK:Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slider: ImageSlideshow!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    //Slider
    let urlSlider : String = "https://api.myjson.com/bins/1dbyuh"
    var banner : [Banner] = []
    var images_slider : [InputSource] = []
    
    //Promo
    let urlPromo : String = "https://api.myjson.com/bins/tvb2x"
    var promos1 : [Promo] = []
    var promos2 : [Promo] = []
    var promos3 : [Promo] = []
    
    //Flowing menu
    let flowingMenuTransitionManager = FlowingMenuTransitionManager()
    var menu: UIViewController?
    let DismissSegueName = "DismissMenuSegue"
    let PresentSegueName = "PresentMenuSegue"
    
    //MARK:Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        requestSlider(url: urlSlider)
        requestPromo(url: urlPromo)
        
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        flowingMenuTransitionManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCartColour()
    }
    
    //MARK:Actions
    func requestSlider(url: String){
        Alamofire.request(url).responseJSON { response in
            guard let slider = response.result.value as? [NSDictionary] else {
                print("didn't get todo object as JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            for i in 0..<slider.count{
                self.banner.append(Banner(dictionary: slider[i])!)
            }
            
            for i in 0..<self.banner.count{
                let originalString = self.banner[i].image!
                let encoded = originalString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                self.images_slider.append(AlamofireSource(urlString: encoded!)!)
            }
            self.setupSlider()
        }
    }
    
    func sliderClick(){
        let item = banner[slider.currentPage]
        if item.banner_id != nil{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailController
            vc.url = "https://api.myjson.com/bins/vf195"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            //print("Doesn't have detail")
            let alert = UIAlertController(title: "Information", message: "Doesn't have detail", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func requestPromo(url: String){
        Alamofire.request(url).responseJSON { response in
            guard let product = response.result.value as? [NSDictionary] else {
                print("didn't get todo object as JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            for i in 0..<product.count{
                self.promos1.append(Promo(dictionary: product[i])!)
                self.promos2.append(Promo(dictionary: product[i])!)
                self.promos3.append(Promo(dictionary: product[i])!)
            }
            
            self.tableView.reloadData()
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
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK:Utilities
    func setupLayout() {
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "FF2D55")
        self.tabBarController?.tabBar.tintColor = UIColor(hex: "FF2D55")
        
        //Add gesture recognizer for slider
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderClick))
        slider.addGestureRecognizer(gestureRecognizer)
    }
    
    //function for setting slider in home screen
    func setupSlider() {
        slider.slideshowInterval = 2.5
        slider.pageControlPosition = PageControlPosition.insideScrollView
        slider.pageControl.currentPageIndicatorTintColor = UIColor(hex: "FF2D55")
        slider.pageControl.pageIndicatorTintColor = UIColor.white
        slider.contentScaleMode = UIViewContentMode.scaleToFill
        slider.setImageInputs(self.images_slider)
    }
    
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue) {
        
    }
}

extension HomeController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell : HomeHeaderCell = tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell") as! HomeHeaderCell
        switch (section) {
        case 0:
            headerCell.titleLabel.text = "Favorite Products";
        case 1:
            headerCell.titleLabel.text = "Best Sellers";
        case 2:
            headerCell.titleLabel.text = "Best Selling On Indonesia";
        default:
            headerCell.titleLabel.text = "Other";
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeCell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomeCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView.tag) {
        case 0:
            return promos1.count
        case 1:
            return promos2.count
        default:
            return promos3.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCell", for: indexPath) as! HomeCollectionCell
        switch (collectionView.tag) {
        case 0:
            let item = promos1[indexPath.row]
            let url = URL(string: (item.image)!)
            let data = try? Data(contentsOf: url!)
            if data != nil {
                cell.imageView.image = UIImage(data: data!)
            }
            else {
                cell.imageView.image = #imageLiteral(resourceName: "default image")
            }
            
            cell.titleLabel.text = item.title
            cell.priceDiscountLabel.text = item.new_price
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item.price!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.priceLabel.attributedText = attributeString
            
            cell.backgroundColor = UIColor.clear
        case 1:
            let item = promos2[indexPath.row]
            let url = URL(string: (item.image)!)
            let data = try? Data(contentsOf: url!)
            if data != nil {
                cell.imageView.image = UIImage(data: data!)
            }
            else {
                cell.imageView.image = #imageLiteral(resourceName: "default image")
            }
            
            cell.titleLabel.text = item.title
            cell.priceDiscountLabel.text = item.new_price
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item.price!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.priceLabel.attributedText = attributeString

        case 2:
            let item = promos3[indexPath.row]
            let url = URL(string: (item.image)!)
            let data = try? Data(contentsOf: url!)
            if data != nil {
                cell.imageView.image = UIImage(data: data!)
            }
            else {
                cell.imageView.image = #imageLiteral(resourceName: "default image")
            }
            
            cell.titleLabel.text = item.title
            cell.priceDiscountLabel.text = item.new_price
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item.price!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.priceLabel.attributedText = attributeString

        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailController
        vc.url = "https://api.myjson.com/bins/vf195"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeController : FlowingMenuDelegate {
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: PresentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegue(withIdentifier: DismissSegueName , sender: self)
    }
}
