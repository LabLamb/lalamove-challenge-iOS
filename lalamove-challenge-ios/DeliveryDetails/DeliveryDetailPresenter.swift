//
//  DeliveryDetailsPresenter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

class DeliveryDetailPresenter {
    weak var delivery: Delivery?
    weak var viewController: DeliveryDetailViewControllerInterface?
}

extension DeliveryDetailPresenter: DeliveryDetailPresenterInterface {
    func presentFavoriteButton() {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        viewController?.setupFavBtn(favBtn: btn)
        updateFavoriteBtn()
    }
    
    func presentInfoView() {
        let infoView = DeliveryDetailInfoView()
        viewController?.setupInfoView(infoView: infoView)
    }
    
    func toggleIsFavorite() {
        guard let delivery = delivery else { return }
        delivery.isFavorite = !delivery.isFavorite
    }
    
    func updateFavoriteBtn() {
        guard let delivery = delivery else { return }
        viewController?.toggleFavBtn(isFav: delivery.isFavorite)
    }
    
    func presentNavigationTitle() {
        viewController?.setupNavigationBarTitle()
    }
}
