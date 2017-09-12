//
//  PromoCell.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit

class PromoCell : UICollectionViewCell {
    //MARK:Properties
    @IBOutlet weak var promoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK:Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = 4
    }
}
