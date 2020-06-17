//
//  DeliveryAPIClient.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias DeliveryPagingInfo = (offset: Int, limit: Int)

protocol DeliveryAPIClientInterface {
    func fetchDeliveriesFromServer(paging: DeliveryPagingInfo?,
                                   onResponse: @escaping ([JSON]) -> (),
                                   onError: @escaping (String) -> ())
    
    func fetchImageFromLink(onResponse: @escaping (Data) -> (),
    onError: @escaping (String) -> ())
}

class DeliveryAPIClient: DeliveryAPIClientInterface {
    
    private let requestQueueHint = "DeliveryRequestQueue"
    
    func fetchDeliveriesFromServer(paging: DeliveryPagingInfo?,
                                   onResponse: @escaping ([JSON]) -> (),
                                   onError: @escaping (String) -> ()) {
        let param: [String: Any]? = {
            guard let paging = paging else { return nil }
            return ["offset": paging.offset,
            "limit": paging.limit]
        }()
        AF.request("https://mock-api-mobile.dev.lalamove.com/v2/deliveries", parameters: param).responseJSON(queue: .init(label: requestQueueHint), completionHandler: { res in
            switch res.result {
            case .success:
                guard let data = res.data,
                    let jsonArr = try? JSON(data: data).arrayValue else {
                        onResponse([])
                        return
                }
                onResponse(jsonArr)
            case .failure(let error):
                guard let errorMsg = error.errorDescription else {
                    onError("")
                    return
                }
                onError(errorMsg)
            }
        })
    }
    
    func fetchImageFromLink(onResponse: @escaping (Data) -> (),
                            onError: @escaping (String) -> ()) {
        
    }
}
