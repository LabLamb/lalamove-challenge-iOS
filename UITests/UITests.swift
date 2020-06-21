//
//  UITests.swift
//  UITests
//
//  Created by LabLamb on 20/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()
    }
    
    func testIndicatorExists() {
        XCTAssertNotNil(app.tables.allElementsBoundByIndex.first?.activityIndicators["In progress"])
    }
    
    func testInitialLoad() {
        let exists = NSPredicate(format: "count >= 20")
        expectation(for: exists, evaluatedWith: app.cells)
        waitForExpectations(timeout: 10)
    }
    
    func testLoadMoreData() {
        testInitialLoad()
        
        for _ in 0...3 {
            app.swipeUp()
        }
        
        testIndicatorExists()
        
        let exists = NSPredicate(format: "count >= 40")
        expectation(for: exists, evaluatedWith: app.cells)
        waitForExpectations(timeout: 10)
    }
    
    func testEnterDetailPage() {
        testInitialLoad()
        app.cells.allElementsBoundByIndex.first?.tap()
        XCTAssert(app.staticTexts["From"].exists)
        XCTAssert(app.staticTexts["To"].exists)
        XCTAssert(app.staticTexts["Goods to deliver"].exists)
        XCTAssert(app.staticTexts["Delivery Fee"].exists)
        XCTAssertNotNil(app.buttons.allElementsBoundByIndex.first(where: { $0.label.contains("Favorite") }))
    }
    
    func testTogglingFavButton() {
        testEnterDetailPage()
        guard let isFavBtn = app.buttons.allElementsBoundByIndex.first(where: { $0.label.contains("Favorite") }) else {
            XCTFail("Favorite button is missing.")
            return
        }
        let originalTxt = isFavBtn.staticTexts.allElementsBoundByIndex.first
        isFavBtn.tap()
        let newTxt = isFavBtn.staticTexts.allElementsBoundByIndex.first
        
        XCTAssertNotEqual(originalTxt, newTxt)
    }
    
    func testTogglingFavButtonWillAffectMaster() {
        testInitialLoad()
        
        guard let targetCell = app.cells.allElementsBoundByIndex.first(where: { cell in
            !cell.staticTexts.allElementsBoundByIndex.contains(where: { $0.label == "❤️" })
        }) else {
            XCTFail("No cells without heart.")
            return
        }
        
        XCTAssertNotNil(targetCell)
        targetCell.tap()
        
        guard let favBtn = app.buttons.allElementsBoundByIndex.first(where: { $0.label.contains("Favorite") }) else {
            XCTFail("Favorite button is missing.")
            return
        }
        favBtn.tap()
        
        guard let backBtn = app.buttons.allElementsBoundByIndex.first(where: { $0.label == "My Deliveries" }) else {
            XCTFail("Back button is missing.")
            return
        }
        backBtn.tap()

        let hasHeart = targetCell.staticTexts.allElementsBoundByIndex.contains(where: { $0.label == "❤️" })
        XCTAssertTrue(hasHeart)
        
        targetCell.tap()
        favBtn.tap()
        backBtn.tap()
        
        let noHeart = targetCell.staticTexts.allElementsBoundByIndex.contains(where: { $0.label == "❤️" })
        XCTAssertFalse(noHeart)
    }
}
