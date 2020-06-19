//
//  DeliveryDetailsPresenter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

class DeliveryDetailPresenter {
    var delivery: Delivery
    weak var viewController: DeliveryDetailViewControllerInterface?
    private var displayLink: CADisplayLink?
    
    init(delivery: Delivery) {
        self.delivery = delivery
        displayLink = CADisplayLink(target: self, selector: #selector(self.updateInfoView))
        displayLink?.add(to: .main, forMode: .default)
    }
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
        let config = getInfoViewConfig()
        let infoView = DeliveryDetailInfoView(config: config)
        viewController?.setupInfoView(infoView: infoView)
    }
    
    func toggleIsFavorite() {
        delivery.isFavorite = !delivery.isFavorite
    }
    
    func updateFavoriteBtn() {
        viewController?.toggleFavBtn(isFav: delivery.isFavorite)
    }
    
    func presentNavigationTitle() {
        viewController?.setupNavigationBarTitle()
    }
    
    func getInfoViewConfig() -> DeliveryDetailInfoViewConfiguration {
        let img = delivery.getGoodsImage() ?? UIImage()
        return DeliveryDetailInfoViewConfiguration(fromAddress: delivery.from,
                                                   toAddress: delivery.to,
                                                   goodsImage: img,
                                                   deliveryFee: delivery.fee)
    }
    
    func removeCADisplayLink() {
        displayLink?.invalidate()
    }
    
    @objc func updateInfoView() {
        let config = getInfoViewConfig()
        viewController?.updateInfoView(config: config)
    }
}
