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
    func setupFavBtn(favBtn: UIButton)
    func setupInfoView(infoView: DeliveryDetailInfoView)
    func updateFavBtnTitle(title: String)
    func updateInfoView(config: DeliveryDetailInfoViewConfiguration)
}

protocol DeliveryDetailInteractorInterface {
    func getIsFavorite() -> Bool
    func getInfoViewConfig() -> DeliveryDetailInfoViewConfiguration
    func toggleDeliveryIsFavorite() -> Bool
}

protocol DeliveryDetailPresenterInterface: BasePresenterInterface {
    func removeCADisplayLink()
}
