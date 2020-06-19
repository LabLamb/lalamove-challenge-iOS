//
//  UITableView+ReloadDelivery.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UITableView

protocol Refreashable {
    func refresh()
}

protocol DeliveryTableViewRefreshable {
//    func refresh(at index: IndexPath)
}

extension UITableView: Refreashable, DeliveryTableViewRefreshable {
    func refresh() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
    }
    
//    func refresh(at index: IndexPath) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.reloadRows(at: [index], with: .)
//        }
//    }
}
