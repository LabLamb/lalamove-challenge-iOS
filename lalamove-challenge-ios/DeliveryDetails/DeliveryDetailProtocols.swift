//
//  DeliveryDetailProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

protocol DeliveryDetailViewControllerInterface: BaseViewController {
    func toggleFavBtn(isFav: Bool)
}

protocol DeliveryDetailInteractorInterface: BaseInteractor {
    func markDeliveryAsFav()
}

protocol DeliveryDetailPresenterInterface: BasePresenter {
    func setupStackView()
    func setupRouteView()
    func setupGoodsPicView()
    func setupFeeView()
    func setupFavBtn()
    
    func updateFavBtn()
}
