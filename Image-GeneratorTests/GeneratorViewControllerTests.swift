//
//  GeneratorViewControllerTests.swift
//  Image-GeneratorTests
//
//  Created by Shuhrat Nurov on 04/05/23.
//

import XCTest
@testable import Image_Generator

final class GeneratorViewControllerTests: XCTestCase {
    
    var sut: GeneratorViewController!

    override func setUp() {
        super.setUp()
        sut = GeneratorViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testConfirmButtonTappedWithoutText() {
        // Given
        sut.inputField.text = ""
        
        // When
        sut.confirmButton.sendActions(for: .touchUpInside)
        
        // Then
        XCTAssertNil(sut.imageView.image)
    }
    
    func testConfirmButtonTappedWithValidText() {
        // Given
        sut.inputField.text = "test"
        
        // When
        sut.confirmButton.sendActions(for: .touchUpInside)
        
        // Then
        DispatchQueue.main.async {
            XCTAssertNotNil(self.sut.imageView.image)
        }
        
    }
    
    func testFavoriteButtonTapped() {
        // Given
        let title = "Test"
        let image = UIImage(named: "test_image")
        sut.inputField.text = title
        sut.imageView.image = image
        
        // When
        sut.btnTapped()
        
        // Then
        let savedImages = DataManager.shared.fetchImagesFromCoreData()
        XCTAssertTrue(savedImages.count > 0)
        XCTAssertEqual(savedImages.last?.title, title)
        XCTAssertEqual(savedImages.last?.imageData, image?.pngData())
    }

}
