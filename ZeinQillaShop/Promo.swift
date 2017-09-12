//
//  Promo.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import Foundation

class Promo {
    public var product_id : Int?
    public var title : String?
    public var price : String?
    public var new_price : String?
    public var image : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let promo_list = Promo.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Promo Instances.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Promo] {
        var models:[Promo] = []
        for item in array
        {
            models.append(Promo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let promo = Promo(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Promo Instance.
     */
    
    required public init?(dictionary: NSDictionary) {
        
        product_id = dictionary["product_id"] as? Int
        title = dictionary["title"] as? String
        price = dictionary["price"] as? String
        new_price = dictionary["new_price"] as? String
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
        dictionary.setValue(self.new_price, forKey: "new_price")
        dictionary.setValue(self.image, forKey: "image")
        
        return dictionary
    }
    

}
