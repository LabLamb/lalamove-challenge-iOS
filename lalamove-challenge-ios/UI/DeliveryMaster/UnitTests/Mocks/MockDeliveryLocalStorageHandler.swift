//
//  MockDeliveryLocalStorageHandler.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 21/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import Foundation

class MockDeliveryLocalStorageHandler: DeliveryLocalStorageHandlerInterface {
    
    var deliveryDataStorage: [Int: [Delivery]] = [:]
    
    func updateImageData(with id: String, batch: Int, imageData: Data) {
        deliveryDataStorage[batch]?.first(where: { $0.id == id })?.goodsPicData = imageData.base64EncodedString()
    }
    
    func storeDeliveriesJSON(batch: Int, deliveries: [Delivery]) {
        deliveryDataStorage[batch] = deliveries
    }
    
    func fetchDeliveriesFromLocal(batch: Int) -> [Delivery] {
        return deliveryDataStorage[batch] ?? []
    }
    
    
}
