//
//  DeliveryAPIClient.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol DeliveryAPIClientInterface {
    func fetchDeliveriesFromServer(onResponse: @escaping ([JSON]) -> ())
}

class DeliveryAPIClient: DeliveryAPIClientInterface {
    
    private let requestQueueHint = "DeliveryRequestQueue"
    
    func fetchDeliveriesFromServer(onResponse: @escaping ([JSON]) -> ()) {
        let params = ["offset": 0, "limit": 20]
        AF.request("https://mock-api-mobile.dev.lalamove.com/v2/deliveries", parameters: params).responseJSON(completionHandler: { res in
            guard let data = res.data,
                let jsonArr = try? JSON(data: data).arrayValue else {
                    onResponse([])
                    return
            }
            onResponse(jsonArr)
        })
//        AF.request("https://mock-api-mobile.dev.lalamove.com/v2/deliveries", parameters: params).responseJSON(queue: .init(label: requestQueueHint), completionHandler: { res in
//            print(res)
//            onResponse([])
//        })
    }
}
