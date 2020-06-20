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
    
    private weak var infoView: DeliveryDetailInfoView?
    private weak var favoriteButton: UIButton?
    var presenter: DeliveryDetailPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        presenter?.setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.removeCADisplayLink()
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
    }
    
    func setupInfoView(infoView: DeliveryDetailInfoView) {
        self.view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        self.infoView = infoView
    }
    
    func updateFavBtnTitle(title: String) {
        favoriteButton?.setTitle(title, for: .normal)
    }
    
    func setupNavigationBarTitle() {
        navigationItem.title = navTitle
    }
    
    func updateInfoView(config: DeliveryDetailInfoViewConfiguration) {
        infoView?.setupData(config: config)
    }
}
