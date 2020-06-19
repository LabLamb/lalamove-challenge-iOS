//
//  DeliveryDetailProtocols.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import Foundation
import UIKit.UIButton

protocol DeliveryDetailViewControllerInterface: BaseViewControllerInterface {
    func toggleFavBtn(isFav: Bool)
    func setupFavBtn(favBtn: UIButton)
    func setupInfoView(infoView: DeliveryDetailInfoView)
    func updateInfoView(config: DeliveryDetailInfoViewConfiguration)
}

protocol DeliveryDetailInteractorInterface: BaseInteractorInterface {
    func updateLocalDeliveryFavorite(status: Bool)
    func updateFavoriteBtnStatus()
}

protocol DeliveryDetailPresenterInterface: BasePresenterInterface {
    func presentFavoriteButton()
    func presentInfoView()
    func updateFavoriteBtn()
    func toggleIsFavorite()
    func removeCADisplayLink()
}
