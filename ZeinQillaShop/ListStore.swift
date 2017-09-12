//
//  Store.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import Foundation

class ListStore {
    public var city : String?
    public var store : Array<Store>!
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let listStore = ListStore.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of ListStore Instances.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ListStore] {
        var models:[ListStore] = []
        for item in array
        {
            models.append(ListStore(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let listStore = ListStore(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: ListStore Instance.
     */
    
    required public init?(dictionary: NSDictionary) {
        
        city = dictionary["city"] as? String
        if (dictionary["store"] != nil) { store = Store.modelsFromDictionaryArray(array: dictionary["store"] as! NSArray) }
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.city, forKey: "city")
        
        return dictionary
    }
    

}
