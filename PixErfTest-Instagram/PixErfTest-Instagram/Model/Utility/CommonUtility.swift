//
//  CommonUtility.swift
//  PixErfTest-Instagram
//
//  Created by Krishantha Sunil Premaretna on 9/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import UIKit

class CommonUtility{
    
    var servicesDictionay : NSMutableDictionary?
    
    //Initalize
    init(){
        self.readServicesPlistFile();
    }
    
    // This will read the Sevices plist file and loads the data into Services MutableDictionary
    func readServicesPlistFile(){
        if let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist") {
            self.servicesDictionay = NSMutableDictionary(contentsOfFile: path)
        }
    }
    
    func readVlueFromServicePlist(serviceName:String)-> NSDictionary {
        return (self.servicesDictionay?.objectForKey(serviceName))! as! NSDictionary;
    }

}
