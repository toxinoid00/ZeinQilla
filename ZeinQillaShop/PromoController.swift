//
//  PromoController.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit
import Alamofire
import FlowingMenu
import CoreData

class PromoController : UIViewController {
    //MARK:Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    //Promo
    var url : String = "https://api.myjson.com/bins/ugqop"
    var products : [Product] = []
    
    //Flowing menu
    let flowingMenuTransitionManager = FlowingMenuTransitionManager()
    var menu: UIViewController?
    let DismissSegueName = "DismissMenuSegue"
    let PresentSegueName = "PresentMenuSegue"
    
    //MARK:Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPromo(url: url)
        setupLayout()
        
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        flowingMenuTransitionManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCartColour()
    }
    
    //MARK:Actions
    func requestPromo(url: String) {
        Alamofire.request(url).responseJSON { response in
            guard let promo = response.result.value as? [NSDictionary] else {
                print("didn't get todo object as JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            for i in 0..<promo.count {
                self.products.append(Product(dictionary: promo[i])!)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func AddToCart(_ sender: UIButton) {
        let index : Int = sender.tag
        if products.count != 0 {
            if products[index].product_id != "" {
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                let entity =
                    NSEntityDescription.entity(forEntityName: "Cart",
                                               in: managedContext)!
                if isProductExist(product: products[index]) {
                    print("Product exists")
                    showDialogIfProductAlreadyInCart()
                } else {
                    do {
                        let product = NSManagedObject(entity: entity,
                                                      insertInto: managedContext)
                        product.setValue(self.products[index].product_id, forKey: "product_id")
                        product.setValue(1, forKey: "quantity")
                        try managedContext.save()
                        showDialogAddedToCart()
                        setCartColour()
                        print("Added to CART")
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        }
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
    
    func isProductExist(product: Product) -> Bool {
        var status:Bool = false
        let productList = fetchCoreData()
        for i in 0..<productList.count{
            if productList[i].value(forKey: "product_id") as? String == product.product_id {
                status = true
            }
        }
        return status
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
    }
    
    func showDialogIfProductAlreadyInCart() {
        let refreshAlert = UIAlertController(title: "Information", message: "Product already in cart", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
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
    
    func showDialogAddedToCart() {
        let refreshAlert = UIAlertController(title: "Information", message: "Added to cart", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue) {
        
    }
}

extension PromoController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PromoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "promoCell", for: indexPath) as! PromoCell
        let item = products[indexPath.row]
        let url = URL(string: (item.image)!)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            cell.promoImageView.image = UIImage(data:data!)
        } else {
            cell.promoImageView.image = #imageLiteral(resourceName: "default image")
        }
        cell.titleLabel.text = item.title
        cell.priceLabel.text = item.price
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(AddToCart(_:)), for: .touchUpInside)
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension PromoController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailController
        vc.url = "https://api.myjson.com/bins/vf195"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PromoController : FlowingMenuDelegate {
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: PresentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegue(withIdentifier: DismissSegueName , sender: self)
    }
}
