//
//  SavedImages+CoreDataProperties.swift
//  Image-Generator
//
//  Created by Shuhrat Nurov on 04/05/23.
//
//

import Foundation
import CoreData


extension SavedImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedImages> {
        return NSFetchRequest<SavedImages>(entityName: "SavedImages")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageData: Data?

}
