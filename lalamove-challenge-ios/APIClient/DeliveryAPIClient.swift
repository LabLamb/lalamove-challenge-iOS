//
//  DeliveryAPIClient.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Alamofire
import AlamofireImage
import SwiftyJSON

typealias DeliveryPagingInfo = (offset: Int, limit: Int)
typealias ResponseCallback = (Result<Any, AFError>) -> Void

enum DeliveryAPICallError {
    case genericError
}

protocol DeliveryAPIClientInterface {
    func fetchDeliveriesFromServer(paging: DeliveryPagingInfo?,
                                   completion: @escaping ResponseCallback)
    
    func fetchImageFromLink(imgUrl: String,
                            completion: @escaping (Result<UIImage, AFError>) -> Void)
}

class DeliveryAPIClient {
    private let deliverAPI = "https://mock-api-mobile.dev.lalamove.com/v2/deliveries" // Normally would keep it in a .json file
    private let requestQueueHint = "DeliveryRequestQueue"
    private let imageQueueHint = "DeliveryImageRequestQueue"
}

extension DeliveryAPIClient: DeliveryAPIClientInterface {
    
    func fetchDeliveriesFromServer(paging: DeliveryPagingInfo?,
                                   completion: @escaping ResponseCallback) {
        
        let param: [String: Any]? = {
            guard let paging = paging else { return nil }
            return ["offset": paging.offset,
                    "limit": paging.limit]
        }()
        
        AF.request(deliverAPI, parameters: param)
            .responseJSON(queue: .init(label: requestQueueHint), completionHandler: { res in
                completion(res.result)
            })
    }
    
    func fetchImageFromLink(imgUrl: String,
                            completion: @escaping (Result<UIImage, AFError>) -> ()) {
        AF.request(imgUrl, method: .get)
            .responseImage(queue: .init(label: imageQueueHint), completionHandler: { res in
            completion(res.result)
        })
    }
}
