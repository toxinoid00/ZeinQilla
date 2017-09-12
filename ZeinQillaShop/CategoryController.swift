//
//  CategoryController.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/12/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit

class CategoryController : UIViewController {
    //MARK:Properties
    @IBOutlet weak var tableView: UITableView!
    
    var dummy_category : [String] = ["Indo Perfume","Shoes","Bag","World Perfume"]
}

extension CategoryController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy_category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CategoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
        cell.categoryNameLabel.text = dummy_category[indexPath.row]
        return cell
    }
}

extension CategoryController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let refreshAlert = UIAlertController(title: "Open", message: "Screen \(dummy_category[indexPath.row])", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}
