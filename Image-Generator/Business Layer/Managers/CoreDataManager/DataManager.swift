//
//  DataManager.swift
//  Image-Generator
//
//  Created by Shuhrat Nurov on 04/05/23.
//

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    
    private var limit = 5
    
    func saveImageToCoreData(title: String, image: UIImage) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if fetchImagesFromCoreData().count == limit, let first = fetchImagesFromCoreData().first {
            deleteImageFromCoreData(imageEntity: first)
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SavedImages", in: managedContext)!
        let imageEntity = NSManagedObject(entity: entity, insertInto: managedContext) as! SavedImages
        
        imageEntity.title = title
        imageEntity.imageData = image.pngData() as Data?
        
        appDelegate.saveContext()
    }
    
    func fetchImagesFromCoreData() -> [SavedImages] {
        var imagesData = [SavedImages]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return imagesData
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            imagesData = try managedContext.fetch(SavedImages.fetchRequest())
        } catch let error as NSError {
            print("Could not save image. \(error), \(error.userInfo)")
        }
        
        return imagesData
    }
    
    func deleteImageFromCoreData(imageEntity: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(imageEntity)
        
        appDelegate.saveContext()
    }
    
}
