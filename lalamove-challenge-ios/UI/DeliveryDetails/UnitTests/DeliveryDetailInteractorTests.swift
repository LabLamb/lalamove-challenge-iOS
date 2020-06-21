//
//  DeliveryDetailInteractorTests.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 20/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import SwiftyJSON
import XCTest

class DeliveryDetailInteractorTests: XCTestCase {
    
    var interactor: DeliveryDetailInteractor!
    
    override func setUp() {
        super.setUp()
        let delivery = Delivery(sortingNumber: 0, json: loadDeliveryJSON())
        let deliveryStateHandler = DeliveryStateHandler()
        self.interactor = DeliveryDetailInteractor(delivery: delivery,
                                                   deliveryStatehandler: deliveryStateHandler)
    }
    
    fileprivate func loadDeliveryJSON() -> JSON {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "MockDelivery", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        let json = try! JSON(data: data)
        return json
    }
    
    func test_getIsFavorite_expect_true() {
        interactor.delivery.isFavorite = true
        XCTAssertTrue(interactor.getIsFavorite())
    }
    
    func test_getIsFavorite_expect_false() {
        interactor.delivery.isFavorite = false
        XCTAssertFalse(interactor.getIsFavorite())
    }
    
    func test_getInfoViewConfig_true() {
        let config = interactor?.getInfoViewConfig()
        XCTAssertEqual(config?.fromAddress, "Noble Street")
        XCTAssertEqual(config?.toAddress, "Montauk Court")
        XCTAssertEqual(config?.goodsImage, UIImage())
        XCTAssertEqual(config?.deliveryFee, 92.14 + 136.46)
    }
    
    func test_getInfoViewConfig_false() {
        let config = interactor?.getInfoViewConfig()
        XCTAssertNotEqual(config?.fromAddress, "Random Street")
        XCTAssertNotEqual(config?.toAddress, "Random Court")
        XCTAssertNotEqual(config?.goodsImage, nil)
        XCTAssertNotEqual(config?.deliveryFee, Double.random(in: 0..<100))
    }
    
    func test_toggleDeliveryIsFavorite_true() {
        interactor.delivery.isFavorite = true
        let afterToggle = interactor.toggleDeliveryIsFavorite()
        XCTAssertEqual(afterToggle, false)
        let id = interactor.delivery.id
        let deliveryIsFav = interactor.deliveryStatehandler?.readFavoritesStatus(ids: [id])[id]
        XCTAssertEqual(deliveryIsFav, false)
    }
    
    func test_toggleDeliveryIsFavorite_false() {
        interactor.delivery.isFavorite = false
        let afterToggle = interactor.toggleDeliveryIsFavorite()
        XCTAssertEqual(afterToggle, true)
        let id = interactor.delivery.id
        let deliveryIsFav = interactor.deliveryStatehandler?.readFavoritesStatus(ids: [id])[id]
        XCTAssertEqual(deliveryIsFav, true)
    }
    
}
