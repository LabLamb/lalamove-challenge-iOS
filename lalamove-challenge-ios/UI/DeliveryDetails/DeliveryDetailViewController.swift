//
//  DeliveryDetailViewController.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryDetailViewController: UIViewController {
    
    private struct UIConstants {
        static let buttonMargin = 25
    }
    
    fileprivate let navTitle = "Delivery Details"
    private let addFavoriteBtnText = "Add to Favorite ❤️"
    private let removeFavoriteBtnText = "Remove from Favorite 💔"
    
    private weak var infoView: DeliveryDetailInfoView?
    private weak var favoriteButton: UIButton?
    var interactor: DeliveryDetailInteractorInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        interactor?.setupView()
    }
}

extension DeliveryDetailViewController: DeliveryDetailViewControllerInterface {
    func setupFavBtn(favBtn: UIButton) {
        self.view.addSubview(favBtn)
        favBtn.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().offset(-UIConstants.buttonMargin)
            make.left.equalToSuperview().offset(UIConstants.buttonMargin)
            make.height.equalToSuperview().dividedBy(20)
        }
        favoriteButton = favBtn
        favoriteButton?.addTarget(self, action: #selector(favBtnTapped), for: .touchUpInside)
    }
    
    func setupInfoView(infoView: DeliveryDetailInfoView) {
        self.view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        self.infoView = infoView
    }
    
    func toggleFavBtn(isFav: Bool) {
        interactor?.updateLocalDeliveryFavorite(status: isFav)
        
        guard let btn = favoriteButton else { return }
        if isFav {
            btn.setTitle(removeFavoriteBtnText, for: .normal)
        } else {
            btn.setTitle(addFavoriteBtnText, for: .normal)
        }
    }
    
    func setupNavigationBarTitle() {
        navigationItem.title = navTitle
    }
    
    @objc func favBtnTapped() {
        interactor?.updateFavoriteBtnStatus()
    }
    
    func updateInfoView(config: DeliveryDetailInfoViewConfiguration) {
        infoView?.setupData(config: config)
    }
}
