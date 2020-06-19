//
//  DeliveryDetailInteractor.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

class DeliveryDetailInteractor {
    var presenter: DeliveryDetailPresenterInterface?
}

extension DeliveryDetailInteractor: DeliveryDetailInteractorInterface {
    func toggleDeliveryFavariteStatus() {
        presenter?.toggleIsFav()
        presenter?.updateFavBtn()
    }
    
    func setupView() {
        presenter?.presentInfoView()
        presenter?.presentFavoriteButton()
    }
}
