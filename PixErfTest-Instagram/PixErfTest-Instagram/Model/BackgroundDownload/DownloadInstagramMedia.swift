//
//  DownloadInstagramMedia.swift
//  PixErfTest-Instagram
//
//  Created by Krishantha Sunil Premaretna on 11/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class DownloadInstagramMedia: NSObject {
    let manageOBC : NSManagedObjectContext
    let userImageArray : NSMutableArray
    
    override init() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.manageOBC = appdelegate.managedObjectContext
        self.userImageArray = NSMutableArray()
    }
    
    func downloadUserMedias(urlToDownload:String , completion : (result : String) -> Void){
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            Alamofire.request(.GET, urlToDownload, parameters: nil)
                .responseJSON { response in
                    
                    let jsonResponse = response.result.value as! NSDictionary
                    let pagination = jsonResponse.objectForKey("pagination")
                    let data = jsonResponse.objectForKey("data") as! NSArray
                    
                    data.forEach{ mediaObject in
                        
                        let imagesDictionary = mediaObject.objectForKey("images") as! NSDictionary
                        let thumbnailDictionary = imagesDictionary.objectForKey("thumbnail") as! NSDictionary
                        let lowResolution = imagesDictionary.objectForKey("low_resolution") as! NSDictionary
                        let standardresolution = imagesDictionary.objectForKey("standard_resolution") as! NSDictionary
                        
                        let userImage = NSEntityDescription.insertNewObjectForEntityForName("UserImage", inManagedObjectContext: self.manageOBC) as! UserImage
                        
                        userImage.thumbnail = thumbnailDictionary.objectForKey("url") as? String
                        userImage.lowresolution = lowResolution.objectForKey("url") as? String
                        userImage.standard = standardresolution.objectForKey("url") as? String
                        userImage.createdTime = Int(mediaObject.objectForKey("created_time") as! String)
                        
                        self.userImageArray.addObject(userImage);
                    }
                    
                    let userImageCount = self.userImageArray.count
                    
                    if userImageCount > 0 {
                        
                        let userImageDA = UserImageDataAccess()
                        userImageDA.SaveUserImage(self.userImageArray)
                    }
                    
                    
                    
                    completion(result: "UserImageDownloaded")
                    
                    
                    
                    if((pagination) != nil && pagination?.count>0){
                        let nextUrl = pagination?.objectForKey("next_url") as? String
                        self.downloadUserMedias(nextUrl!,completion: {_ in
                            
                        });
                    }
                    
                    
                    
            }
            
            
        })
        
        
        
        
        
    }
    
}
