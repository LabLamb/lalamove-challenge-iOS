//
//  MockDeliveryDetailViewController.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 20/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

@testable import lalamove_challenge_ios
import UIKit.UIButton

class MockDeliveryDetailViewController: DeliveryDetailViewControllerInterface {
    
    var favButtonTitle: String? = nil
    
    var favBtnHasSetup = false
    var favBtnUpdated = false
    
    var infoViewHasSetup = false
    var infoViewUpdated = false
    
    var navBarTitleHasSetup = false
    
    func setupFavBtn(favBtn: UIButton) {
        favBtnHasSetup = true
        favButtonTitle = favBtn.title(for: .normal)
    }
    
    func setupInfoView(infoView: DeliveryDetailInfoView) {
        infoViewHasSetup = true
    }
    
    func updateFavBtnTitle(title: String) {
        favBtnUpdated = true
        favButtonTitle = title
    }
    
    func updateInfoView(config: DeliveryDetailInfoViewConfiguration) {
        infoViewUpdated = true
    }
    
    func setupNavigationBarTitle() {
        navBarTitleHasSetup = true
    }
    
    
}
