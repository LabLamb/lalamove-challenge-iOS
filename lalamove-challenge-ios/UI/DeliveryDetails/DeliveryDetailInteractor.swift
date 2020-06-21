//
//  DeliveryDetailInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UIImage

class DeliveryDetailInteractor {
    
    var delivery: Delivery
    var deliveryStatehandler: DeliveryStateHandlerInterface?
    
    init(delivery: Delivery,
        deliveryStatehandler: DeliveryStateHandlerInterface = DeliveryStateHandler()) {
        self.delivery = delivery
        self.deliveryStatehandler = deliveryStatehandler
    }
}

extension DeliveryDetailInteractor: DeliveryDetailInteractorInterface {
    
    func getIsFavorite() -> Bool {
        return delivery.isFavorite
    }
    
    func getInfoViewConfig() -> DeliveryDetailInfoViewConfiguration {
        let img = delivery.getGoodsImage() ?? UIImage()
        return DeliveryDetailInfoViewConfiguration(fromAddress: delivery.from,
                                                   toAddress: delivery.to,
                                                   goodsImage: img,
                                                   deliveryFee: delivery.fee)
    }
    
    func toggleDeliveryIsFavorite() -> Bool {
        delivery.isFavorite = !delivery.isFavorite
        deliveryStatehandler?.updateFavoriteStatus(id: delivery.id, isFav: delivery.isFavorite)
        return delivery.isFavorite
    }
}
