//
//  Delivery.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Foundation
import SwiftyJSON

class Delivery {
    let id: String
    let remarks: String
    var isFavorite = false
    let goodsPicData: Data? = nil
    let routeStart: String
    let routeEnd: String
    private let deliveryFee: Double
    private let surcharge: Double
    var fee: Double {
        get {
            return deliveryFee + surcharge
        }
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.remarks = json["remark"].stringValue
        self.routeStart = json["route"].dictionaryValue["start"]?.stringValue ?? ""
        self.routeEnd = json["route"].dictionaryValue["end"]?.stringValue ?? ""
        self.deliveryFee = Double(json["deliveryFee"].stringValue.replacingOccurrences(of: "$", with: "")) ?? 0.00
        self.surcharge = Double(json["surcharge"].stringValue.replacingOccurrences(of: "$", with: "")) ?? 0.00
    }
    
    func getGoodsImage() -> UIImage {
        guard let goodsPicData = goodsPicData,
            let image = UIImage(data: goodsPicData) else { return UIImage() }
        return image
    }
}

extension Delivery: DeliverySummary {
    var goodsPic: UIImage {
        return getGoodsImage()
    }
    
    var price: Double {
        return fee
    }
    
    var from: String {
        return routeStart
    }
    
    var to: String {
        return routeEnd
    }
    
    var isFav: Bool {
        return isFavorite
    }
}
