//
//  CartController.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/12/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class CartController : UIViewController {
    //MARK:Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    //Cart
    var price : Double = 0
    var index : Int = 0
    var productDetail : [ProductDetail] = []
    var productList : [NSManagedObject] = []
    var url : [String] = []
    var count: Int = 0
    
    //MARK:Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchCoreData()
    }
    
    //MARK:Actions
    @IBAction func checkoutButtonClick(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Checkout Next Version", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        if productList.count != 0 {
            let refreshAlert = UIAlertController(title: "Confirmation", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.deleteAllCoreData()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Cancel delete")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        } else {
            let refreshAlert = UIAlertController(title: "Information", message: "You dont have any product on your cart", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func updateQuantity(id:String, quantity:Int, index:Int) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Cart")
        
        do {
            productList = try managedContext.fetch(fetchRequest)
            let product = productList[index]
            product.setValue(id, forKey: "product_id")
            product.setValue(quantity, forKey: "quantity")
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func requestProduct() {
        Alamofire.request(self.url[index]).responseJSON { response in
            guard let product = response.result.value as? NSDictionary else {
                print("didn't get todo object as JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            self.productDetail.append(ProductDetail(dictionary: product)!)
            if self.productDetail.count == self.productList.count {
                for i in 0..<self.productDetail.count{
                    if self.productDetail[i].price_2 != nil {
                        let a = Double(self.productDetail[i].price_2!)
                        let qtty = self.productList[i].value(forKey: "quantity") as! Int
                        self.price = self.price + (a * Double(qtty))
                    }
                }
            }
            
            self.index = self.index+1
            
            if self.index < self.url.count {
                self.requestProduct()
            }
            else {
                self.totalLabel.text = "Total: $ " + String.localizedStringWithFormat("%.0f", self.price)
                self.tableView.reloadData()
            }
        }
    }
    
    func deleteAllCoreData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            print ("There was an error")
        }
        fetchCoreData()
    }
    
    func fetchCoreData() {
        self.price = 0
        self.index = 0
        self.productDetail.removeAll()
        self.url.removeAll()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Cart")
        
        do {
            productList = try managedContext.fetch(fetchRequest)
            
            /*
             
             i have example for dynamic products
             self.url.append("your_end_point\(productList[i].value(forKey: "product_id") as! String)")
             or
             self.url.append("http://husainfdl.com/index.php?route=mobile/productdetail&product_id=\(productList[i].value(forKey: "product_id") as! String)")
             
             */
            
            if productList.count != 0 {
                for _ in 0..<productList.count{
                    //this is url dummy
                    self.url.append("https://api.myjson.com/bins/vf195")
                }
                requestProduct()
            }
            else {
                self.totalLabel.text = ""
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    //MARK:Utilities
    func setupLayout() {
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "FF2D55")
        self.checkoutButton.tintColor = UIColor(hex: "FF2D55")
    }
}

extension CartController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartCell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartCell
        let item = productList[indexPath.row]
        count = productList.count
        cell.quantity = item.value(forKey: "quantity") as! Int
        if productList.count == productDetail.count {
            cell.cartTitleLabel.text = productDetail[indexPath.row].title
            cell.cartPriceLabel.text = productDetail[indexPath.row].price
            
            var a = cell.quantity
            let url = URL(string: productDetail[indexPath.row].image!)
            let data = try? Data(contentsOf: url!)
            if data != nil {
                cell.cartImageView.image = UIImage(data: data!)
            }
            else {
                cell.cartImageView.image = #imageLiteral(resourceName: "default image")
            }
            
            DispatchQueue.main.async {
                cell.cartQuantitiyNumberLabel.text = String(cell.quantity)
                self.updateQuantity(id: item.value(forKey: "product_id") as! String, quantity: Int(cell.cartQuantitiyNumberLabel.text!)!, index: indexPath.row)
                
                if a != cell.quantity {
                    self.fetchCoreData()
                    a = cell.quantity
                }
                self.tableView.reloadData()
            }
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
}

extension CartController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            managedContext.delete(productList[indexPath.row])
            productList.remove(at: indexPath.row)
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            fetchCoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

