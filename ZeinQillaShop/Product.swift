//
//  Promo.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import Foundation

class Product {
    public var product_id : String?
    public var title : String?
    public var price : String?
    public var image : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let product_list = Product.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Product Instances.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Product] {
        var models:[Product] = []
        for item in array
        {
            models.append(Product(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let product = Product(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Product Instance.
     */
    
    required public init?(dictionary: NSDictionary) {
        
        product_id = dictionary["product_id"] as? String
        title = dictionary["title"] as? String
        price = dictionary["price"] as? String
        image = dictionary["image"] as? String
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
        dictionary.setValue(self.image, forKey: "image")
        
        return dictionary
    }
}
