//
//  UITableView+ReloadDelivery.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 18/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit.UITableView

protocol DeliveryMasterTableView {
    func reloadDeliveries()
}

extension UITableView: DeliveryMasterTableView {
    func reloadDeliveries() {
        self.reloadData()
    }
}
