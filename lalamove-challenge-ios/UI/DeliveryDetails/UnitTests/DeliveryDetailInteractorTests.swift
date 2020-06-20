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
    
    var delivery: Delivery!
    var deliverStateHandler: DeliveryStateHandlerInterface!
    var interactor: DeliveryDetailInteractor!
    
    override func setUp() {
        super.setUp()
        self.delivery = Delivery(sortingNumber: 0, json: loadDeliveryJSON())
        self.deliverStateHandler = DeliveryStateHandler()
        self.interactor = DeliveryDetailInteractor(delivery: delivery,
                                                   deliveryStatehandler: deliverStateHandler)
    }
    
    fileprivate func loadDeliveryJSON() -> JSON {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "MockDeliveryJSON", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        let json = try! JSON(data: data)
        return json
    }
    
    func test_getIsFavorite_expect_true() {
        delivery.isFavorite = true
        XCTAssertTrue(interactor.getIsFavorite())
    }
    
    func test_getIsFavorite_expect_false() {
        delivery.isFavorite = false
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
        delivery.isFavorite = true
        let afterToggle = interactor.toggleDeliveryIsFavorite()
        XCTAssertEqual(afterToggle, false)
        let deliveryIsFav = deliverStateHandler?.readFavoritesStatus(ids: [delivery.id])[delivery.id]
        XCTAssertEqual(deliveryIsFav, false)
    }
    
    func test_toggleDeliveryIsFavorite_false() {
        delivery.isFavorite = false
        let afterToggle = interactor.toggleDeliveryIsFavorite()
        XCTAssertEqual(afterToggle, true)
        let deliveryIsFav = deliverStateHandler?.readFavoritesStatus(ids: [delivery.id])[delivery.id]
        XCTAssertEqual(deliveryIsFav, true)
    }
    
}
