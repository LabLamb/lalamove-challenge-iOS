//
//  DeliveryDetailViewController.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import SnapKit

class DeliveryDetailViewController: UIViewController {
    fileprivate let navTitle = "Delivery Details"
    private let addFavoriteBtnText = "Add to Favorite ❤️"
    private let removeFavoriteBtnText = "Remove from Favorite 💔"
    private var favoriteButton: UIButton?
}

extension DeliveryDetailViewController: DeliveryDetailViewControllerInterface {
    func toggleFavBtn(isFav: Bool) {
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
    
}
