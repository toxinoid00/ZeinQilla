//
//  ProductDetailController.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ProductDetailController : UIViewController {
    //MARK:Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var productDetail : ProductDetail?
    var url:String = ""
    var product: [NSManagedObject] = []
    var cart : UIBarButtonItem?
    var index:Int = 0
    
    //MARK:Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        requestProductDetail(url: url)
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCartColour()
    }
    
    //MARK:Actions
    func requestProductDetail(url: String) {
        Alamofire.request(url).responseJSON { response in
            guard let product = response.result.value as? NSDictionary else {
                print("didn't get todo object as JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            self.productDetail = ProductDetail(dictionary: product)
            self.setupData()
        }
    }
    
    @IBAction func addToCartButtonClick(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "Cart",
                                       in: managedContext)!
        if isProductExist(product: (productDetail)!) {
            print("Product exists")
            showDialogIfProductAlreadyInCart()
        } else {
            do {
                let product = NSManagedObject(entity: entity,
                                              insertInto: managedContext)
                product.setValue(self.productDetail?.product_id, forKey: "product_id")
                product.setValue(1, forKey: "quantity")
                try managedContext.save()
                self.product.append(product)
                showDialogAddedToCart()
                setCartColour()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func isProductExist(product: ProductDetail) -> Bool {
        var status:Bool = false
        let productList = fetchCoreData()
        for i in 0..<productList.count{
            if productList[i].value(forKey: "product_id") as? String == product.product_id {
                status = true
            }
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
    
    func setCartColour() {
        if !isProductEmpty() {
            cart?.image = #imageLiteral(resourceName: "cart_filled")
        } else {
            cart?.image = #imageLiteral(resourceName: "cart")
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
    
    func showCart() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Cart") as! CartController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:Utilities
    func showDialogIfProductAlreadyInCart() {
        let refreshAlert = UIAlertController(title: "Information", message: "Product already in cart", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func setupLayout() {
        cart = UIBarButtonItem(image: #imageLiteral(resourceName: "cart"), style: .plain, target: self, action: #selector(showCart))
        navigationItem.rightBarButtonItems = [cart!]
    }
    
    func setupData() {
        self.titleLabel.text = productDetail?.title
        self.descriptionTextView.text = productDetail?.description
        self.priceLabel.text = productDetail?.price
        let url = URL(string: (productDetail?.image)!)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            self.imageView.image = UIImage(data: data!)
        } else {
            self.imageView.image = #imageLiteral(resourceName: "default image")
        }
    }
    
    func showDialogAddedToCart() {
        let refreshAlert = UIAlertController(title: "Information", message: "Added to cart", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}
