//
//  UserImageDataAccess.swift
//  PixErfTest-Instagram
//
//  Created by Krishantha Sunil Premaretna on 12/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import UIKit
import CoreData

class UserImageDataAccess: NSObject {

    let manageOBC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func SaveUserImage(userImageObjectArray:NSMutableArray){
        
        userImageObjectArray.forEach { userImage in
            do {
                try self.manageOBC.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
        }
        
    }
    
    func getFetchedResultsControllerForUserImage() -> NSFetchedResultsController {
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: self.manageOBC, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest()->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "UserImage")
        let sortDescriptor = NSSortDescriptor(key: "createdTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func deleteAllUserImage()
    {

        let fetchRequest = taskFetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try self.manageOBC.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                self.manageOBC.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele  error : \(error) \(error.userInfo)")
        }
    }
    
    
    func UserImageExists() -> Bool {
        
        let fetchRequest = taskFetchRequest()
        fetchRequest.includesSubentities = false
        
       
        let count = self.manageOBC.countForFetchRequest(fetchRequest, error:nil)
       
        if(count > 0) {
            return true
        }
        
        return false
    }
    
    
    
    
    
}
