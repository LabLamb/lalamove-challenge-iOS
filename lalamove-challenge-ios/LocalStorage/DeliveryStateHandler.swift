//
//  DeilveryStateHandler.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 19/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Foundation

protocol DeliveryStateHandlerInterface {
    func readFavoritesStatus(ids: [String]) -> [String: Bool]
    func updateFavoriteStatus(id: String, isFav: Bool)
}

struct DeliveryStateHandler {
    let connectorString = "_"
    let favoriteStateKey = "favorite"
}

extension DeliveryStateHandler: DeliveryStateHandlerInterface {
    
    func readFavoritesStatus(ids: [String]) -> [String: Bool] {
        var result = [String: Bool]()
        
        for id in ids {
            result[id] = UserDefaults.standard.bool(forKey: favoriteStateKey + connectorString  + id)
        }
        
        return result
    }
    
    func updateFavoriteStatus(id: String, isFav: Bool) {
        UserDefaults.standard.set(isFav, forKey: favoriteStateKey + connectorString  + id)
    }
}
