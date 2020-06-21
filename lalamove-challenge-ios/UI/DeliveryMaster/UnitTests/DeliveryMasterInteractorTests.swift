//
//  DeliveryMsaterInteractorTests.swift
//  UITests
//
//  Created by LabLamb on 21/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import XCTest
import SwiftyJSON

class DeliveryMasterInteractorTests: XCTestCase {
    
    let ids = [
        "5dd5f3a7156bae72fa5a5d6c",
        "5dd5f3a787c49789dca0b43f",
        "5dd5f3a77120f5a8381abcbf",
        "5dd5f3a7805cb58b69c4e96a",
        "5dd5f3a74c2ac1ebe8902bbf",
        "5dd5f3a7d7754d36ce5247ab",
        "5dd5f3a7d06ea222d81e9c0c",
        "5dd5f3a776e11bf94dccd41d",
        "5dd5f3a71bf9ae8dea9875ea",
        "5dd5f3a7bf505199dc67c07d",
        "5dd5f3a732279cbfe3571ff3",
        "5dd5f3a78b32b523fd18d8cf",
        "5dd5f3a76d41484751b42418",
        "5dd5f3a707cf3f2907f7536d",
        "5dd5f3a7f015c6e5d5f799f1",
        "5dd5f3a7d502ac3344517242",
        "5dd5f3a7b6f11f1974a7fc30",
        "5dd5f3a79a5b2166c48e0716",
        "5dd5f3a7c0fb4bea99cf7497",
        "5dd5f3a77ca30481fb340b64"
    ]
    
    var mockAPIClient: MockDeliveryAPIClient!
    var mockLocalHandler: MockDeliveryLocalStorageHandler!
    var interactor: DeliveryMasterInteractor!
    var presenter: MockDeliveryMasterPresenter!
    
    override func setUp() {
        mockAPIClient = MockDeliveryAPIClient()
        mockLocalHandler = MockDeliveryLocalStorageHandler()
        
        presenter = MockDeliveryMasterPresenter()
        interactor = DeliveryMasterInteractor(apiClient: mockAPIClient,
                                              localStorageHandler: mockLocalHandler)
        interactor.presenter = presenter
    }
    
    func test_fetchDeliveries_delivery_success_local_empty_image_success() {
        mockAPIClient.deliveryShouldSuccess = true
        mockAPIClient.imageShouldSuccess = true
        XCTAssertTrue(mockLocalHandler.deliveryDataStorage.isEmpty)
        
        interactor.fetchDeliveries { [weak self] in
            guard let self = self else { fatalError("XCTest is deinited.") }
            let deliveries = self.interactor.deliveries
            XCTAssertEqual(deliveries.count, 20)
            for delivery in deliveries {
                XCTAssertEqual(delivery.id, self.ids[delivery.sortingNumber])
                
                // Batch number should be 0
                let localDelivery = self.mockLocalHandler.deliveryDataStorage[0]?.first(where: { $0.id == delivery.id })
                XCTAssertNotNil(localDelivery)
                
                XCTAssertEqual(delivery.goodsPicData, MockDeliveryAPIClient.BoxImage.pngData()?.base64EncodedString())
            }
        }
    }
    
    func test_fetchDeliveries_delivery_fail_local_empty_image_success() {
        mockAPIClient.deliveryShouldSuccess = false
        XCTAssertTrue(mockLocalHandler.deliveryDataStorage.isEmpty)
        
        interactor.fetchDeliveries { [weak self] in
            guard let self = self else { fatalError("XCTest is deinited.") }
            let deliveries = self.interactor.deliveries
            XCTAssertTrue(deliveries.isEmpty)
            XCTAssertTrue(self.presenter.didPresentRetryFetchAlert)
        }
    }
    
    func test_fetchDeliveries_delivery_fail_local_loaded_image_success() {
        test_fetchDeliveries_delivery_success_local_empty_image_success()
        
        // Clear RAM
        interactor.deliveries = []
        XCTAssertFalse(mockLocalHandler.deliveryDataStorage.isEmpty)
        
        mockAPIClient.deliveryShouldSuccess = false
        mockAPIClient.imageShouldSuccess = true
        
        interactor.fetchDeliveries { [weak self] in
            guard let self = self else { fatalError("XCTest is deinited.") }
            let deliveries = self.interactor.deliveries
            XCTAssertEqual(deliveries.count, 20)
            for delivery in deliveries {
                XCTAssertEqual(delivery.id, self.ids[delivery.sortingNumber])
                
                // Batch number should be 0
                let localDelivery = self.mockLocalHandler.deliveryDataStorage[0]?.first(where: { $0.id == delivery.id })
                XCTAssertNotNil(localDelivery)
                
                XCTAssertEqual(delivery.goodsPicData, MockDeliveryAPIClient.BoxImage.pngData()?.base64EncodedString())
            }
        }
    }
    
    func test_fetchDeliveries_delivery_success_local_loaded_image_fail() {
        mockAPIClient.deliveryShouldSuccess = true
        mockAPIClient.imageShouldSuccess = false
        
        interactor.fetchDeliveries { [weak self] in
            guard let self = self else { fatalError("XCTest is deinited.") }
            let deliveries = self.interactor.deliveries
            XCTAssertEqual(deliveries.count, 20)
            for delivery in deliveries {
                XCTAssertEqual(delivery.id, self.ids[delivery.sortingNumber])
                
                let localDelivery = self.mockLocalHandler.deliveryDataStorage[0]?.first(where: { $0.id == delivery.id })
                XCTAssertNotNil(localDelivery)
                
                XCTAssertNil(delivery.getGoodsImage())
            }
        }
    }
    
    func test_fetchDeliveries_delivery_success_image_success_twice() {
        mockAPIClient.deliveryShouldSuccess = true
        mockAPIClient.imageShouldSuccess = true
        
        test_fetchDeliveries_delivery_success_local_empty_image_success()
        interactor.fetchDeliveries { [weak self] in
            guard let self = self else { fatalError("XCTest is deinited.") }
            XCTAssertEqual(self.interactor.deliveries.count, 40)
        }
    }
    
    func test_getDelivery_EqualNil() {
        let delivery = interactor.getDelivery(at: 10)
        XCTAssertNil(delivery)
    }
    
    func test_getDelivery_NotNil() {
        test_fetchDeliveries_delivery_success_local_empty_image_success()
        let delivery = interactor.getDelivery(at: 10)
        XCTAssertNotNil(delivery)
    }
    
    func test_getNumberOfDeliveries_0() {
        let count = interactor.getNumberOfDeliveries()
        XCTAssertEqual(count, 0)
        XCTAssertEqual(count, interactor.deliveries.count)
    }
    
    func test_getNumberOfDeliveries_20() {
        test_fetchDeliveries_delivery_success_local_empty_image_success()
        let count = interactor.getNumberOfDeliveries()
        XCTAssertEqual(count, 20)
        XCTAssertEqual(count, interactor.deliveries.count)
    }
}
