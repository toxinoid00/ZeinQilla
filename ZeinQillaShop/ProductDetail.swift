//
//  ProductDetail.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import UIKit

class ProductDetail {
    public var product_id : String?
    public var title : String?
    public var price : String?
    public var price_2 : Int?
    public var image : String?
    public var description : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let productDetail = ProductDetail.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of ProductDetail Instances.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductDetail] {
        var models:[ProductDetail] = []
        for item in array
        {
            models.append(ProductDetail(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let productDetail = ProductDetail(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: ProductDetail Instance.
     */
    
    required public init?(dictionary: NSDictionary) {
        
        product_id = dictionary["product_id"] as? String
        title = dictionary["title"] as? String
        price = dictionary["price"] as? String
        price_2 = dictionary["price_2"] as? Int
        image = dictionary["image"] as? String
        description = dictionary["description"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.product_id, forKey: "product_id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.price, forKey: "price")
        dictionary.setValue(self.price_2, forKey: "price_2")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.description, forKey: "description")
        
        return dictionary
    }
}
