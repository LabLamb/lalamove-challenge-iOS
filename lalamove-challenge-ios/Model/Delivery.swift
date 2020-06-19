//
//  Delivery.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Foundation
import SwiftyJSON

class Delivery: Codable {
    let id: String
    var isFavorite = false
    var goodsPicData: String?
    let routeStart: String
    let routeEnd: String
    private let deliveryFee: Double
    private let surcharge: Double
    var fee: Double {
        get {
            return deliveryFee + surcharge
        }
    }
    let sortingNumber: Int
    
    init(sortingNumber: Int, json: JSON) { // Not going to use object mapping libraries because this app only has 1 model
        self.id = json["id"].stringValue
        self.routeStart = json["route"].dictionaryValue["start"]?.stringValue ?? ""
        self.routeEnd = json["route"].dictionaryValue["end"]?.stringValue ?? ""
        self.deliveryFee = Double(json["deliveryFee"].stringValue.replacingOccurrences(of: "$", with: "")) ?? 0.00
        self.surcharge = Double(json["surcharge"].stringValue.replacingOccurrences(of: "$", with: "")) ?? 0.00
        self.sortingNumber = sortingNumber
    }
    
    func getGoodsImage() -> UIImage? {
        guard let goodPicDataString = goodsPicData,
            let data = Data(base64Encoded: goodPicDataString),
            let image = UIImage(data: data) else { return nil }
        return image
    }
}

extension Delivery: DeliverySummary {
    var goodsPic: UIImage? {
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
