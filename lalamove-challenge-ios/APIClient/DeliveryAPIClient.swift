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

enum DeliveryAPICallError {
    case genericError, apiClientDeinit
}

protocol DeliveryAPIClientInterface {
    func fetchDeliveriesFromServer(paging: DeliveryPagingInfo?,
                                   onResponse: @escaping ([JSON]) -> (),
                                   onError: @escaping (DeliveryAPICallError) -> ())
    
    func fetchImageFromLink(imgUrl: String,
                            onResponse: @escaping (UIImage) -> ())
}

class DeliveryAPIClient {
    private let deliverAPI = "https://mock-api-mobile.dev.lalamove.com/v2/deliveries" // Normally would keep it in a .json file
    private let requestQueueHint = "DeliveryRequestQueue"
    private let imageQueueHint = "DeliveryImageRequestQueue"
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
        
        AF.request(deliverAPI, parameters: param)
            .responseJSON(queue: .init(label: requestQueueHint), completionHandler: { [weak self] res in
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
    
    func fetchImageFromLink(imgUrl: String, onResponse: @escaping (UIImage) -> ()) {
        AF.request(imgUrl, method: .get).responseImage(queue: .init(label: imageQueueHint), completionHandler: { res in
            switch res.result {
            case .success(let image):
                onResponse(image)
            case .failure:
                break
            }
        })
    }
}
