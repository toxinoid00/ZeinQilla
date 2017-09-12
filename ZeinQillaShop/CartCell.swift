//
//  CartCell.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/12/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit

class CartCell : UITableViewCell {
    //MARK:Properties
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var cartTitleLabel: UILabel!
    @IBOutlet weak var cartPriceLabel: UILabel!
    @IBOutlet weak var cartQuantitiyNumberLabel: UILabel!
    
    var quantity : Int = 1
    
    //MARK:Actions
    @IBAction func decreaseQuantity(_ sender: Any) {
        if(quantity==1) {
            print("Tidak bisa mengurangi lagi")
        } else {
            quantity -= 1
            self.cartQuantitiyNumberLabel.text = String(quantity)
        }
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        quantity += 1
        self.cartQuantitiyNumberLabel.text = String(quantity)
    }
}
