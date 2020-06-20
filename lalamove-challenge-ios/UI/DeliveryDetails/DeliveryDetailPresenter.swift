//
//  DeliveryDetailsPresenter.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

class DeliveryDetailPresenter {
    
    private let addFavoriteBtnText = "Add to Favorite ❤️"
    private let removeFavoriteBtnText = "Remove from Favorite 💔"
    
    var interactor: DeliveryDetailInteractorInterface?
    weak var viewController: DeliveryDetailViewControllerInterface?
    private var displayLink: CADisplayLink?
    
    init() {
        displayLink = CADisplayLink(target: self, selector: #selector(self.updateInfoView))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    func presentFavoriteButton() {
        guard let interactor = interactor else { return }
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        let title = interactor.getIsFavorite() ? removeFavoriteBtnText : addFavoriteBtnText
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(favBtnTapped), for: .touchUpInside)
        viewController?.setupFavBtn(favBtn: btn)
    }
    
    func presentInfoView() {
        guard let interactor = self.interactor else { return }
        let config = interactor.getInfoViewConfig()
        let infoView = DeliveryDetailInfoView(config: config)
        viewController?.setupInfoView(infoView: infoView)
    }
    
    @objc func favBtnTapped() {
        let isFav = toggleIsFavorite()
        let title = isFav ? removeFavoriteBtnText : addFavoriteBtnText
        viewController?.updateFavBtnTitle(title: title)
    }
    
    @objc func updateInfoView() {
        guard let interactor = self.interactor else { return }
        let config = interactor.getInfoViewConfig()
        viewController?.updateInfoView(config: config)
    }
}

extension DeliveryDetailPresenter: DeliveryDetailPresenterInterface {
    func setupView() {
        presentInfoView()
        presentFavoriteButton()
        viewController?.setupNavigationBarTitle()
    }
    
    func toggleIsFavorite() -> Bool {
        guard let interactor = interactor else { return false }
        return interactor.toggleDeliveryIsFavorite()
    }
    
    func removeCADisplayLink() {
        displayLink?.invalidate()
    }
    
}
