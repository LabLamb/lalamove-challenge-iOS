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
        updateFavBtn()
    }
    
    func presentInfoView() {
        let infoView = DeliveryDetailInfoView()
        viewController?.setupInfoView(infoView: infoView)
    }
    
    func toggleIsFav() {
        guard let delivery = delivery else { return }
        delivery.isFavorite = !delivery.isFavorite
    }
    
    func updateFavBtn() {
        guard let delivery = delivery else { return }
        viewController?.toggleFavBtn(isFav: delivery.isFavorite)
    }
    
    func presentNavigationTitle() {
        viewController?.setupNavigationBarTitle()
    }
}
