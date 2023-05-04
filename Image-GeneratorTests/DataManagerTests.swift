//
//  DataManagerTests.swift
//  Image-GeneratorTests
//
//  Created by Shuhrat Nurov on 04/05/23.
//

import XCTest
@testable import Image_Generator

final class DataManagerTests: XCTestCase {
    var dataManager:DataManager?

    override func setUp() {
        super.setUp()
        dataManager = DataManager.shared
    }

    override func tearDown() {
        dataManager = nil
        super.tearDown()
    }

    func testSaveImageToCoreData() {
        let dataManager = DataManager.shared
        let title = "Test Image"
        let image = UIImage(named: "test_image")
        
        dataManager.saveImageToCoreData(title: title, image: image!)
        
        // Assert
        let savedImages = dataManager.fetchImagesFromCoreData()
        XCTAssertEqual(savedImages.last?.title, title, "Expected the saved image title to match the provided title")
        XCTAssertEqual(savedImages.last?.imageData, image?.pngData(), "Expected the saved image data to match the provided image data")
    }
    
    func testFetchImagesFromCoreData() {
        let dataManager = DataManager.shared
        let title = "Test Image"
        let image = UIImage(named: "test_image")
        dataManager.saveImageToCoreData(title: title, image: image!)
        
        let savedImages = dataManager.fetchImagesFromCoreData()
        
        // Assert
        XCTAssertNotNil(savedImages)
        XCTAssertEqual(savedImages.last?.title, title, "Expected the fetched image title to match the saved title")
        XCTAssertEqual(savedImages.last?.imageData, image?.pngData(), "Expected the fetched image data to match the saved image data")
    }
    
    func testDeleteImageFromCoreData() {
        let dataManager = DataManager.shared
        let title = "Test Image"
        let image = UIImage(named: "test_image")
        dataManager.saveImageToCoreData(title: title, image: image!)
        let savedImages = dataManager.fetchImagesFromCoreData()
        
        savedImages.forEach { image in
            dataManager.deleteImageFromCoreData(imageEntity: image)
        }
        
        // Assert
        let updatedSavedImages = dataManager.fetchImagesFromCoreData()
        XCTAssertEqual(updatedSavedImages.count, 0, "Expected to delete 1 image from CoreData")
    }

}
