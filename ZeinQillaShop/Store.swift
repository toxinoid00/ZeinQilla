//
//  Store.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import Foundation

class Store {
    public var store_id : String?
    public var name : String?
    public var address : String?
    public var city : String?
    public var postal_code : String?
    public var phone : String?
    public var google_maps : String?
    public var email : String?
    public var latitude : String?
    public var longitude : String?
    public var trading_hours : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let store_list = Store.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Store Instances.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Store] {
        var models:[Store] = []
        for item in array
        {
            models.append(Store(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let store = Store(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Store Instance.
     */
    
    required public init?(dictionary: NSDictionary) {
        
        store_id = dictionary["store_id"] as? String
        name = dictionary["name"] as? String
        address = dictionary["address"] as? String
        city = dictionary["city"] as? String
        postal_code = dictionary["postal_code"] as? String
        phone = dictionary["phone"] as? String
        google_maps = dictionary["google_maps"] as? String
        email = dictionary["email"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        trading_hours = dictionary["trading_hours"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.store_id, forKey: "store_id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.postal_code, forKey: "postal_code")
        dictionary.setValue(self.phone, forKey: "phone")
        dictionary.setValue(self.google_maps, forKey: "google_maps")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.trading_hours, forKey: "trading_hours")
        
        return dictionary
    }
    

}
