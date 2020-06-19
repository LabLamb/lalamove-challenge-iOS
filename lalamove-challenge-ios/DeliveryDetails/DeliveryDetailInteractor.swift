//
//  DeliveryDetailInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

class DeliveryDetailInteractor {
    fileprivate var deliveryStatehandler: DeliveryStateHandlerInterface?
    fileprivate let deliveryId: String
    var presenter: DeliveryDetailPresenterInterface?
    
    init(deliveryId: String,
        deliveryStatehandler: DeliveryStateHandlerInterface = DeliveryStateHandler()) {
        self.deliveryId = deliveryId
        self.deliveryStatehandler = deliveryStatehandler
    }
}

extension DeliveryDetailInteractor: DeliveryDetailInteractorInterface {
    func updateLocalDeliveryFavorite(status: Bool) {
        deliveryStatehandler?.updateFavoriteStatus(id: deliveryId, isFav: status)
    }
    
    func updateFavoriteBtnStatus() {
        presenter?.toggleIsFavorite()
        presenter?.updateFavoriteBtn()
    }
    
    func setupView() {
        presenter?.presentInfoView()
        presenter?.presentFavoriteButton()
    }
}
