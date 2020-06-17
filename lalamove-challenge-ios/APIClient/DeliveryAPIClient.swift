//
//  DeliveryAPIClient.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol DeliverAPIClientInterface {
    func fetchDeliveriesFromServer() -> [JSON]
}

class DeliverAPIClient: DeliverAPIClientInterface {
    func fetchDeliveriesFromServer() -> [JSON] {
        return []
    }
}
