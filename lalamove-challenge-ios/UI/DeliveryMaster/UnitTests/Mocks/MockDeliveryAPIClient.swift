//
//  MockDeliveryAPIClient.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 21/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import SwiftyJSON
import Alamofire

class MockDeliveryAPIClient: DeliveryAPIClientInterface {
    
    var deliveryShouldSuccess = true
    var imageShouldSuccess = true
    
    static let BoxImage: UIImage = {
        let sysImgName = "cube.box"
        guard let image = UIImage(systemName: sysImgName) else {
            fatalError("System image \(sysImgName) does not exists.")
        }
        return image
    }()
    
    fileprivate func loadDeliveriesJSON(offset: Int) -> JSON {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "MockDeliveryList_offset_\(offset)", withExtension: "json")
        guard let data = try? Data(contentsOf: fileUrl!),
            let json = try? JSON(data: data) else {
                fatalError("No Mock data exists for offset \(offset).")
        }
        return json
    }
    
    func fetchDeliveriesFromServer(paging: DeliveryPagingInfo, completion: @escaping ResponseJSONCallback) {
        if deliveryShouldSuccess {
            completion(Result.success(loadDeliveriesJSON(offset: paging.offset)))
        } else {
            completion(Result.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))))
        }
    }
    
    func fetchImageFromLink(imgUrl: String, completion: @escaping ResponseImageCallback) {
        if imageShouldSuccess {
            completion(Result.success(MockDeliveryAPIClient.BoxImage))
        } else {
            completion(Result.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))))
        }
    }
    
    
}
