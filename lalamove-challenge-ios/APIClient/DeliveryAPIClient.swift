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
                                   onError: @escaping (DeliveryAPICallError) -> ())
    
    func fetchImageFromLink(onResponse: @escaping (Data) -> (),
                            onError: @escaping (String) -> ())
}

class DeliveryAPIClient {
    private let deliverAPI = "https://mock-api-mobile.dev.lalamove.com/v2/deliveries"
    private let requestQueueHint = "DeliveryRequestQueue"
}

extension DeliveryAPIClient: DeliveryAPIClientInterface {
    
    func fetchDeliveriesFromServer(paging: DeliveryPagingInfo?,
                                   onResponse: @escaping ([JSON]) -> (),
                                   onError: @escaping (DeliveryAPICallError) -> ()) {
        
        let param: [String: Any]? = {
            guard let paging = paging else { return nil }
            return ["offset": paging.offset,
                    "limit": paging.limit]
        }()
        
        AF.request(deliverAPI,
                   parameters: param)
            .responseJSON(queue: .init(label: requestQueueHint),completionHandler: { [weak self] res in
                guard let self = self else {
                    onError(.apiClientDeinit)
                    return
                }
                
                switch res.result {
                case .success:
                    self.handlerDeliveriesSuccessRetrieval(onResponse: onResponse, res: res)
                case .failure:
                    onError(.genericError)
                }
            })
    }
    
    fileprivate func handlerDeliveriesSuccessRetrieval(onResponse: @escaping ([JSON]) -> (), res: AFDataResponse<Any>) {
        guard let data = res.data,
            let jsonArr = try? JSON(data: data).arrayValue else {
                onResponse([])
                return
        }
        onResponse(jsonArr)
    }
    
    func fetchImageFromLink(onResponse: @escaping (Data) -> (),
                            onError: @escaping (String) -> ()) {
        
    }
}
