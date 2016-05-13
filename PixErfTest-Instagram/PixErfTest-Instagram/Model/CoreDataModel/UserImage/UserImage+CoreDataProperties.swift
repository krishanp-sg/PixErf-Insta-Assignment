//
//  UserImage+CoreDataProperties.swift
//  
//
//  Created by Krishantha Sunil Premaretna on 12/5/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserImage {

    @NSManaged var createdTime: NSNumber?
    @NSManaged var lowresolution: String?
    @NSManaged var thumbnail: String?
    @NSManaged var standard: String?

}
