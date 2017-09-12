//
//  Banner.swift
//  ZeinQillaShop
//
//  Created by Muhammad Husain Fadhlullah on 9/11/17.
//  Copyright © 2017 Muhammad Husain Fadhlullah. All rights reserved.
//

import Foundation

class Banner {
    public var banner_id : String?
    public var title : String?
    public var image : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let banner_list = Banner.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Banner Instances.
     */
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Banner] {
        var models:[Banner] = []
        for item in array
        {
            models.append(Banner(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let banner = Banner(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Banner Instance.
     */
    
    required public init?(dictionary: NSDictionary) {
        
        banner_id = dictionary["banner_id"] as? String
        title = dictionary["title"] as? String
        image = dictionary["image"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.banner_id, forKey: "banner_id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.image, forKey: "image")
        
        return dictionary
    }
    

}
